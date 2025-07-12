<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String status = (String) request.getAttribute("status");
    String message = (String) request.getAttribute("message");
    String h1Class = "success".equals(status) ? "success" : "error";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Status</title>
    <% if ("success".equals(status)) { %>
    <meta http-equiv="refresh" content="3; URL=${pageContext.request.contextPath}/Profile.jsp" />
    <% } %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/CreatedQuizResultStyle.css" />
</head>
<body>
<h1 class="<%= h1Class %>"><%= message %></h1>
<% if ("success".equals(status)) { %>
<p>You will be redirected shortly.</p>
<% } else { %>
<p>Please try again or contact support.</p>
<% } %>
</body>
</html>
