<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ProfileStyle.css">
    <title>Quiz Website - ${userName}'s Profile</title>
</head>
<body>
<div class="container">
    <header class="profile-header">
        <div class="header-content">
            <h1>${userName}'s Profile</h1>
            <nav class="main-nav">
                <a href="/" class="nav-link">Home</a>
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/CreateQuiz" class="nav-link">Create Quiz</a>
                <a href="/history" class="nav-link">Quiz History</a>
                <c:if test="${sessionScope.isAdmin}">
                    <a href="/admin" class="nav-link admin-link">Admin</a>
                </c:if>
                <a href="/logout" class="nav-link logout-link">Logout</a>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <!-- Profile Overview -->
        <section class="profile-overview">
            <div class="profile-avatar">
                <div class="avatar-circle">
                    <span class="avatar-initial">${fn:substring(userName, 0, 1)}</span>
                </div>
            </div>
            <div class="profile-info">
                <h2>${userName}</h2>
                <p class="profile-title">Quiz Enthusiast</p>
                <div class="profile-stats">
                    <div class="stat-item">
                        <span class="stat-number">${totalAttempts}</span>
                        <span class="stat-label">Quizzes Taken</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${totalQuizzesCreated}</span>
                        <span class="stat-label">Quizzes Created</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">${totalAchievements}</span>
                        <span class="stat-label">Achievements</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- Detailed Statistics -->
        <section class="stats-section">
            <h2>📊 Detailed Statistics</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📝</div>
                    <div class="stat-info">
                        <div class="stat-value">${totalAttempts}</div>
                        <div class="stat-name">Total Quiz Attempts</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">📈</div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <fmt:formatNumber value="${averageScore}" maxFractionDigits="1"/>%
                        </div>
                        <div class="stat-name">Average Score</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏆</div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <fmt:formatNumber value="${bestScore}" maxFractionDigits="1"/>%
                        </div>
                        <div class="stat-name">Best Score</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">⏱️</div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${totalTimeTaken >= 3600}">
                                    ${totalTimeTaken / 3600}h ${(totalTimeTaken % 3600) / 60}m
                                </c:when>
                                <c:when test="${totalTimeTaken >= 60}">
                                    ${totalTimeTaken / 60}m ${totalTimeTaken % 60}s
                                </c:when>
                                <c:otherwise>
                                    ${totalTimeTaken}s
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-name">Total Time Spent</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Quiz Attempts -->
        <section class="content-section">
            <h2>📋 Quiz History</h2>
            <div class="section-controls">
                <div class="sort-controls">
                    <label for="sortBy">Sort by:</label>
                    <select id="sortBy" onchange="sortQuizHistory()">
                        <option value="date">Date (Newest First)</option>
                        <option value="date-asc">Date (Oldest First)</option>
                        <option value="score">Score (Highest First)</option>
                        <option value="score-asc">Score (Lowest First)</option>
                        <option value="time">Time (Fastest First)</option>
                        <option value="time-desc">Time (Slowest First)</option>
                    </select>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty userAttempts}">
                    <div class="quiz-attempts-list" id="quizAttemptsList">
                        <c:forEach items="${userAttempts}" var="attempt">
                            <div class="attempt-item"
                                 data-date="${attempt.attemptDate.time}"
                                 data-score="${attempt.percentage}"
                                 data-time="${attempt.timeTaken}">
                                <div class="attempt-header">
                                    <div class="attempt-title">
                                        <a href="/quiz/${attempt.quizId}">Quiz #${attempt.quizId}</a>
                                        <c:if test="${attempt.practiceMode}">
                                            <span class="practice-badge">Practice</span>
                                        </c:if>
                                    </div>
                                    <div class="attempt-score ${attempt.percentage >= 80 ? 'good' : attempt.percentage >= 60 ? 'average' : 'poor'}">
                                        <fmt:formatNumber value="${attempt.percentage}" maxFractionDigits="1"/>%
                                    </div>
                                </div>
                                <div class="attempt-details">
                                    <span class="detail-item">
                                        <strong>Score:</strong> ${attempt.score}/${attempt.totalQuestions}
                                    </span>
                                    <span class="detail-item">
                                        <strong>Time:</strong> ${attempt.timeTaken}s
                                    </span>
                                    <span class="detail-item">
                                        <strong>Date:</strong> <fmt:formatDate value="${attempt.attemptDate}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                    </span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>No Quiz Attempts Yet</h3>
                        <p>You haven't taken any quizzes yet. <a href="/quiz">Browse available quizzes</a> to get started!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Created Quizzes -->
        <c:if test="${not empty userCreatedQuizzes}">
            <section class="content-section">
                <h2>✏️ Created Quizzes</h2>
                <div class="quiz-list">
                    <c:forEach items="${userCreatedQuizzes}" var="quiz">
                        <div class="quiz-item">
                            <div class="quiz-header">
                                <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                <div class="quiz-badges">
                                    <c:if test="${quiz.practiceMode}">
                                        <span class="badge practice">Practice Mode</span>
                                    </c:if>
                                    <c:if test="${quiz.randomOrder}">
                                        <span class="badge random">Random Order</span>
                                    </c:if>
                                    <c:if test="${quiz.onePage}">
                                        <span class="badge single">Single Page</span>
                                    </c:if>
                                </div>
                            </div>
                            <p class="quiz-description">${quiz.description}</p>
                            <div class="quiz-meta">
                                <span><strong>Questions:</strong> ${quiz.NQuestions}</span>
                                <span><strong>Type:</strong> ${quiz.onePage ? 'Single Page' : 'Multi-Page'}</span>
                            </div>
                            <div class="quiz-actions">
                                <a href="/quiz/${quiz.quizID}" class="btn btn-primary">View Details</a>
                                <a href="/quiz/${quiz.quizID}/take" class="btn btn-secondary">Take Quiz</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- Achievements -->
        <section class="content-section">
            <h2>🏆 Achievements</h2>
            <c:choose>
                <c:when test="${not empty userAchievements}">
                    <div class="achievements-grid">
                        <c:forEach items="${userAchievements}" var="userAchievement">
                            <div class="achievement-card">
                                <div class="achievement-icon">
                                    <img src="${pageContext.request.contextPath}${userAchievement.achievement.iconUrl}"
                                         alt="${userAchievement.achievement.name}"
                                         onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMzAiIGN5PSIzMCIgcj0iMzAiIGZpbGw9IiNGRkQ3MDAiLz4KPHR3eHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxOCIgZmlsbD0id2hpdGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj7wn4+GPC90ZXh0Pgo8L3N2Zz4K';">
                                </div>
                                <div class="achievement-content">
                                    <h3>${userAchievement.achievement.name}</h3>
                                    <p>${userAchievement.achievement.description}</p>
                                    <div class="achievement-date">
                                        Earned on <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MMMM dd, yyyy"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>No Achievements Yet</h3>
                        <p>Keep taking quizzes and creating content to unlock achievements!</p>
                        <ul class="achievement-hints">
                            <li>Take your first quiz to unlock <strong>Quiz Machine</strong></li>
                            <li>Create a quiz to unlock <strong>Amateur Author</strong></li>
                            <li>Score 100% on any quiz to unlock <strong>Perfectionist</strong></li>
                            <li>Try practice mode to unlock <strong>Practice Makes Perfect</strong></li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</div>

<script>
    function sortQuizHistory() {
        const sortBy = document.getElementById('sortBy').value;
        const list = document.getElementById('quizAttemptsList');
        const items = Array.from(list.children);

        items.sort((a, b) => {
            switch(sortBy) {
                case 'date':
                    return parseInt(b.dataset.date) - parseInt(a.dataset.date);
                case 'date-asc':
                    return parseInt(a.dataset.date) - parseInt(b.dataset.date);
                case 'score':
                    return parseFloat(b.dataset.score) - parseFloat(a.dataset.score);
                case 'score-asc':
                    return parseFloat(a.dataset.score) - parseFloat(b.dataset.score);
                case 'time':
                    return parseInt(a.dataset.time) - parseInt(b.dataset.time);
                case 'time-desc':
                    return parseInt(b.dataset.time) - parseInt(a.dataset.time);
                default:
                    return 0;
            }
        });

        items.forEach(item => list.appendChild(item));
    }
</script>
</body>
</html>