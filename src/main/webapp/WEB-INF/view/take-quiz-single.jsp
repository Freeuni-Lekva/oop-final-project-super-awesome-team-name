<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TakeQuizStyle.css">
    <title>Taking Quiz: ${quiz.quizName}</title>
    <script src="${pageContext.request.contextPath}/js/takeQuiz.js" defer></script>
    <style>
        .question-container {
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .submit-section {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 20px;
            position: relative;
        }

        .btn-primary, .btn-success, .btn-secondary, .practice-mode-button {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.3s ease;
            min-width: 180px;
            height: 48px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            box-sizing: border-box;
        }

        .btn-primary {
            background-color: #2196F3;
            color: white;
        }

        .btn-primary:hover:not(:disabled) {
            background-color: #1976D2;
        }

        .btn-success {
            background-color: #4caf50;
            color: white;
        }

        .btn-success:hover:not(:disabled) {
            background-color: #45a049;
        }

        .btn-secondary {
            background-color: #757575;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #616161;
        }

        .practice-mode-button {
            background-color: #ff9800;
            color: white;
        }

        .practice-mode-button:hover:not(:disabled) {
            background-color: #f57c00;
        }

        .btn-primary:disabled, .btn-success:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
            opacity: 0.6;
        }
    </style>
</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz Platform</h1>
            <p>Question ${questionIndex + 1} of ${totalQuestions}</p>
        </div>
    </div>

    <div class="main-quiz-title">
        <h2>${quiz.quizName}</h2>
        <c:if test="${not empty quiz.description}">
            <p>${quiz.description}</p>
        </c:if>
    </div>

    <div class="quiz-info">
        <div class="quiz-info-left">
            <div>
                <strong>Question ${questionIndex + 1} of ${totalQuestions}</strong>
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
        <div class="progress-fill" style="width: ${(questionIndex + 1) * 100 / totalQuestions}%"></div>
    </div>

    <div class="content-area">
        <form id="quizForm" method="post" action="${pageContext.request.contextPath}/quiz/${quiz.quizID}/submit-single" onsubmit="return ${quiz.immediateCorrection ? 'false' : 'validateSingleForm()'}">
            <input type="hidden" name="questionIndex" value="${questionIndex}">
            <input type="hidden" name="practiceMode" value="${practiceMode}">

            <div class="question-container" data-question-id="${question.questionID}" data-question-type="${question.questionType}">
                <div class="question-text">
                    ${question.question}
                </div>


                <c:if test="${question.questionType == 'Picture-Response'}">
                    <c:if test="${not empty question.imageURL}">
                        <img src="${question.imageURL}" alt="Question Image" class="question-image">
                    </c:if>
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Describe what you see in the image..."
                               autofocus>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Multiple Choice'}">
                    <div class="answer-options">
                        <c:if test="${not empty question.possibleAnswers}">
                            <c:set var="cleanAnswers" value="${fn:replace(question.possibleAnswers, '[', '')}" />
                            <c:set var="cleanAnswers" value="${fn:replace(cleanAnswers, ']', '')}" />
                            <c:set var="cleanAnswers" value="${fn:replace(cleanAnswers, '\"', '')}" />
                            <c:forTokens items="${cleanAnswers}" delims="," var="choice">
                                <c:set var="trimmedChoice" value="${fn:trim(choice)}" />
                                <c:if test="${not empty trimmedChoice}">
                                    <div class="radio-option">
                                        <input type="radio"
                                               name="question_${question.questionID}"
                                               value="${trimmedChoice}"
                                               id="choice_${question.questionID}_${trimmedChoice}">
                                        <label for="choice_${question.questionID}_${trimmedChoice}">${trimmedChoice}</label>
                                    </div>
                                </c:if>
                            </c:forTokens>
                        </c:if>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Question-Response'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Enter your answer here..."
                               autofocus>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Fill in the Blank'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Fill in the blank..."
                               autofocus>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Multi-Answer'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Enter multiple answers separated by commas..."
                               autofocus>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Multiple Choice with Multiple Answers'}">
                    <div class="answer-options">
                        <c:if test="${not empty question.possibleAnswers}">
                            <c:set var="cleanAnswers" value="${fn:replace(question.possibleAnswers, '[', '')}" />
                            <c:set var="cleanAnswers" value="${fn:replace(cleanAnswers, ']', '')}" />
                            <c:set var="cleanAnswers" value="${fn:replace(cleanAnswers, '\"', '')}" />
                            <c:forTokens items="${cleanAnswers}" delims="," var="choice">
                                <c:set var="trimmedChoice" value="${fn:trim(choice)}" />
                                <c:if test="${not empty trimmedChoice}">
                                    <div class="checkbox-option">
                                        <input type="checkbox"
                                               name="question_${question.questionID}"
                                               value="${trimmedChoice}"
                                               id="choice_${question.questionID}_${trimmedChoice}">
                                        <label for="choice_${question.questionID}_${trimmedChoice}">${trimmedChoice}</label>
                                    </div>
                                </c:if>
                            </c:forTokens>
                        </c:if>
                    </div>
                </c:if>


                <c:if test="${question.questionType == 'Matching'}">
                    <div class="answer-options">
                        <c:set var="correctAnswer" value="${question.correctAnswer}" />
                        <c:if test="${not empty correctAnswer}">
                            <c:set var="leftItems" value="" />
                            <c:set var="rightItems" value="" />

                            <c:forTokens items="${correctAnswer}" delims="," var="pair" varStatus="pairStatus">
                                <c:set var="cleanPair" value="${fn:trim(pair)}" />
                                <c:if test="${fn:contains(cleanPair, '=')}">
                                    <c:set var="leftItem" value="${fn:trim(fn:substringBefore(cleanPair, '='))}" />
                                    <c:set var="rightItem" value="${fn:trim(fn:substringAfter(cleanPair, '='))}" />


                                    <c:set var="leftItem" value="${fn:replace(leftItem, '{', '')}" />
                                    <c:set var="leftItem" value="${fn:replace(leftItem, '}', '')}" />
                                    <c:set var="rightItem" value="${fn:replace(rightItem, '{', '')}" />
                                    <c:set var="rightItem" value="${fn:replace(rightItem, '}', '')}" />

                                    <c:choose>
                                        <c:when test="${pairStatus.first}">
                                            <c:set var="leftItems" value="${leftItem}" />
                                            <c:set var="rightItems" value="${rightItem}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="leftItems" value="${leftItems}|${leftItem}" />
                                            <c:set var="rightItems" value="${rightItems}|${rightItem}" />
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </c:forTokens>

                            <div class="matching-container" style="display: flex; gap: 40px; margin-top: 20px;">
                                <div class="matching-left" style="flex: 1;">
                                    <h4 style="margin-bottom: 15px; text-align: center;">Items to Match</h4>
                                    <c:forTokens items="${leftItems}" delims="|" var="leftItem" varStatus="leftStatus">
                                        <div class="fixed-item" data-index="${leftStatus.index}"
                                             style="display: flex; align-items: center; margin-bottom: 10px; padding: 15px;
                                                    border: 2px solid #4CAF50; border-radius: 8px; background-color: #f1f8e9;
                                                    font-weight: bold; min-height: 60px;">
                                            <div class="item-number" style="min-width: 30px; color: #2E7D32; font-size: 18px;">
                                                    ${leftStatus.index + 1}.
                                            </div>
                                            <div class="item-text" style="margin-left: 10px; color: #2E7D32;">
                                                    ${leftItem}
                                            </div>
                                        </div>
                                    </c:forTokens>
                                </div>

                                <div class="matching-right" style="flex: 1;">
                                    <h4 style="margin-bottom: 15px; text-align: center;">Drag to Match</h4>
                                    <div id="dragContainer_${question.questionID}" class="drag-container" style="min-height: 200px;">
                                        <c:forTokens items="${rightItems}" delims="|" var="rightItem" varStatus="rightStatus">
                                            <div class="draggable-item" draggable="true" data-value="${rightItem}" data-index="${rightStatus.index}"
                                                 style="display: flex; align-items: center; margin-bottom: 10px; padding: 15px;
                                                        border: 2px solid #2196F3; border-radius: 8px; background-color: #e3f2fd;
                                                        cursor: move; font-weight: bold; min-height: 60px; transition: all 0.3s ease;">
                                                <div class="drag-handle" style="margin-right: 10px; color: #1976D2; font-size: 16px;">
                                                    *
                                                </div>
                                                <div class="item-text" style="color: #1976D2;">
                                                        ${rightItem}
                                                </div>
                                            </div>
                                        </c:forTokens>
                                    </div>
                                </div>
                            </div>

                            <input type="hidden" name="question_${question.questionID}" id="question_${question.questionID}_order" />

                            <script>
                                window.addEventListener("DOMContentLoaded", function () {
                                    initMatchingDragAndDrop("dragContainer_${question.questionID}",
                                        "question_${question.questionID}_order",
                                        "${leftItems}");
                                });
                            </script>

                        </c:if>
                    </div>
                </c:if>
            </div>

            <div class="submit-section">
                <c:choose>
                    <c:when test="${quiz.immediateCorrection}">
                        <button type="button" id="submitAnswerBtn" class="btn-primary" onclick="submitAnswer()">
                            Submit Answer
                        </button>
                        <c:choose>
                            <c:when test="${questionIndex + 1 == totalQuestions}">
                                <button type="button" id="continueBtn" class="btn-success" onclick="continueQuiz()" disabled>
                                    View Final Results
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="button" id="continueBtn" class="btn-success" onclick="continueQuiz()" disabled>
                                    Continue to Next Question
                                </button>
                            </c:otherwise>
                        </c:choose>

                        <div style="position: relative; height: 60px; margin-top: 15px;">
                            <div id="feedbackArea" style="display: none; position: absolute; top: 0; left: 0; right: 0; padding: 15px; border-radius: 8px; text-align: center; background-color: rgba(255,255,255,0.1);">
                                <div id="feedbackMessage"></div>
                                <div id="answerComparison"></div>
                            </div>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <c:choose>
                            <c:when test="${questionIndex + 1 == totalQuestions}">
                                <c:choose>
                                    <c:when test="${practiceMode}">
                                        <input type="submit" value="Submit Final Answer (Practice)" class="practice-mode-button">
                                    </c:when>
                                    <c:otherwise>
                                        <input type="submit" value="Submit Final Answer" class="btn-primary">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <input type="submit" value="Submit & Continue" class="btn-primary">
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/quiz" class="btn-secondary">Cancel Quiz</a>
            </div>
        </form>
        </form>
    </div>

    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
        <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
    </div>
</div>

<script type="text/javascript">
    var startTime = new Date().getTime();

    function updateTimer() {
        var currentTime = new Date().getTime();
        var elapsed = Math.floor((currentTime - startTime) / 1000);
        var minutes = Math.floor(elapsed / 60);
        var seconds = elapsed % 60;
        document.getElementById('timer').innerHTML =
            minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
    }

    setInterval(updateTimer, 1000);

    function submitAnswer() {
        if (!validateAnswer()) {
            return;
        }

        document.getElementById('submitAnswerBtn').disabled = true;
        document.getElementById('submitAnswerBtn').innerHTML = 'Submitting...';


        var params = new URLSearchParams();


        params.append('questionIndex', '${questionIndex}');
        params.append('practiceMode', '${practiceMode}');


        var question = document.querySelector('.question-container');
        var questionType = question.dataset.questionType;
        var questionId = question.dataset.questionId;


        if (questionType === 'Multiple Choice') {
            var selectedRadio = question.querySelector('input[type="radio"]:checked');
            if (selectedRadio) {
                params.append('question_' + questionId, selectedRadio.value);
            }
        } else if (questionType === 'Multiple Choice with Multiple Answers') {
            var selectedCheckboxes = question.querySelectorAll('input[type="checkbox"]:checked');
            if (selectedCheckboxes.length > 0) {
                selectedCheckboxes.forEach(function(cb) {
                    params.append('question_' + questionId, cb.value);
                });
            }
        } else if (questionType === 'Matching') {
            var hiddenInput = question.querySelector('input[type="hidden"][name^="question_"]');
            if (hiddenInput && hiddenInput.value) {
                params.append('question_' + questionId, hiddenInput.value);
            }
        } else {
            var textInput = question.querySelector('input[type="text"], textarea');
            if (textInput) {
                params.append('question_' + questionId, textInput.value);
            }
        }

        var submitUrl = '${pageContext.request.contextPath}/quiz/${quiz.quizID}/submit-answer';
        fetch(submitUrl, {
            method: 'POST',
            body: params,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error('HTTP error! status: ' + response.status + ', body: ' + text);
                    });
                }

                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showFeedback(data);
                    changeQuestionColor(data.isCorrect);
                    enableContinueButton();
                    disableFormInputs();
                } else {
                    alert('Error: ' + (data.message || 'Unknown error'));
                    document.getElementById('submitAnswerBtn').disabled = false;
                    document.getElementById('submitAnswerBtn').innerHTML = 'Submit Answer';
                }
            })
            .catch(error => {
                alert('Failed to submit answer: ' + error.message);
                document.getElementById('submitAnswerBtn').disabled = false;
                document.getElementById('submitAnswerBtn').innerHTML = 'Submit Answer';
            });
    }

    function showFeedback(data) {
    }

    function changeQuestionColor(isCorrect) {
        var questionContainer = document.querySelector('.question-container');

        if (isCorrect) {
            questionContainer.style.backgroundColor = '#0eff0e';
            questionContainer.style.borderColor = '#0b0';
        } else {
            questionContainer.style.backgroundColor = '#f2291a';
            questionContainer.style.borderColor = '#b11509';
        }

        questionContainer.style.transition = 'all 0.3s ease';
    }

    function enableContinueButton() {
        var continueBtn = document.getElementById('continueBtn');
        continueBtn.disabled = false;
        continueBtn.style.opacity = '1';
    }

    function disableFormInputs() {
        var form = document.getElementById('quizForm');
        var inputs = form.querySelectorAll('input, textarea, select');
        inputs.forEach(function(input) {
            if (input.type !== 'hidden') {
                input.disabled = true;
            }
        });
    }

    function continueQuiz() {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/quiz/${quiz.quizID}/continue';
        var questionIndexInput = document.createElement('input');
        questionIndexInput.type = 'hidden';
        questionIndexInput.name = 'questionIndex';
        questionIndexInput.value = '${questionIndex}';
        form.appendChild(questionIndexInput);

        var practiceModeInput = document.createElement('input');
        practiceModeInput.type = 'hidden';
        practiceModeInput.name = 'practiceMode';
        practiceModeInput.value = '${practiceMode}';
        form.appendChild(practiceModeInput);

        document.body.appendChild(form);
        form.submit();
    }

    function validateAnswer() {
        var question = document.querySelector('.question-container');
        var questionType = question.dataset.questionType;
        var answered = false;

        if (questionType === 'Multiple Choice') {
            var radios = question.querySelectorAll('input[type="radio"]');
            radios.forEach(function(radio) {
                if (radio.checked) {
                    answered = true;
                }
            });
        } else if (questionType === 'Multiple Choice with Multiple Answers') {
            var checkboxes = question.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    answered = true;
                }
            });
        } else if (questionType === 'Matching') {
            var hiddenInput = question.querySelector('input[type="hidden"][name^="question_"]');
            if (hiddenInput && hiddenInput.value && hiddenInput.value.trim() !== '') {
                answered = true;
            }
        } else {
            var textInput = question.querySelector('input[type="text"], textarea');
            if (textInput && textInput.value.trim() !== '') {
                answered = true;
            }
        }

        if (!answered) {
            alert('Please answer the question before submitting.');
            return false;
        }

        return true;
    }

    function validateSingleForm() {
        return validateAnswer();
    }

    window.addEventListener('load', function() {
        var continueBtn = document.getElementById('continueBtn');
        if (continueBtn) {
            continueBtn.style.opacity = '0.5';
        }
    });
</script>

</body>
</html>