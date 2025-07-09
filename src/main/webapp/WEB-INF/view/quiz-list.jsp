<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href = ${pageContext.request.contextPath}/css/QuizListStyle.css>
    <title>Available Quizzes</title>
</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz Center</h1>
            <p>Test your knowledge and challenge yourself with our interactive quiz platform</p>
        </div>
    </div>

    <div class="content-area">
        <div class="main-quiz-title">
            <h2>Available Quizzes</h2>
            <p>Choose a quiz to test your knowledge</p>
        </div>

        <div class="nav">
            <a href="/">Home</a>
            <a href="/history">My History</a>
            <a href="/logout">Logout</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <h3 class="section-title">Popular Quizzes</h3>
        <c:choose>
            <c:when test="${not empty popularQuizzes}">
                <div class="quiz-grid">
                    <c:forEach items="${popularQuizzes}" var="quiz" varStatus="status">
                        <div class="quiz-card">
                            <div class="quiz-title">${quiz.title}</div>
                            <div class="quiz-description">${quiz.description}</div>
                            <div class="quiz-meta">
                                Created by <a href="#" class="creator-link">${quiz.creatorName}</a>
                                | <fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy"/>
                            </div>
                            <div class="quiz-actions">
                                <a href="/quiz/${quiz.quizId}" class="btn btn-primary">View Details</a>
                                <a href="/quiz/${quiz.quizId}/take" class="btn btn-success">Start Quiz</a>
                                <c:if test="${quiz.allowPracticeMode}">
                                    <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-secondary">Practice</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-quizzes">
                    <p>No popular quizzes yet. Be the first to take a quiz!</p>
                </div>
            </c:otherwise>
        </c:choose>

        <h3 class="section-title">All Available Quizzes</h3>
        <c:choose>
            <c:when test="${not empty allQuizzes}">
                <div class="quiz-grid">
                    <c:forEach items="${allQuizzes}" var="quiz">
                        <div class="quiz-card">
                            <div class="quiz-title">${quiz.title}</div>
                            <div class="quiz-description">${quiz.description}</div>
                            <div class="quiz-meta">
                                Created by <a href="#" class="creator-link">${quiz.creatorName}</a>
                                | <fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy"/>
                                <c:if test="${quiz.randomOrder}"> | Random Order</c:if>
                                <c:if test="${quiz.allowPracticeMode}"> | Practice Available</c:if>
                            </div>
                            <div class="quiz-actions">
                                <a href="/quiz/${quiz.quizId}" class="btn btn-primary">View Details</a>
                                <a href="/quiz/${quiz.quizId}/take" class="btn btn-success">Start Quiz</a>
                                <c:if test="${quiz.allowPracticeMode}">
                                    <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-secondary">Practice</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-quizzes">
                    <h3>No quizzes available yet!</h3>
                    <p>Check back later for new quizzes to test your knowledge.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>