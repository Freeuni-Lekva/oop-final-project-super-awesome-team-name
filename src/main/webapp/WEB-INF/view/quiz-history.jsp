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
            background: radial-gradient(ellipse 150% 120% at 20% 85%, #ff6600 0%, #ff4400 8%, #ee3300 15%, #cc2200 25%, #991100 35%, #660800 45%, #330400 55%, #1a0200 65%, #000000 75%);
            background-size: 120% 120%;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .panel {
            background-color: transparent;
            width: 100%;
            min-height: 100vh;
            overflow: hidden;
        }

        .quiz-header {
            background: transparent;
            color: white;
            text-align: center;
            padding: 40px;
            position: relative;
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
            color: #FFFFFF;
            font-weight: bold;
        }

        .main-quiz-title h3 {
            font-size: large;
            color: #FFFFFF;
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
            color: #FF8C00;
            text-decoration: none;
            border-radius: 5px;
            border: 1px solid #FF8C00;
            font-weight: bold;
            font-size: small;
            transition: all 0.3s ease;
        }

        .nav a:hover {
            background-color: #FF8C00;
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

        .section-title {
            color: white;
            font-size: large;
            margin: 40px 0 25px 0;
            font-weight: bold;
            border-bottom: 2px solid #FF8C00;
            padding-bottom: 10px;
        }

        .stats {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            margin: 0 0 25px 0;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
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
            justify-content: center;
        }

        .achievement {
            background: rgba(255, 255, 255, 0.95);
            padding: 15px;
            border-radius: 15px;
            text-align: center;
            width: 150px;
            height: 260px;
            border: 2px solid #FF69B4;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(255, 105, 180, 0.2);
            display: flex;
            flex-direction: column;
            backdrop-filter: blur(10px);
        }

        .achievement:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(255, 105, 180, 0.3);
            border-color: #FF1493;
        }

        .achievement-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .achievement-icon {
            text-align: center;
            margin-bottom: 10px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .achievement-icon img {
            width: 60px;
            height: 60px;
            object-fit: contain;
            filter: drop-shadow(0 2px 4px rgba(255, 105, 180, 0.3));
            display: block;
        }

        .achievement-title {
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 8px;
        }

        .achievement-description {
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 10px;
        }

        .achievement-footer {
            margin-top: auto;
            padding-top: 10px;
        }

        .achievement strong {
            color: #0D0D0D;
            font-size: small;
            font-weight: bold;
            line-height: 1.3;
            text-align: center;
        }

        .achievement small {
            color: #666;
            line-height: 1.4;
            font-size: x-small;
            text-align: center;
        }

        .achievement em {
            color: #FF8C00;
            font-size: x-small;
            font-weight: bold;
            background: rgba(255, 215, 0, 0.2);
            padding: 4px 8px;
            border-radius: 10px;
            display: inline-block;
        }

        .no-achievements {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            color: #666;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .no-achievements p {
            font-size: small;
            color: #666;
            font-weight: normal;
            margin: 10px 0;
        }

        .no-achievements strong {
            font-weight: bold;
            color: #0D0D0D;
        }

        .no-achievements ul {
            text-align: left;
            display: inline-block;
            font-size: x-small;
            margin: 15px 0;
        }

        .attempts-section {
            margin: 30px 0;
        }

        .attempts-box {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            margin: 0 0 25px 0;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .attempts-container {
            max-height: 400px;
            overflow-y: auto;
            padding-right: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background: #fafafa;
        }

        .attempts-container::-webkit-scrollbar {
            width: 8px;
        }

        .attempts-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .attempts-container::-webkit-scrollbar-thumb {
            background: #FF8C00;
            border-radius: 10px;
        }

        .attempts-container::-webkit-scrollbar-thumb:hover {
            background: #ff6600;
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

        .achievement-count {
            text-align: center;
            color: white;
            font-weight: bold;
            margin-top: 20px;
            font-size: small;
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
                gap: 15px;
            }

            .achievement {
                width: 140px;
                height: 280px;
                padding: 12px;
            }

            .achievement-icon {
                height: 70px;
                margin-bottom: 8px;
            }

            .achievement-icon img {
                width: 50px;
                height: 50px;
            }

            .achievement-title {
                height: 45px;
                margin-bottom: 6px;
            }

            .achievement-description {
                height: 55px;
                margin-bottom: 8px;
            }

            .achievement strong {
                font-size: x-small;
                line-height: 1.2;
            }

            .achievement small {
                font-size: xx-small;
                line-height: 1.3;
            }
        }

        @media (max-width: 480px) {
            .achievement-grid {
                gap: 10px;
            }

            .achievement {
                width: 130px;
                height: 270px;
                padding: 10px;
            }

            .achievement-icon {
                height: 60px;
            }

            .achievement-icon img {
                width: 45px;
                height: 45px;
            }

            .achievement-title {
                height: 40px;
            }

            .achievement-description {
                height: 50px;
            }

            .achievement strong {
                font-size: xx-small;
            }

            .achievement small {
                font-size: xx-small;
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