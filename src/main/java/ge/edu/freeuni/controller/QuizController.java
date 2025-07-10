package ge.edu.freeuni.controller;

import ge.edu.freeuni.dao.QuizDAO;
import ge.edu.freeuni.dao.QuestionDao;
import ge.edu.freeuni.dao.QuizAttemptDao;
import ge.edu.freeuni.dao.AchievementDao;
import ge.edu.freeuni.model.QuizEngine.Quiz;
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
    private QuizDAO quizzes;

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


    @GetMapping
    public ModelAndView listQuizzes() {
        ModelAndView mav = new ModelAndView("quiz-list");

        List<Quiz> allQuizzes = quizzes.getAllQuizzes();
        List<Quiz> popularQuizzes = quizzes.getPopularQuizzes(5);

        mav.addObject("allQuizzes", allQuizzes);
        mav.addObject("popularQuizzes", popularQuizzes);

        return mav;
    }


    @GetMapping("/{quizId}")
    public ModelAndView showQuizDetails(@PathVariable int quizId, HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser";
        }

        ModelAndView mav = new ModelAndView("quiz-details");

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

        int questionCount = questions.getQuestionCount(quizId);

        mav.addObject("quiz", quiz);
        mav.addObject("userAttempts", userAttempts);
        mav.addObject("topScores", topScores);
        mav.addObject("questionCount", questionCount);
        mav.addObject("userName", userName);

        return mav;
    }


    @GetMapping("/{quizId}/take")
    public ModelAndView takeQuiz(@PathVariable int quizId,
                                 @RequestParam(defaultValue = "false") boolean practiceMode,
                                 HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser";
        }

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

        List<Question> quizQuestions = questions.getQuestionsForQuiz(quizId, quiz.isRandomOrder());

        ModelAndView mav = new ModelAndView("take-quiz");
        mav.addObject("quiz", quiz);
        mav.addObject("questions", quizQuestions);
        mav.addObject("practiceMode", practiceMode);
        mav.addObject("userName", userName);


        session.setAttribute("quizStartTime", System.currentTimeMillis());

        return mav;
    }


    @PostMapping("/{quizId}/submit")
    public ModelAndView submitQuiz(@PathVariable int quizId,
                                   HttpServletRequest request,
                                   @RequestParam(defaultValue = "false") boolean practiceMode,
                                   HttpSession session) {
        String userName = (String) session.getAttribute("name");
        if (userName == null) {
            userName = "TestUser";
        }

        Quiz quiz = quizzes.getQuiz(quizId);
        if (quiz == null) {
            ModelAndView mav = new ModelAndView("redirect:/quiz");
            mav.addObject("error", "Quiz not found");
            return mav;
        }


        Long startTime = (Long) session.getAttribute("quizStartTime");
        int timeTaken = startTime != null ?
                (int) ((System.currentTimeMillis() - startTime) / 1000) : 0;


        List<Question> quizQuestions = questions.getQuestionsForQuiz(quizId, false);


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

        for (Question question : quizQuestions) {
            String paramName = "question_" + question.getQuestionId();
            String userAnswer = request.getParameter(paramName);

            System.out.println("=== DEBUG: Question " + question.getQuestionId() + " ===");
            System.out.println("Parameter name: " + paramName);
            System.out.println("User answer: " + userAnswer);
            System.out.println("Correct answers JSON: " + question.getCorrectAnswers());


            if (userAnswer != null && !userAnswer.trim().isEmpty()) {
                userAnswers.put(String.valueOf(question.getQuestionId()), userAnswer.trim());
            } else {
                userAnswers.put(String.valueOf(question.getQuestionId()), "");
            }


            Type listType = new TypeToken<List<String>>(){}.getType();
            List<String> correctAnswers = gson.fromJson(question.getCorrectAnswers(), listType);
            correctAnswersMap.put(String.valueOf(question.getQuestionId()), correctAnswers);

            System.out.println("Parsed correct answers: " + correctAnswers);

            //case sens
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


        String userAnswersJson = gson.toJson(userAnswers);
        String correctAnswersJson = gson.toJson(correctAnswersMap);

        System.out.println("=== DEBUG: Final JSON ===");
        System.out.println("User answers JSON: " + userAnswersJson);
        System.out.println("Correct answers JSON: " + correctAnswersJson);


        int attemptId = -1;
        if (!practiceMode) {
            attemptId = quizAttempts.add(userName, quizId, score, quizQuestions.size(),
                    timeTaken, userAnswersJson, correctAnswersJson, false);
            List<Achievement> newAchievements = achievements.checkAndAwardAchievements(userName);
        }




        ModelAndView mav = new ModelAndView("quiz-results");
        mav.addObject("quiz", quiz);
        mav.addObject("score", score);
        mav.addObject("totalQuestions", quizQuestions.size());
        mav.addObject("timeTaken", timeTaken);
        mav.addObject("practiceMode", practiceMode);
        mav.addObject("userName", userName);
        mav.addObject("questions", quizQuestions);
        mav.addObject("userAnswers", userAnswers); //pirdapir map
        mav.addObject("correctAnswersMap", correctAnswersMap); //pirdapir map

        double percentage = quizQuestions.size() > 0 ?
                (double) score / quizQuestions.size() * 100 : 0;
        mav.addObject("percentage", percentage);

        return mav;
    }
}