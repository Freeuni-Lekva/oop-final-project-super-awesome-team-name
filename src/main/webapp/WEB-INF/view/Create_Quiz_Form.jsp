<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
    String quizTitle = request.getParameter("QuizName");
    String quizDescription = request.getParameter("QuizDescription");
    int numQuestions = Integer.parseInt(request.getParameter("NQuestions"));

    String randomOrder = request.getParameter("randomOrder");
    String onePage = request.getParameter("onePage");
    String immediateCorrection = request.getParameter("immediateCorrection");
    String practiceMode = request.getParameter("practiceMode");
    String creatorUsername = (String) session.getAttribute("username");

    String[] questionTypes = {
            "Question-Response",
            "Fill in the Blank",
            "Multiple Choice",
            "Picture-Response",
            "Multi-Answer",
            "Multiple Choice with Multiple Answers",
            "Matching"
    };
%>

<!DOCTYPE html>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/Create_Quiz_Form.js" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Create_Quiz_Form_Style.css">
    <title>Create Quiz form</title>


</head>
<body>
<div class="quiz-panel">
<h2>Design Questions for Quiz: <%= quizTitle %></h2>

<form action="Create-Quiz" method="post" onsubmit="return validateForm();">
    <input type="hidden" name="QuizName" value="<%= quizTitle %>" />
    <input type="hidden" name="QuizDescription" value="<%= quizDescription %>" />
    <input type="hidden" name="NQuestions" value="<%= numQuestions %>" />
    <input type="hidden" name="randomOrder" value="<%= randomOrder %>" />
    <input type="hidden" name="onePage" value="<%= onePage %>" />
    <input type="hidden" name="immediateCorrection" value="<%= immediateCorrection %>" />
    <input type="hidden" name="practiceMode" value="<%= practiceMode %>" />
    <input type="hidden" name="creatorUsername" value="<%= creatorUsername %>" />

    <%
        for (int i = 1; i <= numQuestions; i++) {
    %>
    <fieldset>
        <legend>Question <%= i %></legend>

        <label for="questionType_<%= i %>">Question Type:</label>
        <select name="questionType_<%= i %>" id="questionType_<%= i %>" onchange="showFields(this, <%= i %>)" required>
            <option value="">-- Choose Question Type --</option>
            <% for (String type : questionTypes) { %>
            <option value="<%= type %>"><%= type %></option>
            <% } %>
        </select><br/><br/>

        <label>Question Text:</label><br/>
        <textarea name="questionText_<%= i %>" id="questionText_<%= i %>" rows="3" cols="60" required
                  oninput="validateFillInTheBlank(<%= i %>)"></textarea>
        <div class="error-message" id="error_questionText_<%= i %>"></div><br/>

        <div id="dynamicFields_<%= i %>"></div>
    </fieldset><br/>
    <%
        }
    %>

    <a href="${pageContext.request.contextPath}/Created_Quiz_Result"><input type="submit" value="Save Quiz" /></a>
</form>
</div>
</body>
</html>
