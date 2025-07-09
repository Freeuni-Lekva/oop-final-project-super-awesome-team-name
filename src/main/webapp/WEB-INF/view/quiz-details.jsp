<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quiz Details - ${quiz.title}</title>
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
            background: radial-gradient(ellipse 150% 120% at 80% 85%, #9966ff 0%, #8844ff 8%, #7733ee 15%, #6622cc 25%, #551199 35%, #440866 45%, #330433 55%, #1a021a 65%, #000000 75%);
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

        .quiz-title-section {
            text-align: center;
            margin: 25px auto 30px auto;
            padding: 0 40px;
        }

        .quiz-title-section h2 {
            font-size: xx-large;
            margin: 0;
            color: #FFFFFF;
            font-weight: bold;
        }

        .quiz-title-section p {
            font-size: small;
            color: rgba(255, 255, 255, 0.8);
            margin: 10px 0 0 0;
            font-weight: normal;
        }

        .quiz-creator {
            text-align: center;
            margin: 15px 0;
            font-size: small;
            color: rgba(255, 255, 255, 0.8);
        }

        .creator-link {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .creator-link:hover {
            text-decoration: underline;
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
            background: rgba(255, 255, 255, 0.1);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            font-weight: bold;
            font-size: small;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
        }

        .nav a:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.5);
        }

        .section-title {
            color: white;
            font-size: large;
            margin: 40px 0 25px 0;
            font-weight: bold;
            border-bottom: 2px solid #9966ff;
            padding-bottom: 10px;
        }

        .quiz-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 30px 0;
            flex-wrap: wrap;
        }

        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            font-size: small;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            color: white;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background: linear-gradient(135deg, #9966ff, #8844ff);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #8844ff, #7733ee);
        }

        .btn-success {
            background: linear-gradient(135deg, #006A50, #00A881);
        }

        .btn-success:hover {
            background: linear-gradient(135deg, #00A881, #00C49A);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #666, #888);
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #888, #999);
        }

        .quiz-info {
            background: rgba(255, 255, 255, 0.95);
            padding: 30px;
            border-radius: 15px;
            margin: 0 0 25px 0;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .quiz-info p {
            color: #0D0D0D;
            margin: 12px 0;
            font-size: small;
            font-weight: bold;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin: 0 0 25px 0;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .stat-card-title {
            color: white;
            font-size: medium;
            margin: 0 0 15px 0;
            font-weight: bold;
            border-bottom: 2px solid #870C06;
            padding-bottom: 10px;
        }

        .attempt-item {
            background: #FFFFFF;
            margin: 15px 0;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .attempt-item.good {
            border-left: 4px solid #006A50;
        }

        .attempt-item.average {
            border-left: 4px solid #F39C12;
        }

        .attempt-item.poor {
            border-left: 4px solid #870C06;
        }

        .attempt-item h4 {
            color: #0D0D0D;
            margin-bottom: 10px;
            font-size: small;
            font-weight: bold;
        }

        .attempt-item p {
            color: #0D0D0D;
            margin: 6px 0;
            font-size: x-small;
        }

        .no-attempts {
            text-align: center;
            padding: 30px;
            color: #666;
            background: #FFFFFF;
            border-radius: 8px;
            border: 1px solid #ddd;
        }

        .no-attempts p {
            font-size: small;
            color: #666;
        }

        .error {
            background: linear-gradient(135deg, #870C06, #C7140D);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            font-size: small;
            font-weight: bold;
        }

        .view-all-link {
            text-align: center;
            margin-top: 15px;
            font-size: x-small;
            color: #666;
        }

        .view-all-link a {
            color: #9966ff;
            text-decoration: none;
        }

        .view-all-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 25px;
            }

            .quiz-header h1 {
                font-size: large;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .quiz-actions {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
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
            <h2>${quiz.title}</h2>
            <p>${quiz.description}</p>
        </div>

        <div class="quiz-creator">
            Created by <a href="#" class="creator-link">${quiz.creatorName}</a>
            | <fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy"/>
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
            <p><strong>Quiz Format:</strong> ${quiz.singlePage ? 'Single Page' : 'Multiple Pages'}</p>
            <p><strong>Practice Mode:</strong> ${quiz.allowPracticeMode ? 'Available' : 'Not Available'}</p>
            <c:if test="${quiz.immediateCorrection}">
                <p><strong>Immediate Correction:</strong> Enabled</p>
            </c:if>
        </div>

        <div class="quiz-actions">
            <a href="/quiz/${quiz.quizId}/take" class="btn btn-primary">Start Quiz</a>
            <c:if test="${quiz.allowPracticeMode}">
                <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-success">Practice Mode</a>
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
                                <c:set var="percentage" value="${attempt.percentage}" />
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
                            <div class="attempt-item good">
                                <h4>#${status.index + 1} - ${topScore.userName}</h4>
                                <p><strong>Score:</strong> ${topScore.score}/${topScore.totalQuestions}
                                    (<fmt:formatNumber value="${topScore.percentage}" maxFractionDigits="1"/>%)</p>
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