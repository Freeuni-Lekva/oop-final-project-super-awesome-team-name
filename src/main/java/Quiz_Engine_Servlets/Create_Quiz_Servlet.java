package Quiz_Engine_Servlets;

import Quiz_Engine.DBConnection;
import Quiz_Engine.Question.*;
import Quiz_Engine.Quiz;
import Quiz_Engine.QuizDAO;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/create-quiz")
public class Create_Quiz_Servlet extends HttpServlet {

    @Autowired
    private QuizDAO quizzes;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the current logged-in user
        HttpSession session = request.getSession();
        String creator = (String) session.getAttribute("username");

        if (creator == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Extract quiz parameters
        String QuizName = request.getParameter("QuizName");
        String description = request.getParameter("QuizDescription");
        int NQuestions = Integer.parseInt(request.getParameter("NQuestions"));
        boolean randomOrder = request.getParameter("randomOrder") != null;
        boolean isOnePage = request.getParameter("onePage") != null;
        boolean immediateCorrection = request.getParameter("immediateCorrection") != null;
        boolean allowPracticeMode = request.getParameter("practiceMode") != null;
        String CreatorUsername = (String) session.getAttribute("username");

        List<Question> questions = new ArrayList<>();

        for (int i = 1; i <= NQuestions; i++) {
            String type = request.getParameter("questionType_" + i);
            String text = request.getParameter("questionText_" + i);

            switch (type) {
                case "Question-Response":{
                    String correct = request.getParameter("correctAnswer");
                    questions.add(new Question_Response(text,type,correct));
                    break;
                }
                case "Fill in the Blank": {
                    String correct = request.getParameter("correctAnswer_" + i);
                    questions.add(new Fill_In_The_Blank(text,type,correct));
                    break;
                }

                case "Multiple Choice": {
                    String opt1 = request.getParameter("answerOption1_" + i);
                    String opt2 = request.getParameter("answerOption2_" + i);
                    String opt3 = request.getParameter("answerOption3_" + i);
                    List<String> options = Arrays.asList(opt1, opt2, opt3);
                    String correct = request.getParameter("correctAnswer_" + i);

                    questions.add(new Multiple_Choice(text,type,options,correct));
                    break;
                }

                case "Picture-Response": {
                    String imageUrl = request.getParameter("imageUrl_" + i);
                    String correct = request.getParameter("correctAnswer_" + i);

                    questions.add(new Picture_Response(text,type,imageUrl,correct));
                    break;
                }

                case "Multi-Answer": {
                    int count = Integer.parseInt(request.getParameter("numCorrect_" + i));
                    List<String> answers = new ArrayList<>();
                    for (int j = 1; j <= count; j++) {
                        answers.add(request.getParameter("correctAnswer_" + i + "_" + j));
                    }
                    String orderMatters = request.getParameter("orderMatters_" + i);
                    boolean orderMatter = "yes".equalsIgnoreCase(orderMatters);

                    questions.add(new Multi_Answer(text,type,orderMatter,answers));
                    break;
                }

                case "Multiple Choice with Multiple Answers": {
                    int correctCount = Integer.parseInt(request.getParameter("numCorrectMCMA_" + i));
                    List<String> correctAnswers = new ArrayList<>();
                    for (int j = 1; j <= correctCount; j++) {
                        correctAnswers.add(request.getParameter("correctAnswerMCMA_" + i + "_" + j));
                    }
                    List<String> options = new ArrayList<>();
                    for (int j = 1; j <= 4 - correctCount; j++) {
                        String opt = request.getParameter("optionMCMA_" + i + "_" + j);
                        if (opt != null && !opt.isBlank()) {
                            options.add(opt);
                        }
                    }

                    questions.add(new Multi_Choice_Multi_Answer(text,type,options,correctAnswers));
                    break;
                }

                case "Matching": {
                    int numPairs = Integer.parseInt(request.getParameter("numPairs_" + i));
                    Map<String, String> pairs = new HashMap<>();
                    for (int j = 1; j <= numPairs; j++) {
                        String left = request.getParameter("pairLeft_" + i + "_" + j);
                        String right = request.getParameter("pairRight_" + i + "_" + j);
                        pairs.put(left, right);
                    }
                    questions.add(new Matching(text,type,pairs));
                    break;
                }

                default:
                    throw new ServletException("Unrecognized Quiz Type");
            }
        }

        try {
            DBConnection dbcon = new DBConnection();
            Connection conn = dbcon.getConnection();
            QuizDAO dao = new QuizDAO(conn);
            // Connect to MySQL

            Quiz quiz = new Quiz(QuizName,description,NQuestions,randomOrder,isOnePage,immediateCorrection,allowPracticeMode,questions,CreatorUsername);



            int quizId = dao.insertQuiz(quiz);
            dao.insertQuestions(quizId,questions);

        } catch (SQLException e) {
            throw new ServletException("Database error when creating quiz", e);
        }
    }
}
