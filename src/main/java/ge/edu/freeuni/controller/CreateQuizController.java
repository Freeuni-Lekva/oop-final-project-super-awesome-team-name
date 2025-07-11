package ge.edu.freeuni.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/CreateQuiz")
public class CreateQuizController {

    private final int maxQuestions = 20;

    @PostMapping()
    public String handleQuizForm(
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        String quizName = request.getParameter("QuizName");
        String quizDescription = request.getParameter("QuizDescription");
        String numQuestionsStr = request.getParameter("NQuestions");

        String randomOrder = request.getParameter("randomOrder") != null ? request.getParameter("randomOrder") : "No";
        String onePage = request.getParameter("onePage") != null ? request.getParameter("onePage") : "No";
        String immediateCorrection = request.getParameter("immediateCorrection") != null ? request.getParameter("immediateCorrection") : "No";
        String practiceMode = request.getParameter("practiceMode") != null ? request.getParameter("practiceMode") : "No";

        int numQuestions = Integer.parseInt(numQuestionsStr);


        // Redirect to quiz form page with query parameters
        return "redirect:/CreateQuizForm"
                + "?QuizName=" + quizName
                + "&QuizDescription=" + quizDescription
                + "&NQuestions=" + numQuestions
                + "&randomOrder=" + randomOrder
                + "&onePage=" + onePage
                + "&immediateCorrection=" + immediateCorrection
                + "&practiceMode=" + practiceMode;

    }

    @GetMapping()
    public String showQuizCreation(HttpServletRequest request){

        request.setAttribute("maxQuestions", maxQuestions);
        return "CreateQuiz";
    }
}
