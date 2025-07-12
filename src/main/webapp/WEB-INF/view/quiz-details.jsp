<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href = ${pageContext.request.contextPath}/css/QuizDetailsStyle.css>
    <title>Quiz Details - ${quiz.quizName}</title>

</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz Details</h1>
            <p>Learn more about this quiz before you start</p>
        </div>
    </div>

    <div class="content-area">
        <div class="quiz-title-section">
            <h2>${quiz.quizName}</h2>
            <p>${quiz.description}</p>
        </div>

        <div class="quiz-creator">
            Created by <a href="#" class="creator-link">${quiz.creatorUsername}</a>
        </div>

        <div class="nav">
            <a href="/">Home</a>
            <a href="/quiz">Browse Quizzes</a>
            <a href="/history">My History</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <h3 class="section-title">Quiz Information</h3>
        <div class="quiz-info">
            <p><strong>Total Questions:</strong> ${questionCount}</p>
            <p><strong>Question Order:</strong> ${quiz.randomOrder ? 'Random' : 'Fixed'}</p>
            <p><strong>Quiz Format:</strong> ${quiz.onePage ? 'Single Page' : 'Multiple Pages'}</p>
            <p><strong>Practice Mode:</strong> ${quiz.practiceMode ? 'Available' : 'Not Available'}</p>
            <c:if test="${quiz.immediateCorrection}">
                <p><strong>Immediate Correction:</strong> Enabled</p>
            </c:if>
        </div>

        <div class="quiz-actions">
            <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Start Quiz</a>
            <c:if test="${quiz.practiceMode}">
                <a href="/quiz/${quiz.quizID}/take?practiceMode=true" class="btn btn-success">Practice Mode</a>
            </c:if>
            <a href="/quiz" class="btn btn-secondary">Back to Quiz List</a>
        </div>

        <h3 class="section-title">Performance Statistics</h3>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-card-title">Your Past Attempts</div>
                <c:choose>
                    <c:when test="${not empty userAttempts}">
                        <c:forEach items="${userAttempts}" var="attempt" varStatus="status">
                            <c:if test="${status.index < 5}"> <!-- Show only last 5 attempts -->
                                <c:set var="percentage" value="${(attempt.score / attempt.totalQuestions) * 100}" />
                                <c:set var="cssClass" value="attempt-item" />
                                <c:if test="${percentage >= 80}">
                                    <c:set var="cssClass" value="attempt-item good" />
                                </c:if>
                                <c:if test="${percentage >= 60 && percentage < 80}">
                                    <c:set var="cssClass" value="attempt-item average" />
                                </c:if>
                                <c:if test="${percentage < 60}">
                                    <c:set var="cssClass" value="attempt-item poor" />
                                </c:if>

                                <div class="${cssClass}">
                                    <h4>Attempt ${status.index + 1}</h4>
                                    <p><strong>Score:</strong> ${attempt.score}/${attempt.totalQuestions}
                                        (<fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%)</p>
                                    <p><strong>Time:</strong> ${attempt.timeTaken}s</p>
                                    <p><strong>Date:</strong> <fmt:formatDate value="${attempt.attemptDate}" pattern="MMM dd, yyyy"/></p>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${fn:length(userAttempts) > 5}">
                            <div class="view-all-link">
                                <a href="/history">View all ${fn:length(userAttempts)} attempts</a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="no-attempts">
                            <p>You haven't attempted this quiz yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="stat-card">
                <div class="stat-card-title">Top Performers</div>
                <c:choose>
                    <c:when test="${not empty topScores}">
                        <c:forEach items="${topScores}" var="topScore" varStatus="status">
                            <c:set var="topPercentage" value="${(topScore.score / topScore.totalQuestions) * 100}" />
                            <div class="attempt-item good">
                                <h4>#${status.index + 1} - ${topScore.userName}</h4>
                                <p><strong>Score:</strong> ${topScore.score}/${topScore.totalQuestions}
                                    (<fmt:formatNumber value="${topPercentage}" maxFractionDigits="1"/>%)</p>
                                <p><strong>Time:</strong> ${topScore.timeTaken}s</p>
                                <p><strong>Date:</strong> <fmt:formatDate value="${topScore.attemptDate}" pattern="MMM dd, yyyy"/></p>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-attempts">
                            <p>No attempts yet. Be the first to take this quiz!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>