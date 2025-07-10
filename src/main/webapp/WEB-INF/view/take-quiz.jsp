<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href = ${pageContext.request.contextPath}/css/TakeQuizStyle.css>

    <title>Taking Quiz: ${quiz.quizName}</title>
    <script>
        let startTime = new Date().getTime();

        function updateTimer() {
            let currentTime = new Date().getTime();
            let elapsed = Math.floor((currentTime - startTime) / 1000);
            let minutes = Math.floor(elapsed / 60);
            let seconds = elapsed % 60;
            document.getElementById('timer').innerHTML =
                minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
        }

        setInterval(updateTimer, 1000);

        function validateForm() {
            console.log("Form validation started");

            let form = document.getElementById('quizForm');
            let questions = document.querySelectorAll('.question-container');
            let allAnswered = true;
            let unansweredQuestions = [];

            questions.forEach(function(question, index) {
                let questionId = question.dataset.questionId;
                let questionType = question.dataset.questionType;
                let answered = false;

                console.log("Checking question " + questionId + " of type " + questionType);

                if (questionType === 'multiple_choice') {
                    let radios = question.querySelectorAll('input[type="radio"]');
                    radios.forEach(function(radio) {
                        if (radio.checked) {
                            answered = true;
                            console.log("Found checked radio with value: " + radio.value);
                        }
                    });
                } else {
                    let textInput = question.querySelector('input[type="text"], textarea');
                    if (textInput && textInput.value.trim() !== '') {
                        answered = true;
                        console.log("Found text input with value: " + textInput.value);
                    }
                }

                if (!answered) {
                    allAnswered = false;
                    unansweredQuestions.push(index + 1);
                    question.style.border = '2px solid #F44336';
                } else {
                    question.style.border = '1px solid rgba(255, 255, 255, 0.2)';
                }
            });

            if (!allAnswered) {
                alert('Please answer all questions before submitting. Unanswered questions: ' + unansweredQuestions.join(', '));
                return false;
            }

            // Log all form data before submission
            console.log("=== Form Data Before Submission ===");
            let formData = new FormData(form);
            for (let [key, value] of formData.entries()) {
                console.log(key + ': ' + value);
            }

            return confirm('Are you sure you want to submit your quiz?');
        }

        // Debug function to show all form inputs
        function debugFormInputs() {
            console.log("=== All Form Inputs Debug ===");
            let form = document.getElementById('quizForm');
            let inputs = form.querySelectorAll('input, textarea, select');
            inputs.forEach(function(input) {
                console.log("Input name: " + input.name + ", value: " + input.value + ", type: " + input.type);
            });
        }

        // Call debug function after page loads
        window.onload = function() {
            setTimeout(debugFormInputs, 1000);
        };
    </script>
</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz Platform</h1>
            <p>Taking Quiz</p>
        </div>
    </div>

    <div class="main-quiz-title">
        <h2>${quiz.quizName}</h2>
        <p>${quiz.description}</p>
    </div>

    <div class="quiz-info">
        <div class="quiz-info-left">
            <div>
                <strong>Questions:</strong> ${questions.size()}
            </div>
            <c:if test="${practiceMode}">
                <span class="practice-mode">Practice Mode</span>
            </c:if>
        </div>
        <div class="timer">
            Time: <span id="timer">00:00</span>
        </div>
    </div>

    <div class="progress-bar">
        <div class="progress-fill" style="width: 0%"></div>
    </div>

    <div class="content-area">
        <form id="quizForm" method="post" action="/quiz/${quiz.quizID}/submit" onsubmit="return validateForm()">
            <input type="hidden" name="practiceMode" value="${practiceMode}">

            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-container" data-question-id="${status.index}" data-question-type="${question.questionType}">
                    <div class="question-number">
                        Question ${status.index + 1} of ${questions.size()}
                    </div>

                    <div class="question-text">
                            ${question.questionText}
                    </div>

                    <c:if test="${not empty question.imageUrl}">
                        <img src="${question.imageUrl}" alt="Question Image" class="question-image">
                    </c:if>

                    <c:if test="${question.questionType == 'Multiple Choice'}">
                        <div class="answer-options">
                            <c:set var="choices" value="${question.choices}" />
                            <c:set var="cleanChoices" value="${fn:replace(choices, '[', '')}" />
                            <c:set var="cleanChoices" value="${fn:replace(cleanChoices, ']', '')}" />
                            <c:set var="cleanChoices" value="${fn:replace(cleanChoices, '\"', '')}" />

                            <c:forTokens items="${cleanChoices}" delims="," var="choice">
                                <c:set var="trimmedChoice" value="${fn:trim(choice)}" />
                                <c:if test="${not empty trimmedChoice}">
                                    <div class="radio-option">
                                        <input type="radio"
                                               name="question_${status.index}"
                                               value="${trimmedChoice}"
                                               id="choice_${status.index}_${status.index}">
                                        <label for="choice_${status.index}_${status.index}">${trimmedChoice}</label>
                                    </div>
                                </c:if>
                            </c:forTokens>
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'Question-Response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Enter your answer here...">
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'Fill in the Blank'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Fill in the blank...">
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'Picture-Response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Describe what you see in the image...">
                        </div>
                    </c:if>
                </div>
            </c:forEach>

            <div class="submit-section">
                <c:choose>
                    <c:when test="${practiceMode}">
                        <input type="submit" value="Submit Practice Quiz" class="practice-mode-button">
                    </c:when>
                    <c:otherwise>
                        <input type="submit" value="Submit Quiz" class="btn-primary">
                    </c:otherwise>
                </c:choose>
                <a href="/quiz/${quiz.quizID}" class="btn-secondary">Cancel</a>
            </div>
        </form>
    </div>

    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
        <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
    </div>
</div>

<script>
    window.addEventListener('scroll', function() {
        let scrollPercent = (window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100;
        document.querySelector('.progress-fill').style.width = Math.min(scrollPercent, 100) + '%';
    });
</script>
</body>
</html>