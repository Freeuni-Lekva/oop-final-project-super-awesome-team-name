<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/CreateQuizStyle.css">
    <script src="${pageContext.request.contextPath}/js/CreateQuiz.js"></script>
    <title>Create Quiz</title>
</head>
<body>
<div class="panel">
    <div class="left-panel">
        <h1>Create Quiz</h1>
    </div>

    <div class="right-panel">
        <form action="${pageContext.request.contextPath}/CreateQuiz" method="post">
            <label for="QuizName">Quiz Name:</label>
            <input type="text" id="QuizName" name="QuizName" required/><br/><br/>

            <label for="QuizDescription">Quiz Description:</label><br/>
            <textarea id="QuizDescription" name="QuizDescription" rows="3" cols="25" required></textarea><br/><br/>

            <label for="NQuestions">Number of Questions:</label>
            <input type="number" id="NQuestions" name="NQuestions" min="1" max="${maxQuestions}" required/><br/><br/>

            <label for="randomOrder">Randomize Order:</label>
            <select name="randomOrder" id="randomOrder">
                <option value="No">No</option>
                <option value="Yes">Yes</option>
            </select><br/><br/>

            <label for="onePage">Display on One Page:</label>
            <select name="onePage" id="onePage">
                <option value="No">No</option>
                <option value="Yes" selected>Yes</option>
            </select><br/><br/>

            <div id="immediateCorrectionContainer">
                <label for="immediateCorrection">Immediate Correction:</label>
                <select name="immediateCorrection" id="immediateCorrection">
                    <option value="No">No</option>
                    <option value="Yes">Yes</option>
                </select><br/><br/>
            </div>

            <label for="practiceMode">Allow Practice Mode:</label>
            <select name="practiceMode" id="practiceMode">
                <option value="No">No</option>
                <option value="Yes">Yes</option>
            </select><br/><br/>

            <input type="submit" value="Create Quiz Form"/>
        </form>
    </div>
</div>
</body>
</html>
