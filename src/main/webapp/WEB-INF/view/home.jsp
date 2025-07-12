<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomeStyle.css">
    <title>Super Awesome Quiz Website - Home</title>
</head>
<body>
<div class="container">
    <header class="main-header">
        <div class="header-content-centered">
            <h1>Super Awesome Quiz Website</h1>
            <div class="user-welcome">
                <span>Welcome, <strong>${sessionScope.name}</strong>!</span>
            </div>
            <nav class="main-nav">
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/CreateQuiz" class="nav-link">Create Quiz</a>
                <a href="/history" class="nav-link">My History</a>
                <a href="/profile" class="nav-link">My Profile</a>
                <c:if test="${sessionScope.isAdmin}">
                    <a href="/admin" class="nav-link admin-link">Admin</a>
                </c:if>
                <a href="/logout" class="nav-link logout-link">Logout</a>
            </nav>
        </div>
    </header>

    <main class="main-content">

        <c:if test="${not empty announcements}">
            <section class="announcements-section">
                <h2>Latest Announcements</h2>
                <div class="announcements-scroll">
                    <c:forEach items="${announcements}" var="announcement">
                        <div class="announcement-card">
                            <h3>${announcement.title}</h3>
                            <p class="announcement-meta">
                                By ${announcement.name} | <fmt:formatDate value="${announcement.date}" pattern="MMM dd, yyyy"/>
                            </p>
                            <p class="announcement-text">${announcement.text}</p>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>


        <div class="quiz-columns">

            <section class="quiz-column">
                <h2>Recently Created Quizzes</h2>
                <c:choose>
                    <c:when test="${not empty recentQuizzes}">
                        <div class="quiz-list">
                            <c:forEach items="${recentQuizzes}" var="quiz">
                                <div class="quiz-item">
                                    <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                    <p class="quiz-description">${quiz.description}</p>
                                    <p class="quiz-meta">
                                        By ${quiz.creatorUsername} | ${quiz.NQuestions} questions
                                        <c:if test="${quiz.practiceMode}"> | Practice Available</c:if>
                                    </p>
                                    <div class="quiz-actions">
                                        <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Take Quiz</a>
                                        <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">Details</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">No quizzes created yet. <a href="/CreateQuiz">Create the first one!</a></p>
                    </c:otherwise>
                </c:choose>
            </section>


            <section class="quiz-column">
                <h2>Popular Quizzes</h2>
                <c:choose>
                    <c:when test="${not empty popularQuizzes}">
                        <div class="quiz-list">
                            <c:forEach items="${popularQuizzes}" var="quiz">
                                <div class="quiz-item">
                                    <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                    <p class="quiz-description">${quiz.description}</p>
                                    <p class="quiz-meta">
                                        By ${quiz.creatorUsername} | ${quiz.NQuestions} questions
                                        <c:if test="${quiz.practiceMode}"> | Practice Available</c:if>
                                    </p>
                                    <div class="quiz-actions">
                                        <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Take Quiz</a>
                                        <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">Details</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">No popular quizzes yet. Be the first to create one!</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</div>
</body>
</html>