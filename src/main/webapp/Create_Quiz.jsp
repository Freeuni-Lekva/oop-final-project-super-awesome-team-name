<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMessage = null;

    String quizTitle = request.getParameter("QuizName");
    String quizDescription = request.getParameter("QuizDescription");
    String numQuestionsStr = request.getParameter("NQuestions");

    String randomOrder = request.getParameter("randomOrder") != null ? request.getParameter("randomOrder") : "No";
    String onePage = request.getParameter("onePage") != null ? request.getParameter("onePage") : "No";
    String immediateCorrection = request.getParameter("immediateCorrection") != null ? request.getParameter("immediateCorrection") : "No";
    String practiceMode = request.getParameter("practiceMode") != null ? request.getParameter("practiceMode") : "No";

    boolean isFormSubmitted = quizTitle != null && numQuestionsStr != null;

    if (isFormSubmitted) {
        int numQuestions = 0;
        try {
            numQuestions = Integer.parseInt(numQuestionsStr);
            if (numQuestions < 1 || numQuestions > 20) {
                errorMessage = "Number of questions must be between 1 and 20.";
            } else {
                String redirectURL = "createQuizForm.jsp?" +
                        "quizTitle=" + java.net.URLEncoder.encode(quizTitle, "UTF-8") +
                        "&quizDescription=" + java.net.URLEncoder.encode(quizDescription, "UTF-8") +
                        "&numQuestions=" + numQuestions +
                        "&randomOrder=" + randomOrder +
                        "&onePage=" + onePage +
                        "&immediateCorrection=" + immediateCorrection +
                        "&practiceMode=" + practiceMode;

                response.sendRedirect(redirectURL);
                return;
            }
        } catch (NumberFormatException e) {
            errorMessage = "Invalid number of questions.";
        }
    }
%>
<html>
<head>
    <title>Create Quiz</title>
    <script>
        // Clamp value to [min, max] and show warning if clamped
        function clampValue(input, warningElem) {
            const min = parseInt(input.min);
            const max = parseInt(input.max);
            let val = parseInt(input.value);

            if (isNaN(val)) {
                warningElem.textContent = '';
                return;
            }

            if (val < min) {
                input.value = min;
                warningElem.textContent = "The value must be between " + min + " and " + max + ".";
            } else if (val > max) {
                input.value = max;
                warningElem.textContent = "The value must be between " + min + " and " + max + ".";
            } else {
                warningElem.textContent = '';
            }
        }

        window.addEventListener('DOMContentLoaded', function () {
            const input = document.getElementById('NQuestions');
            const warning = document.getElementById('numWarning');

            // Clamp as user types or leaves field, show/hide warning
            input.addEventListener('input', function () {
                clampValue(input, warning);
            });

            input.addEventListener('change', function () {
                clampValue(input, warning);
            });

            // On submit, clamp once more before submitting and update warning
            document.getElementById('quizForm').addEventListener('submit', function (e) {
                clampValue(input, warning);
                // Let form submit normally
            });
        });
    </script>
</head>
<body>
<h1>Create a new Quiz</h1>

<% if (errorMessage != null) { %>
<p style="color: red;"><%= errorMessage %></p>
<% } %>

<form id="quizForm" action="Create_Quiz_Form.jsp" method="get">
    <label for="QuizName">What is the name of the Quizz?</label><br/>
    <input type="text" id="QuizName" name="QuizName" required
           value="<%= quizTitle != null ? quizTitle : "" %>"/><br/><br/>

    <label for="QuizDescription">Description of your Quizz</label><br/>
    <textarea id="QuizDescription" name="QuizDescription" rows="4" cols="30"><%= quizDescription != null ? quizDescription : "" %></textarea><br/><br/>

    <label for="NQuestions">How many questions?</label>
    <input type="number" id="NQuestions" name="NQuestions" min="1" max="20" required
           value="<%= numQuestionsStr != null ? numQuestionsStr : "" %>"/><br/>
    <small id="numWarning" style="color: red;"></small>
    <br/>

    <label for="randomOrder">Randomize Order:</label>
    <select name="randomOrder" id="randomOrder">
        <option value="No" <%= "No".equals(randomOrder) ? "selected" : "" %>>No</option>
        <option value="Yes" <%= "Yes".equals(randomOrder) ? "selected" : "" %>>Yes</option>
    </select><br/><br/>

    <label for="onePage">Display on One Page:</label>
    <select name="onePage" id="onePage">
        <option value="No" <%= "No".equals(onePage) ? "selected" : "" %>>No</option>
        <option value="Yes" <%= "Yes".equals(onePage) ? "selected" : "" %>>Yes</option>
    </select><br/><br/>

    <label for="immediateCorrection">Immediate Correction:</label>
    <select name="immediateCorrection" id="immediateCorrection">
        <option value="No" <%= "No".equals(immediateCorrection) ? "selected" : "" %>>No</option>
        <option value="Yes" <%= "Yes".equals(immediateCorrection) ? "selected" : "" %>>Yes</option>
    </select><br/><br/>

    <label for="practiceMode">Allow Practice Mode:</label>
    <select name="practiceMode" id="practiceMode">
        <option value="No" <%= "No".equals(practiceMode) ? "selected" : "" %>>No</option>
        <option value="Yes" <%= "Yes".equals(practiceMode) ? "selected" : "" %>>Yes</option>
    </select><br/><br/>

    <input type="submit" value="Create Quizz Form"/>
</form>
</body>
</html>
