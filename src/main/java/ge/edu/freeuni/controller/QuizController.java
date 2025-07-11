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

            // Randomize questions if quiz has random order enabled
            if (quiz.isRandomOrder()) {
                Collections.shuffle(quizQuestions);
                System.out.println("DEBUG: Questions randomized for quiz " + quizId);
            } else {
                System.out.println("DEBUG: Questions kept in original order for quiz " + quizId);
            }

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
            Map<String, Object> correctAnswersMap = new HashMap<>(); // Changed to Object to handle different types
            Map<String, Boolean> gradingResults = new HashMap<>(); // Store grading results
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
                        // Trim each value and join with commas only (no spaces) to work with Multi_Choice_Multi_Answer.isCorrect()
                        List<String> trimmedValues = new ArrayList<>();
                        for (String value : selectedValues) {
                            trimmedValues.add(value.trim());
                        }
                        userAnswer = String.join(",", trimmedValues); // No spaces after commas for isCorrect() method
                    }

                    System.out.println("Multiple checkbox values: " + Arrays.toString(selectedValues));
                } else if (question instanceof Matching) {
                    // Handle matching questions - first check standard parameter format
                    userAnswer = request.getParameter(paramName1);
                    if (userAnswer == null) {
                        userAnswer = request.getParameter(paramName2);
                    }

                    System.out.println("DEBUG: Processing Matching question " + question.getQuestionID());
                    System.out.println("DEBUG: Found matching answer: " + userAnswer);
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

                // Store user answer for display
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    String displayAnswer = userAnswer.trim();
                    // For Multi_Choice_Multi_Answer, format display with spaces for readability
                    if (question instanceof Multi_Choice_Multi_Answer && displayAnswer.contains(",")) {
                        String[] parts = displayAnswer.split(",");
                        List<String> trimmedParts = new ArrayList<>();
                        for (String part : parts) {
                            trimmedParts.add(part.trim());
                        }
                        displayAnswer = String.join(", ", trimmedParts);
                    }
                    userAnswers.put(String.valueOf(question.getQuestionID()), displayAnswer);
                } else {
                    userAnswers.put(String.valueOf(question.getQuestionID()), "");
                }

                // Get correct answer for display using the question's method
                Object correctAnswer = question.getCorrectAnswer();

                // Format correct answers for display - handle all question types
                if (question instanceof Matching) {
                    Map<String, String> pairs = (Map<String, String>) correctAnswer;
                    List<String> formattedPairs = new ArrayList<>();
                    for (Map.Entry<String, String> entry : pairs.entrySet()) {
                        formattedPairs.add(entry.getKey() + "=" + entry.getValue());
                    }
                    correctAnswer = String.join(";", formattedPairs); // Use semicolons like the input format
                }
                // For Multi_Choice_Multi_Answer AND Multi_Answer, format display with spaces for readability
                else if (question instanceof Multi_Choice_Multi_Answer || question instanceof Multi_Answer) {
                    List<String> answers = (List<String>) correctAnswer;
                    correctAnswer = String.join(", ", answers); // Display with spaces for readability
                }

                correctAnswersMap.put(String.valueOf(question.getQuestionID()), correctAnswer);

                // Use the question's built-in isCorrect method
                boolean isCorrect = false;
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    isCorrect = question.isCorrect(userAnswer);

                    // Special debug for matching questions
                    if (question instanceof Matching && !isCorrect) {
                        System.out.println("DEBUG: Matching question failed. Analyzing...");
                        System.out.println("DEBUG: User answer: '" + userAnswer + "'");

                        // Try to normalize special characters as fallback
                        String normalizedAnswer = userAnswer
                                .replace("?", "ć")  // Common encoding issue
                                .replace("Ã¡", "á")  // Another common encoding issue
                                .replace("Ã©", "é")  // Another common encoding issue
                                .replace("Ã­", "í")  // Another common encoding issue
                                .replace("Ã³", "ó")  // Another common encoding issue
                                .replace("Ãº", "ú");  // Another common encoding issue

                        System.out.println("DEBUG: Trying normalized answer: '" + normalizedAnswer + "'");

                        if (!normalizedAnswer.equals(userAnswer)) {
                            isCorrect = question.isCorrect(normalizedAnswer);
                            System.out.println("DEBUG: Normalized result: " + isCorrect);
                        }
                    }
                }

                System.out.println("Correct answer: " + correctAnswer);
                System.out.println("Is correct: " + isCorrect);

                // Store the grading result
                gradingResults.put(String.valueOf(question.getQuestionID()), isCorrect);

                if (isCorrect) {
                    score++;
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
            mav.addObject("gradingResults", gradingResults); // Pass grading results to JSP

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