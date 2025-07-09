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
            background: radial-gradient(ellipse 150% 120% at 80% 85%, #5AC77A 0%, #4CAF50 8%, #43A047 15%, #388E3C 25%, #2E7D32 35%, #1B5E20 45%, #0D4F1A 55%, #0A3814 65%, #000000 75%);
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

        .main-quiz-title {
            text-align: center;
            margin: 25px auto 30px auto;
            padding: 0 40px;
        }

        .main-quiz-title h2 {
            font-size: xx-large;
            margin: 0;
            color: white;
            font-weight: bold;
        }

        .main-quiz-title p {
            font-size: small;
            color: rgba(255, 255, 255, 0.8);
            margin: 10px 0 0 0;
            font-weight: normal;
        }

        .quiz-info {
            background: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            border-bottom: 1px solid #ddd;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            max-width: 860px;
            margin: 20px auto;
            border-radius: 15px;
            position: relative;
        }

        .quiz-info-left {
            display: flex;
            align-items: center;
            gap: 20px;
            color: #0D0D0D;
        }

        .timer {
            font-size: small;
            font-weight: bold;
            color: #5AC77A;
            background: rgba(90, 199, 122, 0.1);
            padding: 8px 16px;
            border-radius: 5px;
            border: 1px solid #5AC77A;
        }

        .practice-mode {
            background-color: #1579C1;
            color: white;
            padding: 12px 24px;
            border-radius: 5px;
            font-weight: bold;
            font-size: small;
            position: absolute;
            left: 50%;
            transform: translateX(-50%);
        }

        .progress-bar {
            width: 100%;
            height: 6px;
            background: rgba(255, 255, 255, 0.1);
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #5AC77A, #4CAF50);
            transition: width 0.3s ease;
        }

        .content-area {
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        .question-container {
            margin: 30px 0;
            padding: 25px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .question-number {
            font-size: x-small;
            color: #666;
            margin-bottom: 15px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .question-text {
            font-size: medium;
            color: #0D0D0D;
            margin-bottom: 25px;
            line-height: 1.5;
            font-weight: bold;
        }

        .question-image {
            max-width: 100%;
            height: auto;
            border-radius: 15px;
            margin: 20px 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .answer-options {
            margin: 25px 0;
        }

        .radio-option {
            display: flex;
            align-items: center;
            margin: 15px 0;
            padding: 15px;
            background: #FFFFFF;
            border-radius: 5px;
            border: 1px solid #ccc;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .radio-option:hover {
            border-color: #5AC77A;
            background: rgba(90, 199, 122, 0.1);
        }

        .radio-option input[type="radio"] {
            margin-right: 15px;
            transform: scale(1.2);
        }

        .radio-option label {
            cursor: pointer;
            font-size: small;
            font-weight: normal;
            width: 100%;
        }

        .text-answer {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: small;
            transition: border-color 0.3s ease;
            background: #FFFFFF;
            font-family: 'Century Gothic', 'Segoe UI', 'Arial', 'Helvetica', sans-serif;
        }

        .text-answer:focus {
            outline: none;
            border-color: #5AC77A;
        }

        .submit-section {
            text-align: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.2);
        }

        input[type=submit] {
            width: auto;
            color: white;
            padding: 12px 30px;
            margin: 10px;
            border: none;
            border-radius: 5px;
            font-size: small;
            cursor: pointer;
            font-weight: bold;
            font-family: 'Century Gothic', 'Segoe UI', 'Arial', 'Helvetica', sans-serif;
        }

        .btn-primary {
            background: linear-gradient(135deg, #5AC77A, #4CAF50);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #4CAF50, #43A047);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #666, #888);
            color: white;
            text-decoration: none;
            display: inline-block;
            padding: 12px 30px;
            margin: 10px;
            border: none;
            border-radius: 5px;
            font-size: small;
            cursor: pointer;
            font-weight: bold;
            font-family: 'Century Gothic', 'Segoe UI', 'Arial', 'Helvetica', sans-serif;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: linear-gradient(135deg, #888, #999);
        }

        .practice-mode-button {
            background: linear-gradient(135deg, #1579C1, #1976D2);
        }

        .practice-mode-button:hover {
            background: linear-gradient(135deg, #1976D2, #1565C0);
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 20px;
            }

            .quiz-header h1 {
                font-size: large;
            }

            .question-container {
                padding: 20px;
            }

            .quiz-info {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .quiz-info-left {
                flex-direction: column;
                gap: 10px;
            }

            .practice-mode {
                position: static;
                transform: none;
                left: auto;
                margin: 10px 0;
            }
        }
    </style>
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
        <h2>${quiz.title}</h2>
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
        <form id="quizForm" method="post" action="/quiz/${quiz.quizId}/submit" onsubmit="return validateForm()">
            <input type="hidden" name="practiceMode" value="${practiceMode}">

            <c:forEach items="${questions}" var="question" varStatus="status">
                <div class="question-container" data-question-id="${question.questionId}" data-question-type="${question.questionType}">
                    <div class="question-number">
                        Question ${status.index + 1} of ${questions.size()}
                    </div>

                    <div class="question-text">
                            ${question.questionText}
                    </div>

                    <c:if test="${not empty question.imageUrl}">
                        <img src="${question.imageUrl}" alt="Question Image" class="question-image">
                    </c:if>

                    <c:if test="${question.questionType == 'multiple_choice'}">
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
                                               name="question_${question.questionId}"
                                               value="${trimmedChoice}"
                                               id="choice_${question.questionId}_${status.index}">
                                        <label for="choice_${question.questionId}_${status.index}">${trimmedChoice}</label>
                                    </div>
                                </c:if>
                            </c:forTokens>
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'question_response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${question.questionId}"
                                   class="text-answer"
                                   placeholder="Enter your answer here...">
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'fill_blank'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${question.questionId}"
                                   class="text-answer"
                                   placeholder="Fill in the blank...">
                        </div>
                    </c:if>

                    <c:if test="${question.questionType == 'picture_response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${question.questionId}"
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
                <a href="/quiz/${quiz.quizId}" class="btn-secondary">Cancel</a>
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