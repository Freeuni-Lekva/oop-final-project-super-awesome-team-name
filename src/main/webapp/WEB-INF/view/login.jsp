<%--
  Created by IntelliJ IDEA.
  User: datos
  Date: 6/21/2025
  Time: 10:21 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/authToggle.js"></script>
    <title>Welcome | Quizes </title>
</head>
<body>
<div id="introPanel">
    <img id="sideImage" src="${pageContext.request.contextPath}/images/gradient1.jpg" alt="Gradient">
    <div id="entryForm">
        <h3 id="formTitle">Sign in to Quizes</h3>
        <p id="formSubtitle">Welcome back! Log in to your account:</p>
        <hr class="solid">
        <form id="authForm" action="${pageContext.request.contextPath}/login" method="post">
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


</body>
</html>
