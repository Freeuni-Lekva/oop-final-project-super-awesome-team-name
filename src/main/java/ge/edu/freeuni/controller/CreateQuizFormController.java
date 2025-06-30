package ge.edu.freeuni.controller;

import ge.edu.freeuni.model.QuizEngine.Question.*;
import ge.edu.freeuni.model.QuizEngine.Quiz;
import ge.edu.freeuni.dao.QuizDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/CreateQuizForm")
public class CreateQuizFormController {

    private final QuizDAO quizzes;

    @Autowired
    public CreateQuizFormController(QuizDAO quizzes) {
        this.quizzes = quizzes;
    }

    @PostMapping
    public String createQuizForm(@RequestParam Map<String, String> requestParams,
                                 HttpSession session,
                                 HttpServletRequest request) {
        try {
            String creator = (String) session.getAttribute("creatorUsername");

            String QuizName = requestParams.get("QuizName");
            String description = requestParams.get("QuizDescription");
            int NQuestions = Integer.parseInt(requestParams.get("NQuestions"));
            boolean randomOrder = requestParams.containsKey("randomOrder");
            boolean isOnePage = requestParams.containsKey("onePage");
            boolean immediateCorrection = requestParams.containsKey("immediateCorrection");
            boolean allowPracticeMode = requestParams.containsKey("practiceMode");

            List<Question> questions = new ArrayList<>();

            for (int i = 1; i <= NQuestions; i++) {
                String type = requestParams.get("questionType_" + i);
                String text = requestParams.get("questionText_" + i);

                switch (type) {
                    case "Question-Response": {
                        String correct = requestParams.get("correctAnswer_" + i);
                        questions.add(new Question_Response(text, type, correct));
                        break;
                    }
                    case "Fill in the Blank": {
                        String correct = requestParams.get("correctAnswer_" + i);
                        questions.add(new Fill_In_The_Blank(text, type, correct));
                        break;
                    }
                    case "Multiple Choice": {
                        List<String> options = Arrays.asList(
                                requestParams.get("answerOption1_" + i),
                                requestParams.get("answerOption2_" + i),
                                requestParams.get("answerOption3_" + i)
                        );
                        String correct = requestParams.get("correctAnswer_" + i);
                        questions.add(new Multiple_Choice(text, type, options, correct));
                        break;
                    }
                    case "Picture-Response": {
                        String imageUrl = requestParams.get("imageUrl_" + i);
                        String correct = requestParams.get("correctAnswer_" + i);
                        questions.add(new Picture_Response(text, type, imageUrl, correct));
                        break;
                    }
                    case "Multi-Answer": {
                        int count = Integer.parseInt(requestParams.get("numCorrect_" + i));
                        List<String> answers = new ArrayList<>();
                        for (int j = 1; j <= count; j++) {
                            answers.add(requestParams.get("correctAnswer_" + i + "_" + j));
                        }
                        boolean orderMatters = "yes".equalsIgnoreCase(requestParams.get("orderMatters_" + i));
                        questions.add(new Multi_Answer(text, type, orderMatters, answers));
                        break;
                    }
                    case "Multiple Choice with Multiple Answers": {
                        int correctCount = Integer.parseInt(requestParams.get("numCorrectMCMA_" + i));
                        List<String> correctAnswers = new ArrayList<>();
                        for (int j = 1; j <= correctCount; j++) {
                            correctAnswers.add(requestParams.get("correctAnswerMCMA_" + i + "_" + j));
                        }
                        List<String> options = new ArrayList<>();
                        for (int j = 1; j <= 4 - correctCount; j++) {
                            String opt = requestParams.get("optionMCMA_" + i + "_" + j);
                            if (opt != null && !opt.trim().isEmpty()) {
                                options.add(opt);
                            }
                        }
                        questions.add(new Multi_Choice_Multi_Answer(text, type, options, correctAnswers));
                        break;
                    }
                    case "Matching": {
                        int numPairs = Integer.parseInt(requestParams.get("numPairs_" + i));
                        Map<String, String> pairs = new HashMap<>();
                        for (int j = 1; j <= numPairs; j++) {
                            String left = requestParams.get("pairLeft_" + i + "_" + j);
                            String right = requestParams.get("pairRight_" + i + "_" + j);
                            pairs.put(left, right);
                        }
                        questions.add(new Matching(text, type, pairs));
                        break;
                    }
                    default:
                        throw new IllegalArgumentException("Unrecognized Quiz Type: " + type);
                }
            }

            Quiz quiz = new Quiz(QuizName, description, NQuestions, randomOrder, isOnePage,
                    immediateCorrection, allowPracticeMode, questions, creator);
            int quizId = quizzes.insertQuiz(quiz);
            quizzes.insertQuestions(quizId, questions);

            request.setAttribute("status", "success");
            request.setAttribute("message", "Quiz created successfully!");

        } catch (Exception e) {
            request.setAttribute("status", "error");
            request.setAttribute("message", "Failed to create quiz: " + e.getMessage());
        }

        return "CreatedQuizResult";
    }

    @GetMapping("/CreateQuizForm")
    public String viewQuizForm() {
        return "CreateQuizForm";
    }
}
