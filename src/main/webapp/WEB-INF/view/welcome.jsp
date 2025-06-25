<%--
  Created by IntelliJ IDEA.
  User: datos
  Date: 6/21/2025
  Time: 10:21 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/authToggle.js"></script>
    <title>Welcome | Quizzes </title>
</head>
<body>
<div id="introPanel">
    <img id="sideImage" src="${pageContext.request.contextPath}/images/gradient1.jpg" alt="Gradient">
    <div id="entryForm">
        <h3 id="formTitle">Sign in to Quizzes</h3>
        <p id="formSubtitle" class="${not empty error ? 'error' : ''}">
            <c:choose>
                <c:when test="${not empty error}">
                    ${error}
                </c:when>
                <c:when test="${mode == 'signup'}">
                    Let's get started! Create a new account:
                </c:when>
                <c:otherwise>
                    Welcome back! Log in to your account:
                </c:otherwise>
            </c:choose>
        </p>
        <hr class="solid">
        <form id="authForm" action="${pageContext.request.contextPath}/welcome" method="post">
            <input type="hidden" id="authMode" name="mode" value="login">

            <label for="name">Username: </label>
            <input type="text" id="name" name="name">

            <label for="password">Password: </label>
            <input type="password" id="password" name="password">

            <input type="submit" id="submitButton" class="btn-login" value="Log in">
        </form>
        <p id="toggleText">Don't have an account? <a href="#" onclick="toggleForm()">Sign up</a>
        </p>
    </div>
</div>

<c:if test="${not empty error && mode == 'signup'}">
    <script>
        window.addEventListener('DOMContentLoaded', () => {
            toggleForm();
        });
    </script>
</c:if>


</body>
</html>
