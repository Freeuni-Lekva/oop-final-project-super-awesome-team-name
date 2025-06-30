package ge.edu.freeuni.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;

@Controller
public class CreateQuizController {

    @PostMapping("/CreateQuiz")
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

        int numQuestions;

        try {
            numQuestions = Integer.parseInt(numQuestionsStr);
            if (numQuestions < 1 || numQuestions > 20) {
                redirectAttributes.addFlashAttribute("errorMessage", "Number of questions must be between 1 and 20.");
                return "redirect:/CreateQuiz";
            }
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid number of questions.");
            return "redirect:/CreateQuiz";
        }

        // Redirect to quiz form page with query parameters
        return "redirect:/createQuizForm.jsp"
                + "?quizTitle=" + quizName
                + "&quizDescription=" + quizDescription
                + "&numQuestions=" + numQuestions
                + "&randomOrder=" + randomOrder
                + "&onePage=" + onePage
                + "&immediateCorrection=" + immediateCorrection
                + "&practiceMode=" + practiceMode;
    }

    @GetMapping("/CreateQuiz")
    public String showQuizCreation(){
        return "CreateQuiz";
    }
}
