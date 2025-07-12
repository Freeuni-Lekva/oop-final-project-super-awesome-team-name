<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/QuizFeedbackStyle.css">
    <title>Answer Feedback</title>
</head>
<body>
<div class="panel">
    <div class="feedback-container">
        <div class="feedback-header ${isCorrect ? 'correct' : 'incorrect'}">
            <h2>${isCorrect ? 'Correct!' : 'Incorrect'}</h2>
        </div>

        <div class="feedback-content">
            <div class="question-text">${question.question}</div>

            <div class="answer-comparison">
                <div class="user-answer">
                    <strong>Your Answer:</strong> ${userAnswer}
                </div>

                <c:if test="${not isCorrect}">
                    <div class="correct-answer">
                        <strong>Correct Answer:</strong> ${correctAnswer}
                    </div>
                </c:if>
            </div>
        </div>

        <div class="navigation">
            <c:choose>
                <c:when test="${questionIndex + 1 == totalQuestions}">
                    <a href="/quiz/${quizId}/complete" class="btn-primary">View Final Results</a>
                </c:when>
                <c:otherwise>
                    <a href="/quiz/${quizId}/take?questionIndex=${questionIndex + 1}" class="btn-primary">
                        Next Question (${questionIndex + 2}/${totalQuestions})
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>