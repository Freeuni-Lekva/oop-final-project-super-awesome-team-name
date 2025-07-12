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

            List<Quiz> allQuizzes = quizzes.getAllQuizzes();
            List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);
            mav.addObject("allQuizzes", allQuizzes);
            mav.addObject("popularQuizzes", popularQuizzes);

            return mav;
        } catch (Exception e) {
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

            //  multi-page mode
            if (!quiz.isOnePage()) {
                List<Question> storedQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

                if (storedQuestions == null || questionIndex == 0) {
                    if (quiz.isRandomOrder()) {
                        Collections.shuffle(quizQuestions);
                    }
                    session.setAttribute("quizQuestions_" + quizId, quizQuestions);
                    //refreshingggggggg
                    if (questionIndex == 0) {
                        session.removeAttribute("quizAnswers_" + quizId);
                        session.removeAttribute("quizCorrectAnswers_" + quizId);
                        session.removeAttribute("quizGradingResults_" + quizId);
                    }
                } else {
                    quizQuestions = storedQuestions;
                }
            } else {
                // Single page mode
                if (quiz.isRandomOrder()) {
                    Collections.shuffle(quizQuestions);
                }
                session.setAttribute("quizQuestions_" + quizId, quizQuestions);
            }

            if (quiz.isOnePage()) {
                ModelAndView mav = new ModelAndView("take-quiz");
                mav.addObject("quiz", quiz);
                mav.addObject("questions", quizQuestions);
                mav.addObject("practiceMode", practiceMode);
                mav.addObject("userName", userName);

                session.setAttribute("quizStartTime", System.currentTimeMillis());
                return mav;
            } else {
                if (questionIndex >= quizQuestions.size()) {
                    return processMultiPageQuizCompletion(quizId, practiceMode, session);
                }

                if (questionIndex == 0) {
                    session.setAttribute("quizStartTime", System.currentTimeMillis());
                    session.setAttribute("quizAnswers_" + quizId, new HashMap<String, String>());
                    session.setAttribute("quizCorrectAnswers_" + quizId, new HashMap<String, Object>());
                    session.setAttribute("quizGradingResults_" + quizId, new HashMap<String, Boolean>());
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

            if (quiz.isImmediateCorrection()) {
                ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId + "/take?questionIndex=" + questionIndex + "&practiceMode=" + practiceMode);
                mav.addObject("error", "This quiz uses immediate correction mode");
                return mav;
            }

            Question currentQuestion = quizQuestions.get(questionIndex);
            String userAnswer = extractUserAnswer(currentQuestion, request);
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

            String displayAnswer = formatUserAnswerForDisplay(currentQuestion, userAnswer);
            if (displayAnswer == null || displayAnswer.trim().isEmpty()) {
                displayAnswer = "";
            }
            allAnswers.put(String.valueOf(currentQuestion.getQuestionID()), displayAnswer);

            Object correctAnswer = currentQuestion.getCorrectAnswer();
            String formattedCorrectAnswer = formatCorrectAnswerForDisplay(currentQuestion, correctAnswer);
            allCorrectAnswers.put(String.valueOf(currentQuestion.getQuestionID()), formattedCorrectAnswer);

            boolean isCorrect = false;
            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                isCorrect = currentQuestion.isCorrect(userAnswer);

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

            int nextIndex = questionIndex + 1;
            if (nextIndex >= quizQuestions.size()) {
                //completed
                return processMultiPageQuizCompletion(quizId, practiceMode, session);
            } else {
                //to next question
                return new ModelAndView("redirect:/quiz/" + quizId + "/take?questionIndex=" + nextIndex + "&practiceMode=" + practiceMode);
            }

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to submit answer");
            return mav;
        }
    }

    @PostMapping("/{quizId}/submit-answer")
    @ResponseBody
    public Map<String, Object> submitAnswerWithFeedback(@PathVariable int quizId,
                                                        HttpServletRequest request,
                                                        HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String questionIndexStr = request.getParameter("questionIndex");
            String practiceModeStr = request.getParameter("practiceMode");

            if (questionIndexStr == null) {
                response.put("success", false);
                response.put("message", "Missing questionIndex parameter");
                return response;
            }

            int questionIndex;
            boolean practiceMode = "true".equals(practiceModeStr);

            try {
                questionIndex = Integer.parseInt(questionIndexStr);
            } catch (NumberFormatException e) {
                response.put("success", false);
                response.put("message", "Invalid questionIndex: " + questionIndexStr);
                return response;
            }

            Quiz quiz = quizzes.getQuiz(quizId);
            List<Question> quizQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

            if (quiz == null) {
                response.put("success", false);
                response.put("message", "Quiz not found: " + quizId);
                return response;
            }

            if (quizQuestions == null) {
                response.put("success", false);
                response.put("message", "Quiz session expired");
                return response;
            }

            if (questionIndex >= quizQuestions.size()) {
                response.put("success", false);
                response.put("message", "Invalid question index: " + questionIndex);
                return response;
            }

            Question currentQuestion = quizQuestions.get(questionIndex);
            String userAnswer = extractUserAnswer(currentQuestion, request);
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


            String displayAnswer = formatUserAnswerForDisplay(currentQuestion, userAnswer);
            if (displayAnswer == null || displayAnswer.trim().isEmpty()) {
                displayAnswer = "";
            }
            allAnswers.put(String.valueOf(currentQuestion.getQuestionID()), displayAnswer);


            Object correctAnswer = currentQuestion.getCorrectAnswer();
            String formattedCorrectAnswer = formatCorrectAnswerForDisplay(currentQuestion, correctAnswer);
            allCorrectAnswers.put(String.valueOf(currentQuestion.getQuestionID()), formattedCorrectAnswer);


            boolean isCorrect = false;
            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                isCorrect = currentQuestion.isCorrect(userAnswer);
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

            response.put("success", true);
            response.put("isCorrect", isCorrect);
            response.put("userAnswer", displayAnswer);
            response.put("correctAnswer", formattedCorrectAnswer);
            response.put("questionIndex", questionIndex);
            response.put("totalQuestions", quizQuestions.size());
            response.put("isLastQuestion", (questionIndex + 1) >= quizQuestions.size());

        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Failed to process answer: " + e.getMessage());
        }

        return response;
    }

    @PostMapping("/{quizId}/continue")
    public ModelAndView continueToNextQuestion(@PathVariable int quizId,
                                               @RequestParam int questionIndex,
                                               @RequestParam(defaultValue = "false") boolean practiceMode,
                                               HttpSession session) {
        try {
            List<Question> quizQuestions = (List<Question>) session.getAttribute("quizQuestions_" + quizId);

            if (quizQuestions == null) {
                ModelAndView mav = new ModelAndView("redirect:/quiz");
                mav.addObject("error", "Quiz session expired");
                return mav;
            }

            int nextIndex = questionIndex + 1;
            if (nextIndex >= quizQuestions.size()) {
                //completed
                return processMultiPageQuizCompletion(quizId, practiceMode, session);
            } else {
                //to next question
                return new ModelAndView("redirect:/quiz/" + quizId + "/take?questionIndex=" + nextIndex + "&practiceMode=" + practiceMode);
            }

        } catch (Exception e) {
            e.printStackTrace();
            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Failed to continue quiz");
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

            if (userAnswers == null) {
                userAnswers = new HashMap<>();
            }
            if (correctAnswersMap == null) {
                correctAnswersMap = new HashMap<>();
            }
            if (gradingResults == null) {
                gradingResults = new HashMap<>();
            }

            //score
            int score = 0;
            for (Boolean result : gradingResults.values()) {
                if (result != null && result) {
                    score++;
                }
            }

            Long startTime = (Long) session.getAttribute("quizStartTime");
            int timeTaken = startTime != null ? (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;

            if (!practiceMode) {
                String userAnswersJson = gson.toJson(userAnswers);
                String correctAnswersJson = gson.toJson(correctAnswersMap);

                int attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                        timeTaken, userAnswersJson, correctAnswersJson, false);
                List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
            }

            //clean up
            session.removeAttribute("quizQuestions_" + quizId);
            session.removeAttribute("quizAnswers_" + quizId);
            session.removeAttribute("quizCorrectAnswers_" + quizId);
            session.removeAttribute("quizGradingResults_" + quizId);
            session.removeAttribute("quizStartTime");

            //results view
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
            return mav;
        } catch (Exception e) {
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

            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
            }

            for (int i = 0; i < quizQuestions.size(); i++) {
                Question question = quizQuestions.get(i);
                String userAnswer = extractUserAnswer(question, request);
                String displayAnswer = formatUserAnswerForDisplay(question, userAnswer);
                userAnswers.put(String.valueOf(question.getQuestionID()), displayAnswer);
                Object correctAnswer = question.getCorrectAnswer();
                String formattedCorrectAnswer = formatCorrectAnswerForDisplay(question, correctAnswer);
                correctAnswersMap.put(String.valueOf(question.getQuestionID()), formattedCorrectAnswer);


                boolean isCorrect = false;
                if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                    isCorrect = question.isCorrect(userAnswer);

                    if (question instanceof Matching && !isCorrect) {
                        String normalizedAnswer = userAnswer
                                .replace("?", "ć")
                                .replace("Ã¡", "á")
                                .replace("Ã©", "é")
                                .replace("Ã­", "í")
                                .replace("Ã³", "ó")
                                .replace("Ãº", "ú");

                        if (!normalizedAnswer.equals(userAnswer)) {
                            isCorrect = question.isCorrect(normalizedAnswer);
                        }
                    }
                }

                gradingResults.put(String.valueOf(question.getQuestionID()), isCorrect);

                if (isCorrect) {
                    score++;
                }
            }

            String userAnswersJson = gson.toJson(userAnswers);
            String correctAnswersJson = gson.toJson(correctAnswersMap);


            //if not practice mode
            if (!practiceMode) {
                int attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                        timeTaken, userAnswersJson, correctAnswersJson, false);
                List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
            }

            //results view
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
        } else if (question instanceof Matching) {
            userAnswer = request.getParameter(paramName1);
        } else {
            //text input,buttons
            userAnswer = request.getParameter(paramName1);
        }


        Enumeration<String> paramNames = request.getParameterNames();

        return userAnswer;
    }

    private String formatUserAnswerForDisplay(Question question, String userAnswer) {
        if (userAnswer == null) {
            return "";
        }

        if (userAnswer.trim().isEmpty()) {
            return "";
        }

        String displayAnswer = userAnswer.trim();

        //  Multi_Choice_Multi_Answer
        if (question instanceof Multi_Choice_Multi_Answer && displayAnswer.contains(",")) {
            String[] parts = displayAnswer.split(",");
            List<String> trimmedParts = new ArrayList<>();
            for (String part : parts) {
                trimmedParts.add(part.trim());
            }
            displayAnswer = String.join(", ", trimmedParts);
        }
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