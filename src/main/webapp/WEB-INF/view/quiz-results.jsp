<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Taking Quiz: ${quiz.title}</title>
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
            background: linear-gradient(135deg, #38077F 0%, #5B2778 100%);
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

        .quiz-header h2 {
            font-size: large;
            opacity: 0.9;
            font-weight: normal;
            color: white;
        }

        .content-area {
            padding: 40px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .practice-notice {
            background: linear-gradient(135deg, #006A50, #00A881);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            text-align: center;
            font-weight: bold;
            font-size: small;
        }

        .score-summary {
            background: linear-gradient(135deg, #006A50, #00A881);
            color: white;
            padding: 40px;
            border-radius: 15px;
            text-align: center;
            margin: 30px 0;
            position: relative;
            overflow: hidden;
        }

        .score-summary::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: radial-gradient(circle at 20% 80%, rgba(255,255,255,0.1) 0%, transparent 70%);
        }

        .score-summary.poor {
            background: linear-gradient(135deg, #870C06, #C7140D);
        }

        .score-summary.average {
            background: linear-gradient(135deg, #F39C12, #E67E22);
        }

        .score-summary-content {
            position: relative;
            z-index: 1;
        }

        .score-circle {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            border: 4px solid rgba(255,255,255,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            background: rgba(255,255,255,0.1);
        }

        .score-percentage {
            font-size: 2.5em;
            font-weight: bold;
            color: white;
        }

        .score-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 25px;
            margin: 25px 0;
        }

        .score-item {
            text-align: center;
            color: white;
        }

        .score-item h3 {
            margin-bottom: 8px;
            font-size: x-large;
            font-weight: bold;
            color: white;
        }

        .score-item p {
            margin: 0;
            font-size: small;
            opacity: 0.8;
            color: white;
        }

        .performance-message {
            margin-top: 20px;
        }

        .performance-message h2 {
            font-size: large;
            margin: 0;
            color: white;
            font-weight: bold;
        }

        .nav-section {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin: 35px 0;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 28px;
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
            background-color: #38077F;
        }

        .btn-primary:hover {
            background-color: #5B2778;
        }

        .btn-secondary {
            background-color: #666;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #888;
        }

        .btn-success {
            background-color: #006A50;
        }

        .btn-success:hover {
            background-color: #00A881;
        }

        .questions-review {
            margin: 40px 0;
        }

        .questions-review h2 {
            color: #0D0D0D;
            border-bottom: 2px solid #38077F;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-size: large;
            font-weight: bold;
        }

        .question-review {
            background: #f9f9f9;
            padding: 25px;
            margin: 25px 0;
            border-radius: 10px;
            border: 1px solid #ccc;
        }

        .question-review.correct {
            border-left: 4px solid #006A50;
        }

        .question-review.incorrect {
            border-left: 4px solid #870C06;
        }

        .question-review-header {
            font-weight: bold;
            color: #0D0D0D;
            margin-bottom: 15px;
            font-size: small;
        }

        .answer-comparison {
            margin: 15px 0;
        }

        .user-answer {
            color: #0D0D0D;
            margin: 8px 0;
            padding: 10px;
            background: #f5f5f5;
            border-radius: 5px;
            font-size: small;
        }

        .correct-answer {
            color: #006A50;
            font-weight: bold;
            margin: 8px 0;
            padding: 10px;
            background: #f0fff0;
            border-radius: 5px;
            font-size: small;
        }

        .incorrect-answer {
            color: #870C06;
            font-weight: bold;
            margin: 8px 0;
            padding: 10px;
            background: #fff5f5;
            border-radius: 5px;
            font-size: small;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 15px;
            border-radius: 15px;
            font-size: x-small;
            font-weight: bold;
            margin-left: 15px;
            color: white;
        }

        .status-correct {
            background-color: #006A50;
        }

        .status-incorrect {
            background-color: #870C06;
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 25px;
            }

            .quiz-header h1 {
                font-size: large;
            }

            .score-details {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .nav-section {
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
            <h1>Quiz Completed!</h1>
            <h2>${quiz.title}</h2>
        </div>
    </div>

    <div class="content-area">
        <c:if test="${practiceMode}">
            <div class="practice-notice">
                This was a practice session - your score was not recorded
            </div>
        </c:if>

        <c:set var="scoreClass" value="" />
        <c:if test="${percentage >= 80}"><c:set var="scoreClass" value="" /></c:if>
        <c:if test="${percentage >= 60 && percentage < 80}"><c:set var="scoreClass" value="average" /></c:if>
        <c:if test="${percentage < 60}"><c:set var="scoreClass" value="poor" /></c:if>

        <div class="score-summary ${scoreClass}">
            <div class="score-summary-content">
                <div class="score-circle">
                    <div class="score-percentage">
                        <fmt:formatNumber value="${percentage}" maxFractionDigits="0"/>%
                    </div>
                </div>

                <div class="score-details">
                    <div class="score-item">
                        <h3>${score}/${totalQuestions}</h3>
                        <p>Questions Correct</p>
                    </div>
                    <div class="score-item">
                        <h3><fmt:formatNumber value="${percentage}" maxFractionDigits="1"/>%</h3>
                        <p>Final Score</p>
                    </div>
                    <div class="score-item">
                        <h3>${timeTaken}s</h3>
                        <p>Time Taken</p>
                    </div>
                </div>

                <div class="performance-message">
                    <c:choose>
                        <c:when test="${percentage >= 90}">
                            <h2>Excellent! Outstanding performance!</h2>
                        </c:when>
                        <c:when test="${percentage >= 80}">
                            <h2>Great job! Well done!</h2>
                        </c:when>
                        <c:when test="${percentage >= 70}">
                            <h2>Good work! Keep it up!</h2>
                        </c:when>
                        <c:when test="${percentage >= 60}">
                            <h2>Not bad! Room for improvement.</h2>
                        </c:when>
                        <c:otherwise>
                            <h2>Keep practicing! You'll get better!</h2>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="nav-section">
            <a href="/quiz" class="btn btn-primary">Browse More Quizzes</a>
            <a href="/quiz/${quiz.quizId}" class="btn btn-secondary">Quiz Details</a>
            <a href="/history" class="btn btn-secondary">My History</a>
            <c:if test="${quiz.allowPracticeMode}">
                <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-success">Practice Again</a>
            </c:if>
            <c:if test="${not practiceMode}">
                <a href="/quiz/${quiz.quizId}/take" class="btn btn-success">Retake Quiz</a>
            </c:if>
        </div>

        <div class="questions-review">
            <h2>Question Review</h2>

            <c:forEach items="${questions}" var="question" varStatus="status">
                <c:set var="questionId" value="${question.questionId}" />
                <c:set var="userAnswer" value="${userAnswers[questionId]}" />
                <c:set var="correctAnswers" value="${correctAnswersMap[questionId]}" />

                <c:set var="isCorrect" value="false" />
                <c:forEach items="${correctAnswers}" var="correctAnswer">
                    <c:if test="${fn:toLowerCase(userAnswer) == fn:toLowerCase(correctAnswer)}">
                        <c:set var="isCorrect" value="true" />
                    </c:if>
                </c:forEach>

                <div class="question-review ${isCorrect ? 'correct' : 'incorrect'}">
                    <div class="question-review-header">
                        Question ${status.index + 1}: ${question.questionText}
                        <span class="status-badge status-${isCorrect ? 'correct' : 'incorrect'}">
                                ${isCorrect ? 'Correct' : 'Incorrect'}
                        </span>
                    </div>

                    <div class="answer-comparison">
                        <div class="user-answer">
                            <strong>Your Answer:</strong>
                            <span class="${isCorrect ? 'correct-answer' : 'incorrect-answer'}">
                                <c:choose>
                                    <c:when test="${not empty userAnswer}">${userAnswer}</c:when>
                                    <c:otherwise><em>No answer provided</em></c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <c:if test="${not isCorrect}">
                            <div class="correct-answer">
                                <strong>Correct Answer(s):</strong>
                                <c:forEach items="${correctAnswers}" var="correctAnswer" varStatus="answerStatus">
                                    ${correctAnswer}<c:if test="${not answerStatus.last}">, </c:if>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid #ddd; color: #666;">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>