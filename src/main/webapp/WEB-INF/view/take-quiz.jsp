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

                if (questionType === 'Multiple Choice') {
                    // Check radio buttons
                    let radios = question.querySelectorAll('input[type="radio"]');
                    radios.forEach(function(radio) {
                        if (radio.checked) {
                            answered = true;
                            console.log("Found checked radio with value: " + radio.value);
                        }
                    });
                } else if (questionType === 'Multiple Choice with Multiple Answers') {
                    // Check checkboxes
                    let checkboxes = question.querySelectorAll('input[type="checkbox"]');
                    checkboxes.forEach(function(checkbox) {
                        if (checkbox.checked) {
                            answered = true;
                            console.log("Found checked checkbox with value: " + checkbox.value);
                        }
                    });
                } else if (questionType === 'Matching') {
                    // Check if the matching order has been set (drag and drop)
                    let hiddenInput = question.querySelector('input[name="question_' + index + '"]');
                    if (hiddenInput && hiddenInput.value && hiddenInput.value.trim() !== '') {
                        answered = true;
                        console.log("Matching question answered with order: " + hiddenInput.value);
                    } else {
                        console.log("Matching question not answered - no order set");
                    }
                } else {
                    // Check text inputs for other question types
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
                            ${question.question}
                    </div>

                    <!-- Only show images for Picture-Response questions -->
                    <c:if test="${question.questionType == 'Picture-Response'}">
                        <c:if test="${not empty question.imageURL}">
                            <img src="${question.imageURL}" alt="Question Image" class="question-image">
                        </c:if>
                    </c:if>

                    <!-- Multiple Choice (Radio Buttons) -->
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
                                                   name="question_${status.index}"
                                                   value="${trimmedChoice}"
                                                   id="choice_${status.index}_${trimmedChoice}">
                                            <label for="choice_${status.index}_${trimmedChoice}">${trimmedChoice}</label>
                                        </div>
                                    </c:if>
                                </c:forTokens>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Question-Response (Text Input) -->
                    <c:if test="${question.questionType == 'Question-Response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Enter your answer here...">
                        </div>
                    </c:if>

                    <!-- Fill in the Blank (Text Input) -->
                    <c:if test="${question.questionType == 'Fill in the Blank'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Fill in the blank...">
                        </div>
                    </c:if>

                    <!-- Picture-Response (Text Input) -->
                    <c:if test="${question.questionType == 'Picture-Response'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Describe what you see in the image...">
                        </div>
                    </c:if>

                    <!-- Multi-Answer (Text Input with comma separation) -->
                    <c:if test="${question.questionType == 'Multi-Answer'}">
                        <div class="answer-options">
                            <input type="text"
                                   name="question_${status.index}"
                                   class="text-answer"
                                   placeholder="Enter multiple answers separated by commas...">
                        </div>
                    </c:if>

                    <!-- Multiple Choice with Multiple Answers (Checkboxes) -->
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
                                                   name="question_${status.index}"
                                                   value="${trimmedChoice}"
                                                   id="choice_${status.index}_${trimmedChoice}">
                                            <label for="choice_${status.index}_${trimmedChoice}">${trimmedChoice}</label>
                                        </div>
                                    </c:if>
                                </c:forTokens>
                            </c:if>
                        </div>
                    </c:if>

                    <!-- Matching (Drag and Drop Interface) -->
                    <c:if test="${question.questionType == 'Matching'}">
                        <div class="answer-options">
                            <c:set var="correctAnswer" value="${question.correctAnswer}" />
                            <c:if test="${not empty correctAnswer}">
                                <!-- Debug: Show what we're working with -->
                                <div style="font-size: 10px; color: #999; margin-bottom: 10px;">
                                    [DEBUG: Correct Answer = "${correctAnswer}"]
                                </div>

                                <!-- Parse the matching pairs properly -->
                                <c:set var="leftItems" value="" />
                                <c:set var="rightItems" value="" />

                                <!-- Split by semicolon and extract items -->
                                <c:forTokens items="${correctAnswer}" delims=";" var="pair" varStatus="pairStatus">
                                    <c:if test="${fn:contains(pair, '=')}">
                                        <c:set var="leftItem" value="${fn:trim(fn:substringBefore(pair, '='))}" />
                                        <c:set var="rightItem" value="${fn:trim(fn:substringAfter(pair, '='))}" />

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

                                <!-- Debug: Show parsed items -->
                                <div style="font-size: 10px; color: #999; margin-bottom: 15px;">
                                    [DEBUG: Left Items = "${leftItems}"]<br>
                                    [DEBUG: Right Items = "${rightItems}"]
                                </div>

                                <!-- Create the matching interface -->
                                <div class="matching-container" style="display: flex; gap: 40px; margin-top: 20px;">
                                    <!-- Fixed Left Column -->
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

                                    <!-- Draggable Right Column -->
                                    <div class="matching-right" style="flex: 1;">
                                        <h4 style="margin-bottom: 15px; text-align: center;">Drag to Match</h4>
                                        <div id="dragContainer_${status.index}" class="drag-container" style="min-height: 200px;">
                                            <c:forTokens items="${rightItems}" delims="|" var="rightItem" varStatus="rightStatus">
                                                <div class="draggable-item" draggable="true" data-value="${rightItem}" data-index="${rightStatus.index}"
                                                     style="display: flex; align-items: center; margin-bottom: 10px; padding: 15px;
                                                            border: 2px solid #2196F3; border-radius: 8px; background-color: #e3f2fd;
                                                            cursor: move; font-weight: bold; min-height: 60px; transition: all 0.3s ease;">
                                                    <div class="drag-handle" style="margin-right: 10px; color: #1976D2; font-size: 16px;">
                                                        ⋮⋮
                                                    </div>
                                                    <div class="item-text" style="color: #1976D2;">
                                                            ${rightItem}
                                                    </div>
                                                </div>
                                            </c:forTokens>
                                        </div>
                                    </div>
                                </div>

                                <!-- Hidden input to store the final order -->
                                <input type="hidden" name="question_${status.index}" id="question_${status.index}_order" />

                                <div style="margin-top: 15px; padding: 10px; background-color: #fff3cd; border-radius: 5px; border: 1px solid #ffeaa7;">
                                    <strong>Instructions:</strong> Drag the items on the right to match them with the items on the left.
                                    The correct answer is when each item on the left matches with the correct item on the right in the same row.
                                </div>

                                <script>
                                    (function() {
                                        const container = document.getElementById('dragContainer_${status.index}');
                                        const hiddenInput = document.getElementById('question_${status.index}_order');
                                        let draggedElement = null;

                                        // Get the left items array for pairing
                                        const leftItemsArray = '${leftItems}'.split('|');

                                        // Update hidden input with current order
                                        function updateOrder() {
                                            const items = container.querySelectorAll('.draggable-item');
                                            const order = [];
                                            items.forEach((item, index) => {
                                                const value = item.getAttribute('data-value');
                                                const leftItem = leftItemsArray[index] || leftItemsArray[0];
                                                order.push(leftItem + '=' + value);
                                            });
                                            hiddenInput.value = order.join(',');
                                            console.log('Updated matching order:', hiddenInput.value);
                                        }

                                        // Add drag and drop event listeners
                                        container.addEventListener('dragstart', function(e) {
                                            if (e.target.classList.contains('draggable-item')) {
                                                draggedElement = e.target;
                                                e.target.style.opacity = '0.5';
                                            }
                                        });

                                        container.addEventListener('dragend', function(e) {
                                            if (e.target.classList.contains('draggable-item')) {
                                                e.target.style.opacity = '1';
                                                updateOrder();
                                            }
                                        });

                                        container.addEventListener('dragover', function(e) {
                                            e.preventDefault();
                                        });

                                        container.addEventListener('drop', function(e) {
                                            e.preventDefault();
                                            if (draggedElement && e.target.classList.contains('draggable-item')) {
                                                const rect = e.target.getBoundingClientRect();

                                                if (e.clientY > rect.top + rect.height / 2) {
                                                    container.insertBefore(draggedElement, e.target.nextSibling);
                                                } else {
                                                    container.insertBefore(draggedElement, e.target);
                                                }
                                                updateOrder();
                                            }
                                        });

                                        // Initialize the order
                                        updateOrder();

                                        // Add hover effects
                                        container.addEventListener('mouseenter', function(e) {
                                            if (e.target.classList.contains('draggable-item')) {
                                                e.target.style.transform = 'translateY(-2px)';
                                                e.target.style.boxShadow = '0 4px 8px rgba(0,0,0,0.2)';
                                            }
                                        }, true);

                                        container.addEventListener('mouseleave', function(e) {
                                            if (e.target.classList.contains('draggable-item')) {
                                                e.target.style.transform = 'translateY(0)';
                                                e.target.style.boxShadow = 'none';
                                            }
                                        }, true);
                                    })();
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