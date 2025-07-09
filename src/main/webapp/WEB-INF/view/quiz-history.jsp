<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href = ${pageContext.request.contextPath}/css/QuizHistoryStyle.css>
    <title>Quiz History</title>
</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz History</h1>
            <p>Track your progress and celebrate your achievements</p>
        </div>
    </div>

    <div class="content-area">
        <div class="main-quiz-title">
            <h2>Your Performance</h2>
            <h3>Welcome, ${userName}!</h3>
        </div>

        <div class="nav">
            <a href="/">Home</a>
            <a href="/quiz">Browse Quizzes</a>
            <a href="/history/test">Add Test Attempt</a>
        </div>

        <c:if test="${not empty message}">
            <div class="message">
                <strong>Success:</strong> ${message}
            </div>
        </c:if>

        <h3 class="section-title">Your Statistics</h3>
        <div class="stats">
            <p><strong>Total Quiz Attempts:</strong> ${totalAttempts}</p>
            <p><strong>Average Score:</strong>
                <c:choose>
                    <c:when test="${totalAttempts > 0}">
                        <fmt:formatNumber value="${averageScore}" maxFractionDigits="1"/>%
                    </c:when>
                    <c:otherwise>No attempts yet</c:otherwise>
                </c:choose>
            </p>
        </div>

        <h3 class="section-title">Your Achievements</h3>
        <c:choose>
            <c:when test="${not empty achievements}">
                <div class="achievement-grid">
                    <c:forEach items="${achievements}" var="userAchievement">
                        <div class="achievement">
                            <div class="achievement-content">
                                <div class="achievement-icon">
                                    <img src="${pageContext.request.contextPath}${userAchievement.achievement.iconUrl}"
                                         alt="${userAchievement.achievement.name}"
                                         onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODAiIGhlaWdodD0iODAiIHZpZXdCb3g9IjAgMCA4MCA4MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iNDAiIGN5PSI0MCIgcj0iNDAiIGZpbGw9IiNGRkQ3MDAiLz4KPHR3eHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIyNCIgZmlsbD0id2hpdGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj7wn4+GPC90ZXh0Pgo8L3N2Zz4K';">
                                </div>
                                <div class="achievement-title">
                                    <strong>${userAchievement.achievement.name}</strong>
                                </div>
                                <div class="achievement-description">
                                    <small>${userAchievement.achievement.description}</small>
                                </div>
                            </div>
                            <div class="achievement-footer">
                                <em>Earned: <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MM/dd/yyyy"/></em>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <p class="achievement-count">
                    Total Achievements: ${achievements.size()}
                </p>
            </c:when>
            <c:otherwise>
                <div class="no-achievements">
                    <p><strong>No achievements yet!</strong></p>
                    <p>Keep taking quizzes to unlock achievements like:</p>
                    <ul>
                        <li><strong>Quiz Machine</strong> - Take 10 quizzes</li>
                        <li><strong>Perfectionist</strong> - Score 100% on any quiz</li>
                        <li><strong>Speed Demon</strong> - Complete a quiz in under 30 seconds</li>
                        <li><strong>Practice Makes Perfect</strong> - Take a quiz in practice mode</li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>

        <h3 class="section-title">Your Quiz Attempts</h3>
        <div class="attempts-section">
            <div class="attempts-box">
                <div class="attempts-container">
                    <c:choose>
                        <c:when test="${not empty attempts}">
                            <c:forEach items="${attempts}" var="attempt">
                                <c:set var="percentage" value="${attempt.percentage}" />
                                <c:set var="cssClass" value="attempt" />
                                <c:if test="${percentage >= 80}">
                                    <c:set var="cssClass" value="attempt good" />
                                </c:if>
                                <c:if test="${percentage >= 60 && percentage < 80}">
                                    <c:set var="cssClass" value="attempt average" />
                                </c:if>
                                <c:if test="${percentage < 60}">
                                    <c:set var="cssClass" value="attempt poor" />
                                </c:if>

                                <div class="${cssClass}">
                                    <h4>Quiz ${attempt.quizId}</h4>
                                    <p><strong>Score:</strong> ${attempt.score}/${attempt.totalQuestions}
                                        (<fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%)</p>
                                    <p><strong>Time Taken:</strong> ${attempt.timeTaken} seconds</p>
                                    <p><strong>Date:</strong> ${attempt.attemptDate}</p>
                                    <c:if test="${attempt.practiceMode}">
                                        <p><strong>Mode:</strong> Practice Mode</p>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="attempt">
                                <h4>No Quiz Attempts Yet</h4>
                                <p>You haven't taken any quizzes yet. Click "Add Test Attempt" to see how this works!</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>