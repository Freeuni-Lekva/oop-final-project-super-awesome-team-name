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
            <p>Taking Quiz</p>
        </div>
    </div>

    <div class="main-quiz-title">
        <h2>${quiz.quizName}</h2>
        <p>${quiz.description}</p>
    </div>

    <!-- Check if this is a single page quiz -->
    <c:choose>
        <c:when test="${quiz.onePage}">
            <!-- SINGLE PAGE MODE: Show all questions at once -->
            <div class="quiz-info">
                <div class="quiz-info-left">
                    <div>
                        <strong>Questions:</strong> ${questions.size()}
                    </div>
                    <c:if test="${practiceMode}">
                        <span class="practice-mode">Practice Mode</span>
                    </c:if>
                    <div class="quiz-mode-indicator">
                        <span class="single-page-mode">Single Page Mode</span>
                    </div>
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
                        <div class="question-container" data-question-id="${question.questionID}" data-question-type="${question.questionType}">
                            <div class="question-number">
                                Question ${status.index + 1} of ${questions.size()}
                            </div>

                            <div class="question-text">
                                    ${question.question}
                            </div>

                            <c:if test="${question.questionType == 'Picture-Response'}">
                                <c:if test="${not empty question.imageURL}">
                                    <img src="${question.imageURL}" alt="Question Image" class="question-image">
                                </c:if>
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
                                           placeholder="Enter your answer here...">
                                </div>
                            </c:if>

                            <c:if test="${question.questionType == 'Fill in the Blank'}">
                                <div class="answer-options">
                                    <input type="text"
                                           name="question_${question.questionID}"
                                           class="text-answer"
                                           placeholder="Fill in the blank...">
                                </div>
                            </c:if>

                            <c:if test="${question.questionType == 'Picture-Response'}">
                                <div class="answer-options">
                                    <input type="text"
                                           name="question_${question.questionID}"
                                           class="text-answer"
                                           placeholder="Describe what you see in the image...">
                                </div>
                            </c:if>

                            <c:if test="${question.questionType == 'Multi-Answer'}">
                                <div class="answer-options">
                                    <input type="text"
                                           name="question_${question.questionID}"
                                           class="text-answer"
                                           placeholder="Enter multiple answers separated by commas...">
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
                        <a href="/quiz" class="btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </c:when>
        <c:otherwise>
            <!-- MULTI-PAGE MODE: This shouldn't normally be reached, but just in case -->
            <div class="content-area">
                <div class="quiz-mode-notice">
                    <h3>Multi-Page Quiz Mode</h3>
                    <p>This quiz is configured to show one question at a time.</p>
                    <p>You will be redirected to the first question.</p>
                    <a href="/quiz/${quiz.quizID}/take?questionIndex=0&practiceMode=${practiceMode}" class="btn-primary">
                        Start Quiz
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.7);">
        <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
    </div>
</div>

<script type="text/javascript">
    // Only run scroll progress for single page mode
    <c:if test="${quiz.onePage}">
    window.addEventListener('scroll', function() {
        var scrollPercent = (window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100;
        document.querySelector('.progress-fill').style.width = Math.min(scrollPercent, 100) + '%';
    });
    </c:if>
</script>
</body>
</html>