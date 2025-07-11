<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/TakeQuizStyle.css">
    <title>Taking Quiz: ${quiz.quizName}</title>
    <script src="${pageContext.request.contextPath}/js/takeQuiz.js" defer></script>
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
            <div class="quiz-mode-indicator">
                <span class="multi-page-mode">Multi-Page Mode</span>
            </div>
        </div>
        <div class="timer">
            Time: <span id="timer">00:00</span>
        </div>
    </div>

    <div class="progress-bar">
        <div class="progress-fill" style="width: ${(questionIndex + 1) * 100 / totalQuestions}%"></div>
    </div>

    <div class="content-area">
        <form id="quizForm" method="post" action="/quiz/${quiz.quizID}/submit-single" onsubmit="return validateSingleForm()">
            <input type="hidden" name="questionIndex" value="${questionIndex}">
            <input type="hidden" name="practiceMode" value="${practiceMode}">

            <div class="question-container" data-question-id="${question.questionID}" data-question-type="${question.questionType}">
                <div class="question-text">
                    ${question.question}
                </div>

                <!-- Picture Response Question -->
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

                <!-- Multiple Choice Question -->
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

                <!-- Question Response -->
                <c:if test="${question.questionType == 'Question-Response'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Enter your answer here..."
                               autofocus>
                    </div>
                </c:if>

                <!-- Fill in the Blank -->
                <c:if test="${question.questionType == 'Fill in the Blank'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Fill in the blank..."
                               autofocus>
                    </div>
                </c:if>

                <!-- Multi-Answer -->
                <c:if test="${question.questionType == 'Multi-Answer'}">
                    <div class="answer-options">
                        <input type="text"
                               name="question_${question.questionID}"
                               class="text-answer"
                               placeholder="Enter multiple answers separated by commas..."
                               autofocus>
                    </div>
                </c:if>

                <!-- Multiple Choice with Multiple Answers -->
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

                <!-- Matching Questions -->
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

                                    <!-- Clean up { and } characters -->
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

                <a href="/quiz" class="btn-secondary">Cancel Quiz</a>
            </div>
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

    function validateSingleForm() {
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
            alert('Please answer the question before continuing.');
            return false;
        }

        return true;
    }
</script>
</body>
</html>