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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=1.2">
    <title>Welcome | Quizes </title>
</head>
<body>
<div id="introPanel">
    <img src="${pageContext.request.contextPath}/images/gradient1.jpg" alt="Gradient">
    <div id="entryForm">
        <h3>Sign in to Quizes</h3>
        <p class="lightFont">Welcome back! Log in to your account:</p>
        <hr class="solid">
        <form action="${pageContext.request.contextPath}/login" method="post">
            <p for="name">Username: </p>
            <input type="text" id="name" name="name">
            <p for="password">Password: </p>
            <input type="password" id="password" name="password">
            <input type="submit" value="Log in">
        </form>
        <p class="lightFont" id="signUp">Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign up</a>
        </p>
    </div>

</div>


</body>
</html>
