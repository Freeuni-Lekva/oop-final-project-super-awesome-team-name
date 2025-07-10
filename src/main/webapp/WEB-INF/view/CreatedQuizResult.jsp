<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String status = (String) request.getAttribute("status");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Status</title>
    <% if ("success".equals(status)) { %>
    <meta http-equiv="refresh" content="3; URL=your_quizzes.jsp" />
    <% } %>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f8ff;
            text-align: center;
            margin-top: 100px;
        }
        h1 {
            color: <%= "success".equals(status) ? "#4CAF50" : "#D32F2F" %>;
        }
        p {
            color: #555;
        }
    </style>
</head>
<body>
<h1><%= message %></h1>
<% if ("success".equals(status)) { %>
<p>You will be redirected shortly.</p>
<% } else { %>
<p>Please try again or contact support.</p>
<% } %>
</body>
</html>
