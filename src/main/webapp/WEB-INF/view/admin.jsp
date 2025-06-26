<%--
  Created by IntelliJ IDEA.
  User: datos
  Date: 6/26/2025
  Time: 4:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/adminToggle.js"></script>
    <title>Admin | Quizzes</title>
</head>
<body>
<div id="adminPanel" class="panel">
    <div id="adminContainer">
        <form id="adminForm" class="form" action="${pageContext.request.contextPath}/admin" method="post">
            <h3 id="adminHead">Admin Panel</h3>
            <label for="adminFunc">Choose a category:</label>
            <select name="adminFunc" id="adminFunc">
                <option value="announce">Create an announcements</option>
                <option value="removeUser">Remove a user</option>
                <option value="removeQuiz">Remove a quiz</option>
                <option value="clearHistory">Clear history of a quiz</option>
                <option value="promoteUser">Promote a user</option>
                <option value="seeStatistics">See site statistics</option>
            </select>
            <div id="notAnnounce" class="hide">
                <label for="smallText"></label>
                <input type="text" id="smallText" name="text">
            </div>
            <div id="announce">
                <label for="announceText"></label>
                <textarea id="announceText" name="bigText" class="wide"></textarea>
            </div>
            <input type="submit" id="submitButton" class="btn-admin" value="Submit">
        </form>
        <c:if test="${not empty result}">
            <p id="result" class="success">${result}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p id="error" class="error">${error}</p>
        </c:if>
    </div>

</div>

</body>
</html>
