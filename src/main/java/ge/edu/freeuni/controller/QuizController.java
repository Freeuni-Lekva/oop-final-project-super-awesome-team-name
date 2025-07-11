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

    private String normalizeString(String input) {
        if (input == null) return "";

        return input.toLowerCase()
                .trim()
                // Handle common character encoding issues
                .replace("ć", "c")
                .replace("?", "c")  // Handle encoding corruption
                .replace("š", "s")
                .replace("ž", "z")
                .replace("đ", "d")
                .replace("č", "c")
                // Add more character normalizations as needed
                ;
    }

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

                String userAnswer = null;

                // Handle multiple choice with multiple answers (checkboxes)
                if (question instanceof Multi_Choice_Multi_Answer) {
                    String[] selectedValues1 = request.getParameterValues(paramName1);
                    String[] selectedValues2 = request.getParameterValues(paramName2);

                    String[] selectedValues = selectedValues1 != null ? selectedValues1 : selectedValues2;

                    if (selectedValues != null && selectedValues.length > 0) {
                        userAnswer = String.join(", ", selectedValues);
                    }

                    System.out.println("Multiple checkbox values: " + Arrays.toString(selectedValues));
                } else {
                    // Handle single-value questions (radio buttons, text, etc.)
                    userAnswer = request.getParameter(paramName1);
                    if (userAnswer == null) {
                        userAnswer = request.getParameter(paramName2);
                    }
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
                        List<String> allCorrectAnswers = ((Multi_Choice_Multi_Answer) question).getCorrectAnswer();
                        correctAnswers.addAll(allCorrectAnswers);

                        // Special handling for multiple choice multiple answers
                        boolean isCorrect = false;
                        if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                            // Split user answers and normalize
                            String[] userAnswerArray = userAnswer.split(",");
                            Set<String> userAnswerSet = new HashSet<>();
                            for (String ans : userAnswerArray) {
                                userAnswerSet.add(ans.trim().toLowerCase());
                            }

                            // Create set of correct answers (normalized)
                            Set<String> correctAnswerSet = new HashSet<>();
                            for (String correct : allCorrectAnswers) {
                                correctAnswerSet.add(correct.trim().toLowerCase());
                            }

                            // Must match exactly (same size, same content)
                            isCorrect = userAnswerSet.size() == correctAnswerSet.size() &&
                                    userAnswerSet.equals(correctAnswerSet);

                            System.out.println("Multi-Choice-Multi-Answer Grading:");
                            System.out.println("  Required: " + correctAnswerSet);
                            System.out.println("  User provided: " + userAnswerSet);
                            System.out.println("  Exact match: " + isCorrect);
                        }

                        correctAnswersMap.put(String.valueOf(question.getQuestionID()), correctAnswers);

                        if (isCorrect) {
                            score++;
                        }

                        // Skip standard grading for this question type
                        continue;
                    } else if (question instanceof Matching) {
                        Map<String, String> pairs = ((Matching) question).getCorrectAnswer();

                        // Build expected answer for display (use same order as user for consistency)
                        List<String> displayCorrectAnswers = new ArrayList<>();
                        for (Map.Entry<String, String> entry : pairs.entrySet()) {
                            displayCorrectAnswers.add(entry.getKey() + "=" + entry.getValue());
                        }
                        correctAnswersMap.put(String.valueOf(question.getQuestionID()), displayCorrectAnswers);

                        // Grade matching question - ORDER INDEPENDENT
                        boolean isCorrect = false;
                        if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                            // Split user answer into pairs
                            String[] userPairs = userAnswer.split(",");
                            Set<String> userPairSet = new HashSet<>();
                            for (String pair : userPairs) {
                                String cleanPair = pair.trim().toLowerCase();
                                userPairSet.add(cleanPair);
                            }

                            // Create set of correct pairs
                            Set<String> correctPairSet = new HashSet<>();
                            for (Map.Entry<String, String> entry : pairs.entrySet()) {
                                String correctPair = (entry.getKey() + "=" + entry.getValue()).toLowerCase();
                                correctPairSet.add(correctPair);
                            }

                            // Compare sets (order doesn't matter)
                            isCorrect = userPairSet.equals(correctPairSet);

                            System.out.println("Matching grading (order independent):");
                            System.out.println("  User pairs: " + userPairSet);
                            System.out.println("  Correct pairs: " + correctPairSet);
                            System.out.println("  Sets equal: " + isCorrect);

                            // Debug: Check each pair individually
                            for (String userPair : userPairSet) {
                                boolean found = correctPairSet.contains(userPair);
                                System.out.println("  '" + userPair + "' found: " + found);
                            }
                        }

                        if (isCorrect) {
                            score++;
                        }

                        // Skip standard grading
                        continue;
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