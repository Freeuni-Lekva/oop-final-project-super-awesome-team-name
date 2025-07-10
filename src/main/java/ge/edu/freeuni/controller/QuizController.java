package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.QuizDAO;
import ge.edu.freeuni.dao.QuizAttemptDao;
import ge.edu.freeuni.dao.AchievementDao;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import ge.edu.freeuni.model.QuizEngine.Question.*;
import ge.edu.freeuni.model.QuizAttempt;
import ge.edu.freeuni.model.Achievement;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.util.*;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    @Autowired
    private QuizDAO quizzes;

    @Autowired
    private QuizAttemptDao quizAttempts;

    @Autowired
    private AchievementDao achievements;

    private Gson gson = new Gson();

    @GetMapping("/ping")
    @ResponseBody
    public String ping() {
        return "Quiz controller is working!";
    }

    @GetMapping
    public ModelAndView listQuizzes() {
        ModelAndView mav = new ModelAndView("quiz-list");

        try {
            System.out.println("DEBUG: Getting all quizzes...");
            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            System.out.println("DEBUG: Found " + allQuizzes.size() + " total quizzes");

            System.out.println("DEBUG: Getting popular quizzes...");
            List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);
            System.out.println("DEBUG: Found " + popularQuizzes.size() + " popular quizzes");

            mav.addObject("allQuizzes", allQuizzes);
            mav.addObject("popularQuizzes", popularQuizzes);

            return mav;
        } catch (Exception e) {
            System.err.println("ERROR in listQuizzes: " + e.getMessage());
            e.printStackTrace();

            mav.addObject("error", "Failed to load quizzes: " + e.getMessage());
            mav.addObject("allQuizzes", new ArrayList<Quiz>());
            mav.addObject("popularQuizzes", new ArrayList<Quiz>());
            return mav;
        }
    }

    @GetMapping("/{quizId}")
    public ModelAndView showQuizDetails(@PathVariable int quizId, HttpSession session) {
        String userName = (String) session.getAttribute("name");


        ModelAndView mav = new ModelAndView("quiz-details");

        try {
            Quiz quiz = quizzes.getQuiz(quizId);
            if (quiz == null) {
                mav.setViewName("redirect:/quiz");
                mav.addObject("error", "Quiz not found");
                return mav;
            }

            List<QuizAttempt> allUserAttempts = quizAttempts.getAttemptsForUser(userName);
            List<QuizAttempt> userAttempts = new ArrayList<>();
            for (QuizAttempt attempt : allUserAttempts) {
                if (attempt.getQuizId() == quizId) {
                    userAttempts.add(attempt);
                }
            }

            List<QuizAttempt> topScores = quizAttempts.getTopScoresForQuiz(quizId, 5);
            int questionCount = quiz.getNQuestions();

            mav.addObject("quiz", quiz);
            mav.addObject("userAttempts", userAttempts);
            mav.addObject("topScores", topScores);
            mav.addObject("questionCount", questionCount);
            mav.addObject("userName", userName);

            return mav;
        } catch (Exception e) {
            System.err.println("ERROR in showQuizDetails: " + e.getMessage());
            e.printStackTrace();

            mav.setViewName("redirect:/quiz");
            mav.addObject("error", "Failed to load quiz details");
            return mav;
        }
    }

    @GetMapping("/{quizId}/take")
    public ModelAndView takeQuiz(@PathVariable int quizId,
                                 @RequestParam(defaultValue = "false") boolean practiceMode,
                                 HttpSession session) {
        String userName = (String) session.getAttribute("name");


        try {
            Quiz quiz = quizzes.getQuiz(quizId);
            if (quiz == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Quiz not found");
                return mav;
            }

            if (practiceMode && !quiz.isPracticeMode()) {
                ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
                mav.addObject("error", "Practice mode not available for this quiz");
                return mav;
            }

            List<Question> quizQuestions = quizzes.getQuestions(quizId);
            System.out.println("DEBUG: Found " + quizQuestions.size() + " questions for quiz " + quizId);

            ModelAndView mav = new ModelAndView("take-quiz");
            mav.addObject("quiz", quiz);
            mav.addObject("questions", quizQuestions);
            mav.addObject("practiceMode", practiceMode);
            mav.addObject("userName", userName);

            session.setAttribute("quizStartTime", System.currentTimeMillis());
            return mav;
        } catch (Exception e) {
            System.err.println("ERROR in takeQuiz: " + e.getMessage());
            e.printStackTrace();

            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to load quiz for taking");
            return mav;
        }
    }

    @PostMapping("/{quizId}/submit")
    public ModelAndView submitQuiz(@PathVariable int quizId,
                                   HttpServletRequest request,
                                   @RequestParam(defaultValue = "false") boolean practiceMode,
                                   HttpSession session) {
        String userName = (String) session.getAttribute("name");


        try {
            Quiz quiz = quizzes.getQuiz(quizId);
            if (quiz == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Quiz not found");
                return mav;
            }

            Long startTime = (Long) session.getAttribute("quizStartTime");
            int timeTaken = startTime != null ?
                    (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;

            List<Question> quizQuestions = quizzes.getQuestions(quizId);

            Map<String, String> userAnswers = new HashMap<>();
            Map<String, List<String>> correctAnswersMap = new HashMap<>();
            int score = 0;

            System.out.println("=== DEBUG: Request Parameters ===");
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("Parameter: " + paramName + " = " + paramValue);
            }

            for (int i = 0; i < quizQuestions.size(); i++) {
                Question question = quizQuestions.get(i);

                // Try multiple parameter name formats
                String paramName1 = "question_" + question.getQuestionID();
                String paramName2 = "question_" + i;

                String userAnswer = request.getParameter(paramName1);
                if (userAnswer == null) {
                    userAnswer = request.getParameter(paramName2);
                }

                System.out.println("=== DEBUG: Question " + question.getQuestionID() + " (index " + i + ") ===");
                System.out.println("Parameter names tried: " + paramName1 + ", " + paramName2);
                System.out.println("User answer: " + userAnswer);
                System.out.println("Question type: " + question.getClass().getSimpleName());

                //keep answer for user
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    userAnswers.put(String.valueOf(question.getQuestionID()), userAnswer.trim());
                } else {
                    userAnswers.put(String.valueOf(question.getQuestionID()), "");
                }

                //if 1 wrong - 0
                if (question instanceof Multi_Answer) {
                    Multi_Answer maQuestion = (Multi_Answer) question;
                    List<String> allCorrectAnswers = maQuestion.getCorrectAnswer();

                    //display corr ans
                    correctAnswersMap.put(String.valueOf(question.getQuestionID()), allCorrectAnswers);

                    //parsing
                    Set<String> userAnswerSet = new HashSet<>();
                    if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                        String[] userAnswerArray = userAnswer.split(",");
                        for (String ans : userAnswerArray) {
                            userAnswerSet.add(ans.trim().toLowerCase());
                        }
                    }

                    // Create set of correct answers (normalized)
                    Set<String> correctAnswerSet = new HashSet<>();
                    for (String correct : allCorrectAnswers) {
                        correctAnswerSet.add(correct.toLowerCase());
                    }

                    // ✅ STRICT: Must match EXACTLY (same size, same content)
                    boolean isCorrect = userAnswerSet.size() == correctAnswerSet.size() &&
                            userAnswerSet.equals(correctAnswerSet);

                    System.out.println("Multi-Answer Grading:");
                    System.out.println("  Required: " + correctAnswerSet);
                    System.out.println("  User provided: " + userAnswerSet);
                    System.out.println("  Exact match: " + isCorrect);

                    if (isCorrect) {
                        score++;
                    }

                } else {
                    // ✅ STANDARD GRADING for other question types
                    List<String> correctAnswers = new ArrayList<>();

                    if (question instanceof Question_Response) {
                        correctAnswers.add(((Question_Response) question).getCorrectAnswer());
                    } else if (question instanceof Fill_In_The_Blank) {
                        correctAnswers.add(((Fill_In_The_Blank) question).getCorrectAnswer());
                    } else if (question instanceof Multiple_Choice) {
                        correctAnswers.add(((Multiple_Choice) question).getCorrectAnswer());
                    } else if (question instanceof Picture_Response) {
                        correctAnswers.add(((Picture_Response) question).getCorrectAnswer());
                    } else if (question instanceof Multi_Choice_Multi_Answer) {
                        correctAnswers.addAll(((Multi_Choice_Multi_Answer) question).getCorrectAnswer());
                    } else if (question instanceof Matching) {
                        Map<String, String> pairs = ((Matching) question).getCorrectAnswer();
                        for (Map.Entry<String, String> entry : pairs.entrySet()) {
                            correctAnswers.add(entry.getKey() + "=" + entry.getValue());
                        }
                    }

                    correctAnswersMap.put(String.valueOf(question.getQuestionID()), correctAnswers);

                    System.out.println("Standard grading - Correct answers: " + correctAnswers);

                    // Check if answer is correct (case insensitive)
                    boolean isCorrect = false;
                    if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                        for (String correct : correctAnswers) {
                            if (correct.equalsIgnoreCase(userAnswer.trim())) {
                                isCorrect = true;
                                break;
                            }
                        }
                    }

                    System.out.println("Is correct: " + isCorrect);

                    if (isCorrect) {
                        score++;
                    }
                }
            }

            String userAnswersJson = gson.toJson(userAnswers);
            String correctAnswersJson = gson.toJson(correctAnswersMap);

            System.out.println("=== DEBUG: Final Results ===");
            System.out.println("Total score: " + score + "/" + quizQuestions.size());
            System.out.println("User answers JSON: " + userAnswersJson);
            System.out.println("Correct answers JSON: " + correctAnswersJson);

            // Save attempt if not practice mode
            int attemptId = -1;
            if (!practiceMode) {
                attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                        timeTaken, userAnswersJson, correctAnswersJson, false);
                List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
            }

            // Prepare results view
            ModelAndView mav = new ModelAndView("quiz-results");
            mav.addObject("quiz", quiz);
            mav.addObject("score", score);
            mav.addObject("totalQuestions", quizQuestions.size());
            mav.addObject("timeTaken", timeTaken);
            mav.addObject("practiceMode", practiceMode);
            mav.addObject("userName", userName);
            mav.addObject("questions", quizQuestions);
            mav.addObject("userAnswers", userAnswers);
            mav.addObject("correctAnswersMap", correctAnswersMap);

            double percentage = quizQuestions.size() > 0 ?
                    (double) score / quizQuestions.size() * 100 : 0;
            mav.addObject("percentage", percentage);

            return mav;
        } catch (Exception e) {
            System.err.println("ERROR in submitQuiz: " + e.getMessage());
            e.printStackTrace();

            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to submit quiz");
            return mav;
        }
    }
}