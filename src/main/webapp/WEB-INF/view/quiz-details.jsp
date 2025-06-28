<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz History</title>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Century Gothic', 'Segoe UI', 'Arial', 'Helvetica', sans-serif;
            color: #0D0D0D;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: #0D0D0D;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .panel {
            background-color: #FFFFFF;
            width: 100%;
            min-height: 100vh;
            overflow: hidden;
        }

        .quiz-header {
            background: linear-gradient(135deg, #870C06 0%, #C7140D 100%);
            color: white;
            text-align: center;
            padding: 40px;
            position: relative;
        }

        .quiz-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 70% 30%, rgba(255,255,255,0.1) 0%, transparent 70%);
        }

        .quiz-header-content {
            position: relative;
            z-index: 1;
        }

        .quiz-header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: normal;
            color: white;
        }

        .quiz-header p {
            font-size: large;
            opacity: 0.9;
            color: white;
            font-weight: normal;
        }

        .content-area {
            padding: 40px;
            max-width: 1100px;
            margin: 0 auto;
        }

        .main-quiz-title {
            text-align: center;
            margin: 25px auto 30px auto;
            padding: 0 40px;
        }

        .main-quiz-title h2 {
            font-size: xx-large;
            margin: 0;
            color: #0D0D0D;
            font-weight: bold;
        }

        .main-quiz-title h3 {
            font-size: large;
            color: #666;
            margin: 10px 0 0 0;
            font-weight: normal;
        }

        .nav {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 35px;
            flex-wrap: wrap;
        }

        .nav a {
            padding: 10px 25px;
            background: transparent;
            color: #870C06;
            text-decoration: none;
            border-radius: 5px;
            border: 1px solid #870C06;
            font-weight: bold;
            font-size: small;
            transition: all 0.3s ease;
        }

        .nav a:hover {
            background-color: #870C06;
            color: white;
        }

        .message {
            background: linear-gradient(135deg, #006A50, #00A881);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            font-size: small;
            font-weight: bold;
        }

        .stats {
            background: #f9f9f9;
            padding: 30px;
            border-radius: 15px;
            margin: 25px 0;
            border: 1px solid #ccc;
        }

        .stats h3 {
            color: #0D0D0D;
            margin-bottom: 20px;
            font-size: large;
            font-weight: bold;
            border-bottom: 2px solid #870C06;
            padding-bottom: 10px;
        }

        .stats p {
            color: #0D0D0D;
            margin: 12px 0;
            font-size: small;
            font-weight: bold;
        }

        .achievement-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin: 20px 0;
        }

        .achievement {
            background: #f9f9f9;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            min-width: 180px;
            border: 1px solid #006A50;
            transition: all 0.3s ease;
        }

        .achievement:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .achievement strong {
            color: #0D0D0D;
            margin-bottom: 10px;
            display: block;
            font-size: small;
            font-weight: bold;
        }

        .achievement small {
            color: #666;
            display: block;
            margin-bottom: 10px;
            line-height: 1.4;
            font-size: x-small;
        }

        .achievement em {
            color: #999;
            font-size: x-small;
        }

        .no-achievements {
            background: #f9f9f9;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            color: #666;
            border: 1px solid #ccc;
        }

        .no-achievements p {
            font-size: small;
            color: #666;
            font-weight: normal;
        }

        .no-achievements strong {
            font-weight: bold;
            color: #0D0D0D;
        }

        .attempts-section h3 {
            color: #0D0D0D;
            margin: 30px 0 20px 0;
            font-size: large;
            font-weight: bold;
            border-bottom: 2px solid #38077F;
            padding-bottom: 10px;
        }

        .attempt {
            background: #f9f9f9;
            margin: 20px 0;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #ccc;
        }

        .attempt.good {
            border-left: 4px solid #006A50;
        }

        .attempt.average {
            border-left: 4px solid #F39C12;
        }

        .attempt.poor {
            border-left: 4px solid #870C06;
        }

        .attempt h4 {
            color: #0D0D0D;
            margin-bottom: 12px;
            font-size: medium;
            font-weight: bold;
        }

        .attempt p {
            color: #0D0D0D;
            margin: 8px 0;
            font-size: small;
        }

        .attempt strong {
            color: #0D0D0D;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 25px;
            }

            .quiz-header h1 {
                font-size: large;
            }

            .achievement-grid {
                justify-content: center;
            }
        }
    </style>
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
            <h2>Quiz History</h2>
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

        <div class="stats">
            <h3>Your Achievements</h3>
            <c:choose>
                <c:when test="${not empty achievements}">
                    <div class="achievement-grid">
                        <c:forEach items="${achievements}" var="userAchievement">
                            <div class="achievement">
                                <strong>${userAchievement.achievement.name}</strong>
                                <small>${userAchievement.achievement.description}</small>
                                <em>Earned: <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MM/dd/yyyy"/></em>
                            </div>
                        </c:forEach>
                    </div>
                    <p style="text-align: center; color: #006A50; font-weight: bold; margin-top: 20px; font-size: small;">
                        Total Achievements: ${achievements.size()}
                    </p>
                </c:when>
                <c:otherwise>
                    <div class="no-achievements">
                        <p><strong>No achievements yet!</strong></p>
                        <p>Keep taking quizzes to unlock achievements like:</p>
                        <ul style="text-align: left; display: inline-block; font-size: x-small;">
                            <li><strong>Quiz Machine</strong> - Take 10 quizzes</li>
                            <li><strong>Perfectionist</strong> - Score 100% on any quiz</li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="attempts-section">
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
        </div>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid #ddd; color: #666;">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>