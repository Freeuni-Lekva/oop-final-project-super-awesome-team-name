<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
    String quizTitle = request.getParameter("QuizName");
    String quizDescription = request.getParameter("QuizDescription");
    int numQuestions = Integer.parseInt(request.getParameter("NQuestions"));

    String randomOrder = request.getParameter("randomOrder");
    String onePage = request.getParameter("onePage");
    String immediateCorrection = request.getParameter("immediateCorrection");
    String practiceMode = request.getParameter("practiceMode");
    String creatorUsername = (String) session.getAttribute("username");

    String[] questionTypes = {
            "Question-Response",
            "Fill in the Blank",
            "Multiple Choice",
            "Picture-Response",
            "Multi-Answer",
            "Multiple Choice with Multiple Answers",
            "Matching"
    };
%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Quiz - Step 2</title>
    <style>
        .error-message {
            color: red;
            font-weight: bold;
            margin-top: 5px;
        }
    </style>
    <script>
        function showFields(selectElem, index) {
            const container = document.getElementById("dynamicFields_" + index);
            container.innerHTML = "";

            const type = selectElem.value;

            const errorDiv = document.getElementById("error_questionText_" + index);
            if (errorDiv) errorDiv.innerText = "";

            if (type === "Question-Response" || type === "Fill in the Blank") {
                container.innerHTML +=
                    '<label>Correct Answer:</label><br/>' +
                    '<input type="text" name="correctAnswer_' + index + '" required /><br/><br/>';
            } else if (type === "Multiple Choice") {
                container.innerHTML +=
                    '<label>Option 1:</label><br/>' +
                    '<input type="text" name="answerOption1_' + index + '" /><br/>' +
                    '<label>Option 2:</label><br/>' +
                    '<input type="text" name="answerOption2_' + index + '" /><br/>' +
                    '<label>Option 3:</label><br/>' +
                    '<input type="text" name="answerOption3_' + index + '" /><br/><br/>' +
                    '<label>Correct Answer:</label><br/>' +
                    '<input type="text" name="correctAnswer_' + index + '" required /><br/><br/>';
            } else if (type === "Picture-Response") {
                container.innerHTML +=
                    '<label>Image URL:</label><br/>' +
                    '<input type="url" name="imageUrl_' + index + '" id="imageUrl_' + index + '" required ' +
                    'oninput="previewImage(' + index + ')" /><br/>' +
                    '<div id="imagePreview_' + index + '"></div><br/>' +
                    '<label>Correct Answer:</label><br/>' +
                    '<input type="text" name="correctAnswer_' + index + '" required /><br/><br/>';
            } else if (type === "Multi-Answer") {
                container.innerHTML +=
                    '<label>How many correct answers?</label><br/>' +
                    '<input type="number" name="numCorrect_' + index + '" min="1" ' +
                    'onblur="validateMultiAnswerCount(this, ' + index + ')" ' +
                    'oninput="generateMultiAnswerInputs(' + index + ', this.value)" />' +
                    '<div class="error-message" id="error_numCorrect_' + index + '"></div><br/>' +
                    '<label>Order matters?</label> ' +
                    '<select name="orderMatters_' + index + '">' +
                    '<option value="no" selected>No</option>' +
                    '<option value="yes">Yes</option>' +
                    '</select>' +
                    '<div id="multiAnswerInputs_' + index + '"></div>';
            } else if (type === "Multiple Choice with Multiple Answers") {
                container.innerHTML +=
                    '<label>How many correct answers? (1-4)</label><br/>' +
                    '<input type="number" name="numCorrectMCMA_' + index + '" min="1" max="4" ' +
                    'onblur="validateNumberRange(this, 1, 4)" ' +
                    'oninput="generateMCMAInputs(' + index + ', this.value)" />' +
                    '<div class="error-message" id="error_numCorrectMCMA_' + index + '"></div><br/>' +
                    '<div id="mcmaInputs_' + index + '"></div>';
            } else if (type === "Matching") {
                container.innerHTML +=
                    '<label>How many pairs? (2-5)</label><br/>' +
                    '<input type="number" name="numPairs_' + index + '" min="2" max="5" ' +
                    'onblur="validateNumberRange(this, 2, 5)" ' +
                    'oninput="generateMatchingInputs(' + index + ', this.value)" />' +
                    '<div class="error-message" id="error_numPairs_' + index + '"></div><br/>' +
                    '<div id="matchingInputs_' + index + '"></div>';
            }

            validateFillInTheBlank(index);
        }

        function validateMultiAnswerCount(inputElem, index) {
            const val = parseInt(inputElem.value);
            const errorDiv = document.getElementById("error_numCorrect_" + index);
            errorDiv.innerText = "";

            if (isNaN(val) || val <= 1) {
                errorDiv.innerText = "Value must be greater than 1";
            }
        }

        function generateMultiAnswerInputs(index, count) {
            const container = document.getElementById("multiAnswerInputs_" + index);
            container.innerHTML = "";
            const num = parseInt(count);
            if (isNaN(num) || num < 1) return;
            for (let i = 1; i <= num; i++) {
                container.innerHTML +=
                    '<label>Correct Answer ' + i + ':</label><br/>' +
                    '<input type="text" name="correctAnswer_' + index + '_' + i + '" required /><br/>';
            }
        }

        function generateMCMAInputs(index, correctCount) {
            const container = document.getElementById("mcmaInputs_" + index);
            container.innerHTML = "";
            const numCorrect = parseInt(correctCount);
            if (isNaN(numCorrect) || numCorrect < 1 || numCorrect > 4) return;

            for (let i = 1; i <= numCorrect; i++) {
                container.innerHTML +=
                    '<label>Correct Answer ' + i + ':</label><br/>' +
                    '<input type="text" name="correctAnswerMCMA_' + index + '_' + i + '" required /><br/>';
            }
            for (let i = 1; i <= 4 - numCorrect; i++) {
                container.innerHTML +=
                    '<label>Potential Answer ' + i + ':</label><br/>' +
                    '<input type="text" name="optionMCMA_' + index + '_' + i + '" /><br/>';
            }
        }

        function generateMatchingInputs(index, pairCount) {
            const container = document.getElementById("matchingInputs_" + index);
            container.innerHTML = "";
            const num = parseInt(pairCount);
            if (isNaN(num) || num < 2 || num > 5) return;
            for (let i = 1; i <= num; i++) {
                container.innerHTML +=
                    '<label>Pair ' + i + ' - Left:</label><br/>' +
                    '<input type="text" name="pairLeft_' + index + '_' + i + '" required /><br/>' +
                    '<label>Pair ' + i + ' - Right:</label><br/>' +
                    '<input type="text" name="pairRight_' + index + '_' + i + '" required /><br/><br/>';
            }
        }

        function validateFillInTheBlank(index) {
            const questionType = document.getElementById('questionType_' + index);
            const questionText = document.getElementById('questionText_' + index);
            const errorDiv = document.getElementById('error_questionText_' + index);

            if (!questionType || !questionText || !errorDiv) return true;

            const type = questionType.value;
            const text = questionText.value;

            if (type === 'Fill in the Blank') {
                const count = (text.match(/_/g) || []).length;
                if (count !== 1) {
                    errorDiv.innerText = "Please include exactly one underscore (_) in the question text.";
                    return false;
                } else {
                    errorDiv.innerText = "";
                }
            } else {
                errorDiv.innerText = "";
            }
            return true;
        }

        function validateNumberRange(inputElem, min, max) {
            const val = parseInt(inputElem.value);
            const errorId = "error_" + inputElem.name;
            const errorDiv = document.getElementById(errorId);
            errorDiv.innerText = "";

            if (isNaN(val)) return;

            if (min !== null && val < min) {
                inputElem.value = min;
                errorDiv.innerText = "Value must be between " + min + " and " + max;
            } else if (max !== null && val > max) {
                inputElem.value = max;
                errorDiv.innerText = "Value must be between " + min + " and " + max;
            }
        }

        function validateForm() {
            const total = <%= numQuestions %>;
            let valid = true;

            for (let i = 1; i <= total; i++) {
                if (!validateFillInTheBlank(i)) valid = false;
            }

            return valid;
        }

        function previewImage(index) {
            const url = document.getElementById("imageUrl_" + index).value;
            const previewDiv = document.getElementById("imagePreview_" + index);
            previewDiv.innerHTML = "";

            if (url.trim() !== "") {
                const img = document.createElement("img");
                img.src = url;
                img.alt = "Image Preview";
                img.style.maxWidth = "300px";
                img.style.marginTop = "10px";
                img.onerror = function () {
                    previewDiv.innerHTML = "<span class='error-message'>Invalid image URL.</span>";
                };
                const heading = document.createElement("div");
                heading.textContent = "Displaying image:";
                heading.style.fontWeight = "bold";
                heading.style.marginTop = "8px";
                heading.style.marginBottom = "-3px";

                previewDiv.appendChild(heading);
                previewDiv.appendChild(img);
            }
        }

    </script>
</head>
<body>
<h2>Design Questions for Quiz: <%= quizTitle %></h2>

<form action="CreateQuizServlet" method="post" onsubmit="return validateForm();">
    <input type="hidden" name="QuizName" value="<%= quizTitle %>" />
    <input type="hidden" name="QuizDescription" value="<%= quizDescription %>" />
    <input type="hidden" name="NQuestions" value="<%= numQuestions %>" />
    <input type="hidden" name="randomOrder" value="<%= randomOrder %>" />
    <input type="hidden" name="onePage" value="<%= onePage %>" />
    <input type="hidden" name="immediateCorrection" value="<%= immediateCorrection %>" />
    <input type="hidden" name="practiceMode" value="<%= practiceMode %>" />
    <input type="hidden" name="creatorUsername" value="<%= creatorUsername %>" />

    <%
        for (int i = 1; i <= numQuestions; i++) {
    %>
    <fieldset>
        <legend>Question <%= i %></legend>

        <label for="questionType_<%= i %>">Question Type:</label>
        <select name="questionType_<%= i %>" id="questionType_<%= i %>" onchange="showFields(this, <%= i %>)" required>
            <option value="">-- Choose Question Type --</option>
            <% for (String type : questionTypes) { %>
            <option value="<%= type %>"><%= type %></option>
            <% } %>
        </select><br/><br/>

        <label>Question Text:</label><br/>
        <textarea name="questionText_<%= i %>" id="questionText_<%= i %>" rows="3" cols="60" required
                  oninput="validateFillInTheBlank(<%= i %>)"></textarea>
        <div class="error-message" id="error_questionText_<%= i %>"></div><br/>

        <div id="dynamicFields_<%= i %>"></div>
    </fieldset><br/>
    <%
        }
    %>

    <a href="Created_Quiz_Result.jsp"><input type="submit" value="Save Quiz" /></a>
</form>
</body>
</html>
