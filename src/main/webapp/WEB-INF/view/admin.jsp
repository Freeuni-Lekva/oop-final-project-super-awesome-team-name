<%--
  Created by IntelliJ IDEA.
  User: datos
  Date: 6/26/2025
  Time: 4:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script src="${pageContext.request.contextPath}/js/adminToggle.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <title>Admin | Quizzes</title>
</head>
<body>
<div id="adminPanel" class="panel">
    <div id="adminContainer">
        <form id="adminForm" class="form" action="${pageContext.request.contextPath}/admin" method="post">
            <h3 id="adminHead">Admin Panel</h3>
            <label for="adminFunc">Choose a category:</label>
            <select name="adminFunc" id="adminFunc">
                <option value="announce">Create an announcement</option>
                <option value="removeUser">Remove a user</option>
                <option value="removeQuiz">Remove a quiz</option>
                <option value="clearHistory">Clear history of a quiz</option>
                <option value="promoteUser">Promote a user</option>
                <option value="seeStatistics">See site statistics</option>
            </select>
            <div id="notAnnounce">
                <label for="smallText"></label>
                <input type="text" id="smallText" name="text" required oninput="validateFillInTheBlank">
            </div>
            <div id="announce">
                <label for="announceText"></label>
                <textarea id="announceText" name="bigText" class="wide" required
                          oninput="validateFillInTheBlank"></textarea>
            </div>
            <input type="submit" id="submitButton" class="btn-admin" value="Submit">
        </form>
        <p id="result"></p>
    </div>
</div>

<script>
    document.getElementById('adminForm').addEventListener('submit', function(e) {
        // Get the selected option
        var selectElement = document.getElementById('adminFunc');
        var selectedOption = selectElement.options[selectElement.selectedIndex];
        var selectedText = selectedOption.text;
        var selectedValue = selectedOption.value;

        // Display the chosen option
        var resultElement = document.getElementById('result');
        resultElement.innerHTML = '<strong>Selected Action:</strong> ' + selectedText;
        resultElement.style.color = '#2196F3';
        resultElement.style.marginTop = '20px';
        resultElement.style.padding = '10px';
        resultElement.style.backgroundColor = '#f0f8ff';
        resultElement.style.border = '1px solid #2196F3';
        resultElement.style.borderRadius = '5px';

        // Optional: You can also log both the text and value
        console.log('Selected option text:', selectedText);
        console.log('Selected option value:', selectedValue);
    });

    // Optional: Also show selection when dropdown changes (before submit)
    document.getElementById('adminFunc').addEventListener('change', function() {
        var selectedText = this.options[this.selectedIndex].text;
        var resultElement = document.getElementById('result');
        resultElement.innerHTML = '<em>Ready to execute:</em> ' + selectedText;
        resultElement.style.color = '#666';
        resultElement.style.fontStyle = 'italic';
    });
</script>

</body>
</html>