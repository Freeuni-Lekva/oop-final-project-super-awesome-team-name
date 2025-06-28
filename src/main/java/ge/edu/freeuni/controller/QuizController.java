package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.QuizDao;
import ge.edu.freeuni.dao.QuestionDao;
import ge.edu.freeuni.dao.QuizAttemptDao;
import ge.edu.freeuni.dao.AchievementDao;
import ge.edu.freeuni.model.Quiz;
import ge.edu.freeuni.model.Question;
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
import java.util.*;

@Controller
@RequestMapping("/quiz")
public class QuizController {

    @Autowired
    private QuizDao quizzes;

    @Autowired
    private QuestionDao questions;

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

    // List all available quizzes
    @GetMapping
    public ModelAndView listQuizzes() {
        ModelAndView mav = new ModelAndView("quiz-list");

        List<Quiz> allQuizzes = quizzes.getAllQuizzes();
        List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);

        mav.addObject("allQuizzes", allQuizzes);
        mav.addObject("popularQuizzes", popularQuizzes);

        return mav;
    }

    // Show quiz details and start quiz option
    @GetMapping("/{quizId}")
    public ModelAndView showQuizDetails(@PathVariable int quizId, HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser"; // For testing without auth
        }

        ModelAndView mav = new ModelAndView("quiz-details");

        Quiz quiz = quizzes.get(quizId);
        if (quiz == null) {
            mav.setViewName("redirect:/quiz");
            mav.addObject("error", "Quiz not found");
            return mav;
        }

        // Get user's past attempts on this quiz
        List<QuizAttempt> allUserAttempts = quizAttempts.getAttemptsForUser(userName);
        List<QuizAttempt> userAttempts = new ArrayList<>();
        for (QuizAttempt attempt : allUserAttempts) {
            if (attempt.getQuizId() == quizId) {
                userAttempts.add(attempt);
            }
        }

        // Get top performers on this quiz
        List<QuizAttempt> topScores = quizAttempts.getTopScoresForQuiz(quizId, 5);

        int questionCount = questions.getQuestionCount(quizId);

        mav.addObject("quiz", quiz);
        mav.addObject("userAttempts", userAttempts);
        mav.addObject("topScores", topScores);
        mav.addObject("questionCount", questionCount);
        mav.addObject("userName", userName);

        return mav;
    }

    // Start taking a quiz
    @GetMapping("/{quizId}/take")
    public ModelAndView takeQuiz(@PathVariable int quizId,
                                 @RequestParam(defaultValue = "false") boolean practiceMode,
                                 HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser"; // For testing without auth
        }

        Quiz quiz = quizzes.get(quizId);
        if (quiz == null) {
            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Quiz not found");
            return mav;
        }

        // Check if practice mode is allowed
        if (practiceMode && !quiz.isAllowPracticeMode()) {
            ModelAndView mav = new ModelAndView("redirect:/quiz/" + quizId);
            mav.addObject("error", "Practice mode not available for this quiz");
            return mav;
        }

        List<Question> quizQuestions = questions.getQuestionsForQuiz(quizId, quiz.isRandomOrder());

        ModelAndView mav = new ModelAndView("take-quiz");
        mav.addObject("quiz", quiz);
        mav.addObject("questions", quizQuestions);
        mav.addObject("practiceMode", practiceMode);
        mav.addObject("userName", userName);

        // Store quiz start time in session
        session.setAttribute("quizStartTime", System.currentTimeMillis());

        return mav;
    }

    // Handle quiz submission
    @PostMapping("/{quizId}/submit")
    public ModelAndView submitQuiz(@PathVariable int quizId,
                                   HttpServletRequest request,
                                   @RequestParam(defaultValue = "false") boolean practiceMode,
                                   HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser"; // For testing without auth
        }

        Quiz quiz = quizzes.get(quizId);
        if (quiz == null) {
            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Quiz not found");
            return mav;
        }

        // Calculate time taken
        Long startTime = (Long) session.getAttribute("quizStartTime");
        int timeTaken = startTime != null ?
                (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;

        // Get questions for this quiz
        List<Question> quizQuestions = questions.getQuestionsForQuiz(quizId, false); // Don't randomize for grading

        // Collect user answers and grade the quiz
        Map<String, String> userAnswers = new HashMap<>();
        Map<String, List<String>> correctAnswersMap = new HashMap<>();
        int score = 0;

        for (Question question : quizQuestions) {
            String paramName = "question_" + question.getQuestionId();
            String userAnswer = request.getParameter(paramName);

            if (userAnswer != null) {
                userAnswer = userAnswer.trim();
                userAnswers.put(String.valueOf(question.getQuestionId()), userAnswer);

                // Parse correct answers from JSON
                Type listType = new TypeToken<List<String>>(){}.getType();
                List<String> correctAnswers = gson.fromJson(question.getCorrectAnswers(), listType);
                correctAnswersMap.put(String.valueOf(question.getQuestionId()), correctAnswers);

                // Check if answer is correct (case-insensitive)
                boolean isCorrect = false;
                for (String correct : correctAnswers) {
                    if (correct.equalsIgnoreCase(userAnswer)) {
                        isCorrect = true;
                        break;
                    }
                }

                if (isCorrect) {
                    score++;
                }
            }
        }

        // Convert answers to JSON for storage
        String userAnswersJson = gson.toJson(userAnswers);
        String correctAnswersJson = gson.toJson(correctAnswersMap);

        // Save the quiz attempt (only if not practice mode)
        int attemptId = -1;
        if (!practiceMode) {
            attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                    timeTaken, userAnswersJson, correctAnswersJson, false);

            // Check for new achievements
            List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
        }

        // Prepare results page
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
    }
}