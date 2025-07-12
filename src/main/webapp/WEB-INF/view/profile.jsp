<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ProfileStyle.css">
    <title>Super Awesome Quiz Website - ${sessionScope.name}'s Profile</title>
</head>
<body>
<div class="container">
    <header class="profile-header">
        <div class="header-content-centered">
            <h1>Super Awesome Quiz Website</h1>
            <div class="user-welcome">
                <span>${sessionScope.name}'s Profile</span>
            </div>
            <nav class="main-nav">
                <a href="/" class="nav-link">Home</a>
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/CreateQuiz" class="nav-link">Create Quiz</a>
                <a href="/history" class="nav-link">My History</a>
                <a href="/messages/inbox" class="nav-link">Messages
                    <c:if test="${unreadMessageCount > 0}">
                        <span class="notification-badge">${unreadMessageCount}</span>
                    </c:if>
                </a>
                <c:if test="${sessionScope.isAdmin}">
                    <a href="/admin" class="nav-link admin-link">Admin</a>
                </c:if>
                <a href="/logout" class="nav-link logout-link">Logout</a>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <!-- Profile Stats Overview -->
        <section class="profile-stats-section">
            <h2>${sessionScope.name}'s Activity Summary</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">${totalAttempts}</div>
                    <div class="stat-label">Quizzes Taken</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${totalCreatedQuizzes}</div>
                    <div class="stat-label">Quizzes Created</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${totalAchievements}</div>
                    <div class="stat-label">Achievements</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${totalFriends}</div>
                    <div class="stat-label">Friends</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">
                        <fmt:formatNumber value="${averageScore}" maxFractionDigits="1"/>%
                    </div>
                    <div class="stat-label">Average Score</div>
                </div>
            </div>
        </section>

        <!-- Friends' Recent Activities - Horizontal Scroll -->
        <section class="friends-scroll-section">
            <h2>Friends' Recent Activities</h2>
            <c:choose>
                <c:when test="${hasFriends}">
                    <div class="friends-activity-scroll">
                        <c:forEach items="${friendActivities}" var="friendActivity">
                            <div class="friend-activity-card">
                                <h3>
                                    <a href="/user/${friendActivity.friendName}" class="friend-link">
                                            ${friendActivity.friendName}
                                    </a>
                                </h3>

                                <!-- Friend's Recent Quiz Attempts -->
                                <c:if test="${not empty friendActivity.recentAttempts}">
                                    <div class="friend-section">
                                        <h4>Recent Quiz Attempts</h4>
                                        <c:forEach items="${friendActivity.recentAttempts}" var="attempt" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div class="friend-activity-item">
                                                    <div class="activity-text">
                                                        <a href="/quiz/${attempt.quizId}">Quiz #${attempt.quizId}</a>
                                                        - ${attempt.score}/${attempt.totalQuestions}
                                                        (<fmt:formatNumber value="${attempt.percentage}" maxFractionDigits="1"/>%)
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <!-- Friend's Recent Quiz Creations -->
                                <c:if test="${not empty friendActivity.recentQuizzes}">
                                    <div class="friend-section">
                                        <h4>Recent Quiz Creations</h4>
                                        <c:forEach items="${friendActivity.recentQuizzes}" var="quiz" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div class="friend-activity-item">
                                                    <div class="activity-text">
                                                        <a href="/quiz/${quiz.quizID}">${quiz.quizName}</a>
                                                        - ${quiz.NQuestions} questions
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <!-- Friend's Recent Achievements -->
                                <c:if test="${not empty friendActivity.recentAchievements}">
                                    <div class="friend-section">
                                        <h4>Recent Achievements</h4>
                                        <c:forEach items="${friendActivity.recentAchievements}" var="achievement" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div class="friend-activity-item">
                                                    <div class="activity-text">
                                                            ${achievement.achievement.name}
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No friends yet. Add some friends to see their activities here!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Two Column Layout: Recent Quiz Creating Activities and Messages -->
        <div class="profile-content-grid">
            <!-- Recent Quiz Creating Activities -->
            <section class="profile-section">
                <h2>Recent Quiz Creating Activities</h2>
                <c:choose>
                    <c:when test="${not empty userCreatedQuizzes}">
                        <div class="activity-list">
                            <c:forEach items="${userCreatedQuizzes}" var="quiz">
                                <div class="activity-item quiz-creation">
                                    <div class="activity-content">
                                        <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                        <p class="activity-description">${quiz.description}</p>
                                        <div class="activity-meta">
                                                ${quiz.NQuestions} questions
                                            <c:if test="${quiz.practiceMode}"> | Practice Mode Available</c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>No quizzes created yet. <a href="/CreateQuiz">Create your first quiz!</a></p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Message Notifications -->
            <section class="profile-section">
                <h2>Recent Messages
                    <c:if test="${unreadMessageCount > 0}">
                        <span class="notification-count">(${unreadMessageCount} unread)</span>
                    </c:if>
                </h2>
                <c:choose>
                    <c:when test="${hasMessages}">
                        <div class="message-list">
                            <c:forEach items="${recentMessages}" var="message" varStatus="status">
                                <c:if test="${status.index < 3}">
                                    <div class="message-item ${message.read ? '' : 'unread'}">
                                        <div class="message-type">
                                            <c:choose>
                                                <c:when test="${message.messageType == 'FRIEND_REQUEST'}">
                                                    <span class="type-label">Friend Request</span>
                                                </c:when>
                                                <c:when test="${message.messageType == 'CHALLENGE'}">
                                                    <span class="type-label">Quiz Challenge</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="type-label">Message</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="message-content">
                                            <h4><a href="/messages/view/${message.messageId}">${message.subject}</a></h4>
                                            <p class="message-from">From: ${message.senderName}</p>
                                            <p class="message-date">
                                                <fmt:formatDate value="${message.createdAt}" pattern="MMM dd, yyyy"/>
                                            </p>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                        <div class="view-all-link">
                            <a href="/messages/inbox">View All Messages →</a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>No messages yet. When you receive messages, they'll appear here!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</div>
</body>
</html>