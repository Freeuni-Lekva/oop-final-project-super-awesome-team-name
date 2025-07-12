<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ProfileStyle.css">
    <title>Super Awesome Quiz Website - ${profileUser}'s Profile</title>
</head>
<body>
<div class="container">
    <header class="profile-header">
        <div class="header-content-centered">
            <h1>Super Awesome Quiz Website</h1>
            <div class="user-welcome">
                <span>${profileUser}'s Profile</span>
            </div>
            <nav class="main-nav">
                <a href="/" class="nav-link">Home</a>
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/CreateQuiz" class="nav-link">Create Quiz</a>
                <a href="/history" class="nav-link">My History</a>
                <a href="/profile" class="nav-link">My Profile</a>
                <a href="/friends/search" class="nav-link">Find Friends</a>
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
            <h2>${profileUser}'s Quiz Statistics</h2>
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
                    <div class="stat-number">
                        <fmt:formatNumber value="${averageScore}" maxFractionDigits="1"/>%
                    </div>
                    <div class="stat-label">Average Score</div>
                </div>
            </div>
        </section>

        <!-- Friend Actions Section -->
        <c:if test="${!isOwnProfile}">
            <section class="friend-actions-section">
                <div class="friend-status-card">
                    <c:choose>
                        <c:when test="${friendshipStatus == 'friends'}">
                            <div class="friendship-status friends">
                                <h3>You are friends with ${profileUser}</h3>
                                <button onclick="removeFriend('${profileUser}')" class="btn btn-danger">
                                    Remove Friend
                                </button>
                            </div>
                        </c:when>
                        <c:when test="${friendshipStatus == 'request_sent'}">
                            <div class="friendship-status pending">
                                <h3>Friend request sent to ${profileUser}</h3>
                                <p>Waiting for ${profileUser} to accept your friend request.</p>
                            </div>
                        </c:when>
                        <c:when test="${friendshipStatus == 'request_received'}">
                            <div class="friendship-status received">
                                <h3>${profileUser} wants to be your friend</h3>
                                <p>Check your messages to accept or decline the friend request.</p>
                                <a href="/messages/inbox" class="btn btn-primary">View Messages</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="friendship-status none">
                                <h3>Add ${profileUser} as a friend</h3>
                                <button onclick="sendFriendRequest('${profileUser}')" class="btn btn-primary">
                                    Send Friend Request
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </c:if>

        <!-- Content Grid -->
        <div class="profile-content-grid">
            <!-- Recent Quiz Creations -->
            <section class="profile-section">
                <h2>${profileUser}'s Recent Quiz Creations</h2>
                <c:choose>
                    <c:when test="${not empty recentCreatedQuizzes}">
                        <div class="activity-list">
                            <c:forEach items="${recentCreatedQuizzes}" var="quiz">
                                <div class="activity-item quiz-creation">
                                    <div class="activity-content">
                                        <h3><a href="/quiz/${quiz.quizID}">${quiz.quizName}</a></h3>
                                        <p class="activity-description">${quiz.description}</p>
                                        <div class="activity-meta">
                                                ${quiz.NQuestions} questions
                                            <c:if test="${quiz.practiceMode}"> | Practice Mode Available</c:if>
                                        </div>
                                        <div class="quiz-actions">
                                            <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary">Take Quiz</a>
                                            <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">Details</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>${profileUser} hasn't created any quizzes yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Recent Achievements -->
            <section class="profile-section">
                <h2>${profileUser}'s Recent Achievements</h2>
                <c:choose>
                    <c:when test="${not empty recentAchievements}">
                        <div class="achievements-list">
                            <c:forEach items="${recentAchievements}" var="userAchievement">
                                <div class="achievement-item">
                                    <div class="achievement-icon">
                                        <img src="${pageContext.request.contextPath}${userAchievement.achievement.iconUrl}"
                                             alt="${userAchievement.achievement.name}"
                                             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGRkQ3MDAiLz4KPHR3eHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxMiIsICZxdW90O2ZpbGw9IndoaXRlJnF1b3Q7IHRleHQtYW5jaG9yPSZxdW90O21pZGRsZSZxdW90OyBkeT0mcXVvdDsuM2VtJnF1b3Q7PvCfj4Y8L3RleHQ+Cjwvc3ZnPgo=';">
                                    </div>
                                    <div class="achievement-content">
                                        <h4>${userAchievement.achievement.name}</h4>
                                        <p>${userAchievement.achievement.description}</p>
                                        <div class="achievement-date">
                                            Earned on <fmt:formatDate value="${userAchievement.earnedDate}" pattern="MMM dd, yyyy"/>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <p>${profileUser} hasn't earned any achievements yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>
        </div>
    </main>
</div>

<script>
    function sendFriendRequest(username) {
        if (confirm('Send friend request to ' + username + '?')) {
            fetch('/user/' + username + '/add-friend', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.status === 'success') {
                        location.reload();
                    }
                })
                .catch(error => {
                    alert('Error sending friend request');
                });
        }
    }

    function removeFriend(username) {
        if (confirm('Remove ' + username + ' from your friends list?')) {
            fetch('/user/' + username + '/remove-friend', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
                .then(response => response.json())
                .then(data => {
                    alert(data.message);
                    if (data.status === 'success') {
                        location.reload();
                    }
                })
                .catch(error => {
                    alert('Error removing friend');
                });
        }
    }
</script>
</body>
</html>