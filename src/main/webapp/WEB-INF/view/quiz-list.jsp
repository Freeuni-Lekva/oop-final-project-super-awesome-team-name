<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Quizzes</title>
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

        .quiz-header p {
            font-size: large;
            opacity: 0.9;
            color: white;
            font-weight: normal;
        }

        .content-area {
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .main-quiz-title {
            text-align: center;
            margin: 25px auto 30px auto;
            padding: 0 40px;
        }

        .main-quiz-title h2 {
            font-size: xx-large;
            margin: 0;
            color: #0D0D0D;
            font-weight: bold;
        }

        .main-quiz-title p {
            font-size: small;
            color: #666;
            margin: 10px 0 0 0;
            font-weight: normal;
        }

        .nav {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 35px;
            flex-wrap: wrap;
        }

        .nav a {
            padding: 10px 25px;
            background: transparent;
            color: #38077F;
            text-decoration: none;
            border-radius: 5px;
            border: 1px solid #38077F;
            font-weight: bold;
            font-size: small;
            transition: all 0.3s ease;
        }

        .nav a:hover {
            background-color: #38077F;
            color: white;
        }

        .quiz-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
            margin: 30px 0;
        }

        .quiz-card {
            background: #f9f9f9;
            padding: 30px;
            border-radius: 15px;
            border: 1px solid #ccc;
            transition: all 0.3s ease;
        }

        .quiz-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: #38077F;
        }

        .quiz-title {
            font-size: medium;
            font-weight: bold;
            color: #0D0D0D;
            margin-bottom: 12px;
        }

        .quiz-description {
            color: #666;
            margin-bottom: 18px;
            line-height: 1.6;
            font-size: small;
        }

        .quiz-meta {
            font-size: x-small;
            color: #999;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #ddd;
        }

        .quiz-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            text-align: center;
            display: inline-block;
            font-size: small;
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

        .section-title {
            color: #0D0D0D;
            font-size: large;
            margin: 40px 0 25px 0;
            font-weight: bold;
            border-bottom: 2px solid #38077F;
            padding-bottom: 10px;
        }

        .no-quizzes {
            text-align: center;
            padding: 50px;
            color: #666;
            background: #f9f9f9;
            border-radius: 15px;
            border: 1px solid #ccc;
        }

        .no-quizzes h3 {
            font-size: large;
            margin-bottom: 15px;
            color: #0D0D0D;
        }

        .no-quizzes p {
            font-size: small;
            color: #666;
        }

        .creator-link {
            color: #38077F;
            text-decoration: none;
            font-weight: bold;
        }

        .creator-link:hover {
            text-decoration: underline;
        }

        .error {
            background: linear-gradient(135deg, #870C06, #C7140D);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            font-size: small;
            font-weight: bold;
        }

        @media (max-width: 768px) {
            .content-area {
                padding: 25px;
            }

            .quiz-header h1 {
                font-size: large;
            }

            .quiz-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="panel">
    <div class="quiz-header">
        <div class="quiz-header-content">
            <h1>Quiz Center</h1>
            <p>Test your knowledge and challenge yourself with our interactive quiz platform</p>
        </div>
    </div>

    <div class="content-area">
        <div class="main-quiz-title">
            <h2>Available Quizzes</h2>
            <p>Choose a quiz to test your knowledge</p>
        </div>

        <div class="nav">
            <a href="/">Home</a>
            <a href="/history">My History</a>
            <a href="/logout">Logout</a>
        </div>

        <c:if test="${not empty error}">
            <div class="error">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>

        <h3 class="section-title">Popular Quizzes</h3>
        <c:choose>
            <c:when test="${not empty popularQuizzes}">
                <div class="quiz-grid">
                    <c:forEach items="${popularQuizzes}" var="quiz" varStatus="status">
                        <div class="quiz-card">
                            <div class="quiz-title">${quiz.title}</div>
                            <div class="quiz-description">${quiz.description}</div>
                            <div class="quiz-meta">
                                Created by <a href="#" class="creator-link">${quiz.creatorName}</a>
                                | <fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy"/>
                            </div>
                            <div class="quiz-actions">
                                <a href="/quiz/${quiz.quizId}" class="btn btn-primary">View Details</a>
                                <a href="/quiz/${quiz.quizId}/take" class="btn btn-success">Start Quiz</a>
                                <c:if test="${quiz.allowPracticeMode}">
                                    <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-secondary">Practice</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-quizzes">
                    <p>No popular quizzes yet. Be the first to take a quiz!</p>
                </div>
            </c:otherwise>
        </c:choose>

        <h3 class="section-title">All Available Quizzes</h3>
        <c:choose>
            <c:when test="${not empty allQuizzes}">
                <div class="quiz-grid">
                    <c:forEach items="${allQuizzes}" var="quiz">
                        <div class="quiz-card">
                            <div class="quiz-title">${quiz.title}</div>
                            <div class="quiz-description">${quiz.description}</div>
                            <div class="quiz-meta">
                                Created by <a href="#" class="creator-link">${quiz.creatorName}</a>
                                | <fmt:formatDate value="${quiz.createdDate}" pattern="MMM dd, yyyy"/>
                                <c:if test="${quiz.randomOrder}"> | Random Order</c:if>
                                <c:if test="${quiz.allowPracticeMode}"> | Practice Available</c:if>
                            </div>
                            <div class="quiz-actions">
                                <a href="/quiz/${quiz.quizId}" class="btn btn-primary">View Details</a>
                                <a href="/quiz/${quiz.quizId}/take" class="btn btn-success">Start Quiz</a>
                                <c:if test="${quiz.allowPracticeMode}">
                                    <a href="/quiz/${quiz.quizId}/take?practiceMode=true" class="btn btn-secondary">Practice</a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-quizzes">
                    <h3>No quizzes available yet!</h3>
                    <p>Check back later for new quizzes to test your knowledge.</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div style="text-align: center; margin-top: 40px; padding-top: 20px; border-top: 2px solid #ddd; color: #666;">
            <p style="font-size: x-small;"><em>Quiz Website - Person 3 Implementation</em></p>
        </div>
    </div>
</div>
</body>
</html>