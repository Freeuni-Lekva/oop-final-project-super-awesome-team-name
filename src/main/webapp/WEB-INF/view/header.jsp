<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<header class="ribbon-header">
  <div class="ribbon-logo">
    <a href="${pageContext.request.contextPath}/home">Quizzes</a>
  </div>
  <div class="ribbon-actions">
    <a href="${pageContext.request.contextPath}/profile" class="ribbon-btn">Profile</a>
    <a href="${pageContext.request.contextPath}/home/logout" class="ribbon-btn">Logout</a>
  </div>
</header>