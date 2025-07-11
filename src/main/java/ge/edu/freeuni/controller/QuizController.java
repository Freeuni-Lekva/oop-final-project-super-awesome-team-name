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
                                 @RequestParam(defaultValue = "0") int questionIndex,
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

            // For multi-page mode, only shuffle and store questions ONCE at the beginning
            if (!quiz.isOnePage()) {
                List<Question> storedQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

                if (storedQuestions == null || questionIndex == 0) {
                    // First time or explicitly starting over - shuffle and store
                    if (quiz.isRandomOrder()) {
                        Collections.shuffle(quizQuestions);
                        System.out.println("DEBUG: Questions randomized for quiz " + quizId);
                    } else {
                        System.out.println("DEBUG: Questions kept in original order for quiz " + quizId);
                    }
                    session.setAttribute("quizQuestions_" + quizId, quizQuestions);

                    // Clear any existing session data when starting over
                    if (questionIndex == 0) {
                        session.removeAttribute("quizAnswers_" + quizId);
                        session.removeAttribute("quizCorrectAnswers_" + quizId);
                        session.removeAttribute("quizGradingResults_" + quizId);
                        System.out.println("DEBUG: Cleared existing session data for fresh start");
                    }
                } else {
                    // Use stored questions to maintain consistent order
                    quizQuestions = storedQuestions;
                    System.out.println("DEBUG: Using stored questions for quiz " + quizId + " (maintaining order)");
                }
            } else {
                // Single page mode - shuffle normally
                if (quiz.isRandomOrder()) {
                    Collections.shuffle(quizQuestions);
                    System.out.println("DEBUG: Questions randomized for quiz " + quizId);
                } else {
                    System.out.println("DEBUG: Questions kept in original order for quiz " + quizId);
                }
                // Store questions in session for single page mode too
                session.setAttribute("quizQuestions_" + quizId, quizQuestions);
            }

            if (quiz.isOnePage()) {
                // SINGLE PAGE MODE: Show all questions at once
                System.out.println("DEBUG: Using single page mode for quiz " + quizId);
                ModelAndView mav = new ModelAndView("take-quiz");
                mav.addObject("quiz", quiz);
                mav.addObject("questions", quizQuestions);
                mav.addObject("practiceMode", practiceMode);
                mav.addObject("userName", userName);

                session.setAttribute("quizStartTime", System.currentTimeMillis());
                return mav;
            } else {
                // MULTIPLE PAGE MODE: Show one question at a time
                System.out.println("DEBUG: Using multiple page mode for quiz " + quizId + ", question index: " + questionIndex);

                if (questionIndex >= quizQuestions.size()) {
                    // Quiz completed, show results
                    return processMultiPageQuizCompletion(quizId, practiceMode, session);
                }

                // Initialize session data for multi-page quiz
                if (questionIndex == 0) {
                    session.setAttribute("quizStartTime", System.currentTimeMillis());
                    session.setAttribute("quizAnswers_" + quizId, new HashMap<String, String>());
                    session.setAttribute("quizCorrectAnswers_" + quizId, new HashMap<String, Object>());
                    session.setAttribute("quizGradingResults_" + quizId, new HashMap<String, Boolean>());
                    System.out.println("DEBUG: Initialized fresh session data for quiz " + quizId);
                }

                Question currentQuestion = quizQuestions.get(questionIndex);
                ModelAndView mav = new ModelAndView("take-quiz-single");
                mav.addObject("quiz", quiz);
                mav.addObject("question", currentQuestion);
                mav.addObject("questionIndex", questionIndex);
                mav.addObject("totalQuestions", quizQuestions.size());
                mav.addObject("practiceMode", practiceMode);
                mav.addObject("userName", userName);

                return mav;
            }
        } catch (Exception e) {
            System.err.println("ERROR in takeQuiz: " + e.getMessage());
            e.printStackTrace();

            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to load quiz for taking");
            return mav;
        }
    }

    @PostMapping("/{quizId}/submit-single")
    public ModelAndView submitSingleQuestion(@PathVariable int quizId,
                                             @RequestParam int questionIndex,
                                             @RequestParam(defaultValue = "false") boolean practiceMode,
                                             HttpServletRequest request,
                                             HttpSession session) {
        try {
            Quiz quiz = quizzes.getQuiz(quizId);
            List<Question> quizQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

            if (quiz == null || quizQuestions == null || questionIndex >= quizQuestions.size()) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Invalid quiz or question");
                return mav;
            }

            Question currentQuestion = quizQuestions.get(questionIndex);
            System.out.println("DEBUG: Processing single question " + currentQuestion.getQuestionID() + " (index " + questionIndex + ")");

            // Get user answer using the same logic as full quiz submission
            String userAnswer = extractUserAnswer(currentQuestion, request);

            System.out.println("DEBUG: User answer for question " + currentQuestion.getQuestionID() + ": '" + userAnswer + "'");

            // Get session maps - ensure they exist
            Map<String, String> allAnswers = (Map<String, String>) session.getAttribute("quizAnswers_" + quizId);
            Map<String, Object> allCorrectAnswers = (Map<String, Object>) session.getAttribute("quizCorrectAnswers_" + quizId);
            Map<String, Boolean> allGradingResults = (Map<String, Boolean>) session.getAttribute("quizGradingResults_" + quizId);

            if (allAnswers == null) {
                allAnswers = new HashMap<>();
                session.setAttribute("quizAnswers_" + quizId, allAnswers);
            }
            if (allCorrectAnswers == null) {
                allCorrectAnswers = new HashMap<>();
                session.setAttribute("quizCorrectAnswers_" + quizId, allCorrectAnswers);
            }
            if (allGradingResults == null) {
                allGradingResults = new HashMap<>();
                session.setAttribute("quizGradingResults_" + quizId, allGradingResults);
            }

            // Format user answer for display (but keep original for grading)
            String displayAnswer = formatUserAnswerForDisplay(currentQuestion, userAnswer);
            if (displayAnswer == null || displayAnswer.trim().isEmpty()) {
                displayAnswer = ""; // Store empty string instead of null
            }
            allAnswers.put(String.valueOf(currentQuestion.getQuestionID()), displayAnswer);

            System.out.println("DEBUG: Stored display answer: '" + displayAnswer + "'");

            // Get and format correct answer
            Object correctAnswer = currentQuestion.getCorrectAnswer();
            String formattedCorrectAnswer = formatCorrectAnswerForDisplay(currentQuestion, correctAnswer);
            allCorrectAnswers.put(String.valueOf(currentQuestion.getQuestionID()), formattedCorrectAnswer);

            // Grade the answer using the original userAnswer (not displayAnswer)
            boolean isCorrect = false;
            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                isCorrect = currentQuestion.isCorrect(userAnswer);

                // Character encoding fix for matching questions
                if (currentQuestion instanceof Matching && !isCorrect) {
                    String normalizedAnswer = userAnswer
                            .replace("?", "ć")
                            .replace("Ã¡", "á")
                            .replace("Ã©", "é")
                            .replace("Ã­", "í")
                            .replace("Ã³", "ó")
                            .replace("Ãº", "ú");

                    if (!normalizedAnswer.equals(userAnswer)) {
                        isCorrect = currentQuestion.isCorrect(normalizedAnswer);
                    }
                }
            }

            allGradingResults.put(String.valueOf(currentQuestion.getQuestionID()), isCorrect);

            System.out.println("DEBUG: Question " + currentQuestion.getQuestionID() + " is correct: " + isCorrect);

            // ALWAYS go directly to next question - NO immediate feedback page
            int nextIndex = questionIndex + 1;
            if (nextIndex >= quizQuestions.size()) {
                // Quiz completed
                return processMultiPageQuizCompletion(quizId, practiceMode, session);
            } else {
                // Go to next question
                return new ModelAndView("redirect:/quiz/" + quizId + "/take?questionIndex=" + nextIndex + "&practiceMode=" + practiceMode);
            }

        } catch (Exception e) {
            System.err.println("ERROR in submitSingleQuestion: " + e.getMessage());
            e.printStackTrace();

            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to submit answer");
            return mav;
        }
    }

    @GetMapping("/{quizId}/complete")
    public ModelAndView completeMultiPageQuiz(@PathVariable int quizId,
                                              @RequestParam(defaultValue = "false") boolean practiceMode,
                                              HttpSession session) {
        return processMultiPageQuizCompletion(quizId, practiceMode, session);
    }

    private ModelAndView processMultiPageQuizCompletion(int quizId, boolean practiceMode, HttpSession session) {
        try {
            String userName = (String) session.getAttribute("name");
            Quiz quiz = quizzes.getQuiz(quizId);
            List<Question> quizQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

            Map<String, String> userAnswers = (Map<String, String>) session.getAttribute("quizAnswers_" + quizId);
            Map<String, Object> correctAnswersMap = (Map<String, Object>) session.getAttribute("quizCorrectAnswers_" + quizId);
            Map<String, Boolean> gradingResults = (Map<String, Boolean>) session.getAttribute("quizGradingResults_" + quizId);

            if (quiz == null || quizQuestions == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Quiz session expired");
                return mav;
            }

            // Ensure session maps exist (fallback)
            if (userAnswers == null) {
                userAnswers = new HashMap<>();
                System.out.println("DEBUG: userAnswers was null, created new HashMap");
            }
            if (correctAnswersMap == null) {
                correctAnswersMap = new HashMap<>();
                System.out.println("DEBUG: correctAnswersMap was null, created new HashMap");
            }
            if (gradingResults == null) {
                gradingResults = new HashMap<>();
                System.out.println("DEBUG: gradingResults was null, created new HashMap");
            }

            System.out.println("DEBUG: Final userAnswers content: " + userAnswers);
            System.out.println("DEBUG: Final gradingResults content: " + gradingResults);

            // Calculate score
            int score = 0;
            for (Boolean result : gradingResults.values()) {
                if (result != null && result) {
                    score++;
                }
            }

            Long startTime = (Long) session.getAttribute("quizStartTime");
            int timeTaken = startTime != null ? (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;

            // Save attempt if not practice mode
            if (!practiceMode) {
                String userAnswersJson = gson.toJson(userAnswers);
                String correctAnswersJson = gson.toJson(correctAnswersMap);

                int attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                        timeTaken, userAnswersJson, correctAnswersJson, false);
                List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
            }

            // Clean up session
            session.removeAttribute("quizQuestions_" + quizId);
            session.removeAttribute("quizAnswers_" + quizId);
            session.removeAttribute("quizCorrectAnswers_" + quizId);
            session.removeAttribute("quizGradingResults_" + quizId);
            session.removeAttribute("quizStartTime");

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
            mav.addObject("gradingResults", gradingResults);

            double percentage = quizQuestions.size() > 0 ? (double) score / quizQuestions.size() * 100 : 0;
            mav.addObject("percentage", percentage);

            System.out.println("DEBUG: Multi-page quiz completed. Score: " + score + "/" + quizQuestions.size());
            return mav;
        } catch (Exception e) {
            System.err.println("ERROR in processMultiPageQuizCompletion: " + e.getMessage());
            e.printStackTrace();

            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to complete quiz");
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

            // This should only be called for single-page quizzes
            if (!quiz.isOnePage()) {
                ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId + "/take");
                mav.addObject("error", "This quiz should be taken in multi-page mode");
                return mav;
            }

            Long startTime = (Long) session.getAttribute("quizStartTime");
            int timeTaken = startTime != null ?
                    (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;

            List<Question> quizQuestions = quizzes.getQuestions(quizId);

            Map<String, String> userAnswers = new HashMap<>();
            Map<String, Object> correctAnswersMap = new HashMap<>();
            Map<String, Boolean> gradingResults = new HashMap<>();
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

                // Extract user answer
                String userAnswer = extractUserAnswer(question, request);

                System.out.println("=== DEBUG: Question " + question.getQuestionID() + " (index " + i + ") ===");
                System.out.println("User answer: " + userAnswer);
                System.out.println("Question type: " + question.getClass().getSimpleName());

                // Format user answer for display
                String displayAnswer = formatUserAnswerForDisplay(question, userAnswer);
                userAnswers.put(String.valueOf(question.getQuestionID()), displayAnswer);

                // Get and format correct answer for display
                Object correctAnswer = question.getCorrectAnswer();
                String formattedCorrectAnswer = formatCorrectAnswerForDisplay(question, correctAnswer);
                correctAnswersMap.put(String.valueOf(question.getQuestionID()), formattedCorrectAnswer);

                // Grade the answer
                boolean isCorrect = false;
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    isCorrect = question.isCorrect(userAnswer);

                    // Character encoding fix for matching questions
                    if (question instanceof Matching && !isCorrect) {
                        System.out.println("DEBUG: Matching question failed. Analyzing...");
                        String normalizedAnswer = userAnswer
                                .replace("?", "ć")
                                .replace("Ã¡", "á")
                                .replace("Ã©", "é")
                                .replace("Ã­", "í")
                                .replace("Ã³", "ó")
                                .replace("Ãº", "ú");

                        if (!normalizedAnswer.equals(userAnswer)) {
                            isCorrect = question.isCorrect(normalizedAnswer);
                            System.out.println("DEBUG: Normalized result: " + isCorrect);
                        }
                    }
                }

                System.out.println("Correct answer: " + formattedCorrectAnswer);
                System.out.println("Is correct: " + isCorrect);

                gradingResults.put(String.valueOf(question.getQuestionID()), isCorrect);

                if (isCorrect) {
                    score++;
                }
            }

            String userAnswersJson = gson.toJson(userAnswers);
            String correctAnswersJson = gson.toJson(correctAnswersMap);

            System.out.println("=== DEBUG: Final Results ===");
            System.out.println("Total score: " + score + "/" + quizQuestions.size());

            // Save attempt if not practice mode
            if (!practiceMode) {
                int attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
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
            mav.addObject("gradingResults", gradingResults);

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

    private String extractUserAnswer(Question question, HttpServletRequest request) {
        String paramName1 = "question_" + question.getQuestionID();

        String userAnswer = null;

        if (question instanceof Multi_Choice_Multi_Answer) {
            String[] selectedValues = request.getParameterValues(paramName1);
            if (selectedValues != null && selectedValues.length > 0) {
                List<String> trimmedValues = new ArrayList<>();
                for (String value : selectedValues) {
                    trimmedValues.add(value.trim());
                }
                userAnswer = String.join(",", trimmedValues);
            }
            System.out.println("DEBUG: Multiple checkbox values: " + Arrays.toString(selectedValues));
        } else if (question instanceof Matching) {
            userAnswer = request.getParameter(paramName1);
            System.out.println("DEBUG: Processing Matching question " + question.getQuestionID());
        } else {
            // All other question types (text input, radio buttons)
            userAnswer = request.getParameter(paramName1);
        }

        // Debug: show what we extracted
        System.out.println("DEBUG: Extracted answer for question " + question.getQuestionID() + ": '" + userAnswer + "'");

        // Debug: show all parameters for this question
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            if (paramName.contains(String.valueOf(question.getQuestionID()))) {
                System.out.println("DEBUG: Found parameter: " + paramName + " = " + request.getParameter(paramName));
            }
        }

        return userAnswer;
    }

    private String formatUserAnswerForDisplay(Question question, String userAnswer) {
        if (userAnswer == null) {
            System.out.println("DEBUG: userAnswer is null, returning empty string");
            return "";
        }

        if (userAnswer.trim().isEmpty()) {
            System.out.println("DEBUG: userAnswer is empty, returning empty string");
            return "";
        }

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

        System.out.println("DEBUG: Formatted display answer: '" + displayAnswer + "'");
        return displayAnswer;
    }

    private String formatCorrectAnswerForDisplay(Question question, Object correctAnswer) {
        if (question instanceof Matching) {
            Map<String, String> pairs = (Map<String, String>) correctAnswer;
            List<String> formattedPairs = new ArrayList<>();
            for (Map.Entry<String, String> entry : pairs.entrySet()) {
                formattedPairs.add(entry.getKey() + "=" + entry.getValue());
            }
            return String.join(";", formattedPairs);
        } else if (question instanceof Multi_Choice_Multi_Answer || question instanceof Multi_Answer) {
            List<String> answers = (List<String>) correctAnswer;
            return String.join(", ", answers);
        } else {
            return (String) correctAnswer;
        }
    }
}