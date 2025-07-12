<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomeStyle.css">
    <title>Quiz Website - Home</title>
</head>
<body>
<div class="container">
    <header class="main-header">
        <div class="header-content">
            <h1>Quiz Website</h1>
            <div class="user-info">
                <span>Welcome, <strong>${userName}</strong>!</span>
                <nav class="main-nav">
                    <a href="/quiz" class="nav-link">Browse Quizzes</a>
                    <a href="/CreateQuiz" class="nav-link">Create Quiz</a>
                    <a href="/history" class="nav-link">My History</a>
                    <a href="/profile" class="nav-link">My Profile</a>
                    <c:if test="${sessionScope.isAdmin}">
                        <a href="/admin" class="nav-link admin-link">Admin</a>
                    </c:if>
                    <a href="/logout" class="nav-link logout-link">Logout</a>
                </nav>
            </div>
        </div>
    </header>

    <main class="main-content">
        <!-- User Stats Dashboard -->
        <section class="user-dashboard">
            <h2>Your Quiz Stats</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${totalAttempts}</div>
                    <div class="stat-label">Quizzes Taken</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <fmt:formatNumber value="${averageScore}" maxFractionDigits="1"/>%
                    </div>
                    <div class="stat-label">Average Score</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${totalAchievements}</div>
                    <div class="stat-label">Achievements</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${fn:length(userCreatedQuizzes)}</div>
                    <div class="stat-label">Quizzes Created</div>
                </div>
            </div>
        </section>

        <div class="content-grid">
            <!-- Announcements Section -->
            <c:if test="${not empty announcements}">
                <section class="content-section">
                    <h2>📢 Latest Announcements</h2>
                    <div class="announcements-list">
                        <c:forEach items="${announcements}" var="announcement" varStatus="status">
                            <div class="announcement-item">
                                <h3>${announcement.title}</h3>
                                <p class="announcement-meta">
                                    By ${announcement.name} • <fmt:formatDate value="${announcement.date}" pattern="MMM dd, yyyy"/>
                                </p>
                                <p class="announcement-text">${announcement.text}</p>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- Popular Quizzes -->
            <section class="content-section">
                <h2>🔥 Popular Quizzes</h2>
                <c:choose>
                    <c:when test="${not empty popularQuizzes}">
                        <div class="quiz-list">
                            <c:forEach items="${popularQuizzes}" var="quiz">
                                <div class="quiz-item">
                                    <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                    <p class="quiz-description">${quiz.description}</p>
                                    <p class="quiz-meta">
                                        By ${quiz.creatorUsername} • ${quiz.NQuestions} questions
                                        <c:if test="${quiz.practiceMode}"> • Practice Available</c:if>
                                    </p>
                                    <div class="quiz-actions">
                                        <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Take Quiz</a>
                                        <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">Details</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">No popular quizzes yet. Be the first to create one!</p>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Recently Created Quizzes -->
            <section class="content-section">
                <h2>🆕 Recently Created Quizzes</h2>
                <c:choose>
                    <c:when test="${not empty recentQuizzes}">
                        <div class="quiz-list">
                            <c:forEach items="${recentQuizzes}" var="quiz">
                                <div class="quiz-item">
                                    <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                    <p class="quiz-description">${quiz.description}</p>
                                    <p class="quiz-meta">
                                        By ${quiz.creatorUsername} • ${quiz.NQuestions} questions
                                    </p>
                                    <div class="quiz-actions">
                                        <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Take Quiz</a>
                                        <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">Details</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">No quizzes created yet.</p>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- User's Recent Activity -->
            <section class="content-section">
                <h2>📊 Your Recent Quiz Activity</h2>
                <c:choose>
                    <c:when test="${not empty recentAttempts}">
                        <div class="activity-list">
                            <c:forEach items="${recentAttempts}" var="attempt">
                                <div class="activity-item">
                                    <div class="activity-info">
                                        <strong>Quiz #${attempt.quizId}</strong>
                                        <span class="activity-score">
                                            ${attempt.score}/${attempt.totalQuestions}
                                            (<fmt:formatNumber value="${attempt.percentage}" maxFractionDigits="1"/>%)
                                        </span>
                                    </div>
                                    <div class="activity-meta">
                                        <fmt:formatDate value="${attempt.attemptDate}" pattern="MMM dd, yyyy 'at' HH:mm"/>
                                        • ${attempt.timeTaken}s
                                        <c:if test="${attempt.practiceMode}"> • Practice Mode</c:if>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="view-all-link">
                            <a href="/history">View Full History →</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">You haven't taken any quizzes yet. <a href="/quiz">Browse available quizzes</a> to get started!</p>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- User's Created Quizzes -->
            <c:if test="${not empty userCreatedQuizzes}">
                <section class="content-section">
                    <h2>✏️ Your Created Quizzes</h2>
                    <div class="quiz-list">
                        <c:forEach items="${userCreatedQuizzes}" var="quiz">
                            <div class="quiz-item">
                                <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                <p class="quiz-description">${quiz.description}</p>
                                <p class="quiz-meta">${quiz.NQuestions} questions</p>
                                <div class="quiz-actions">
                                    <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">View Details</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>
            </c:if>

            <!-- Achievements -->
            <section class="content-section">
                <h2>🏆 Your Achievements</h2>
                <c:choose>
                    <c:when test="${not empty userAchievements}">
                        <div class="achievements-grid">
                            <c:forEach items="${userAchievements}" var="userAchievement" varStatus="status">
                                <c:if test="${status.index < 6}"> <!-- Show only first 6 on homepage -->
                                    <div class="achievement-item">
                                        <div class="achievement-icon">
                                            <img src="${pageContext.request.contextPath}${userAchievement.achievement.iconUrl}"
                                                 alt="${userAchievement.achievement.name}"
                                                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGRkQ3MDAiLz4KPHR3eHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxMiIgZmlsbD0id2hpdGUiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj7wn4+GPC90ZXh0Pgo8L3N2Zz4K';">
                                        </div>
                                        <div class="achievement-info">
                                            <h4>${userAchievement.achievement.name}</h4>
                                            <p>${userAchievement.achievement.description}</p>
                                            <small>Earned: <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MMM dd, yyyy"/></small>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                        <c:if test="${fn:length(userAchievements) > 6}">
                            <div class="view-all-link">
                                <a href="/history">View All ${fn:length(userAchievements)} Achievements →</a>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p class="empty-state">No achievements yet. Keep taking quizzes to unlock them!</p>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>

    <footer class="main-footer">
        <p>Quiz Website - Create, Share, and Learn</p>
    </footer>
</div>
</body>
</html>