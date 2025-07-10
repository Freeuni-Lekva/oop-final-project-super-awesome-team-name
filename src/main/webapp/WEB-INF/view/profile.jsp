<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Profile | Quizzes</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mainPagesStyles.css">
</head>
<body>
<%@ include file="/WEB-INF/view/header.jsp" %>

<div class="profile-container">
  <div class="profile-header">
    <div class="profile-pic"></div>
    <div class="profile-name">${sessionScope.name}</div>
  </div>

  <div class="box achievements-box">
    <div class="box-title">Achievements:</div>
    <!-- empty content for now -->
  </div>

  <div class="box friends-box">
    <div class="box-title">Friends:</div>
    <!-- empty content for now -->
  </div>
</div>
</body>
</html>
