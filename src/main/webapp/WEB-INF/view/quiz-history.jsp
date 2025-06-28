<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz History</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f8f9fa; }
        .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; color: #333; }
        .stats { background: #e9ecef; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .attempt { background: #f8f9fa; margin: 10px 0; padding: 15px; border-radius: 5px; border-left: 4px solid #007bff; }
        .attempt.good { border-left-color: #28a745; }
        .attempt.average { border-left-color: #ffc107; }
        .attempt.poor { border-left-color: #dc3545; }
        .nav { margin: 20px 0; }
        .nav a { display: inline-block; padding: 10px 20px; margin: 0 5px; background: #007bff; color: white; text-decoration: none; border-radius: 5px; }
        .nav a:hover { background: #0056b3; }
        .achievement-grid { display: flex; flex-wrap: wrap; gap: 15px; margin: 15px 0; }
        .achievement { background: #d4edda; padding: 15px; border-radius: 8px; text-align: center; min-width: 140px; border: 2px solid #28a745; }
        .achievement-icon { font-size: 32px; margin-bottom: 5px; }
        .no-achievements { background: #f8f9fa; padding: 20px; border-radius: 8px; text-align: center; color: #6c757d; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Quiz History</h1>
        <h3>Welcome, ${userName}!</h3>
    </div>

    <div class="nav">
        <a href="/">Home</a>
        <a href="/login">Login</a>
        <a href="/history/test">Add Test Attempt</a>
    </div>

    <c:if test="${not empty message}">
        <div style="background: #d4edda; padding: 15px; border-radius: 5px; margin: 20px 0; color: #155724;">
            <strong>Success:</strong> ${message}
        </div>
    </c:if>

    <div class="stats">
        <h3>Your Statistics</h3>
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

    <!-- ACHIEVEMENTS SECTION -->
    <div class="stats">
        <h3>Your Achievements</h3>
        <c:choose>
            <c:when test="${not empty achievements}">
                <div class="achievement-grid">
                    <c:forEach items="${achievements}" var="userAchievement">
                        <div class="achievement">
                            <div class="achievement-icon">${userAchievement.achievement.iconUrl}</div>
                            <strong>${userAchievement.achievement.name}</strong><br>
                            <small>${userAchievement.achievement.description}</small><br>
                            <em style="font-size: 12px;">Earned: <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MM/dd/yyyy"/></em>
                        </div>
                    </c:forEach>
                </div>
                <p style="text-align: center; color: #28a745; font-weight: bold;">
                    Total Achievements: ${achievements.size()}
                </p>
            </c:when>
            <c:otherwise>
                <div class="no-achievements">
                    <p><strong>No achievements yet!</strong></p>
                    <p>Keep taking quizzes to unlock achievements like:</p>
                    <ul style="text-align: left; display: inline-block;">
                        <li><strong>Quiz Machine</strong> - Take 10 quizzes</li>
                        <li><strong>Perfectionist</strong> - Score 100% on any quiz</li>
                    </ul>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <h3>Your Quiz Attempts</h3>

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

    <div style="text-align: center; margin-top: 30px;">
        <p><em>This is your Person 3 quiz history implementation with achievements!</em></p>
    </div>
</div>
</body>
</html>