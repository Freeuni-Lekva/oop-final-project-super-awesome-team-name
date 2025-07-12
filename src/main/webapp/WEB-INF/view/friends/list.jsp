<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ProfileStyle.css">
    <title>Super Awesome Quiz Website - My Friends</title>
</head>
<body>
<div class="container">
    <header class="profile-header">
        <div class="header-content-centered">
            <h1>Super Awesome Quiz Website</h1>
            <div class="user-welcome">
                <span>My Friends</span>
            </div>
            <nav class="main-nav">
                <a href="/" class="nav-link">Home</a>
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/profile" class="nav-link">My Profile</a>
                <a href="/friends/search" class="nav-link">Find Friends</a>
                <a href="/friends/list" class="nav-link">My Friends</a>
                <a href="/messages/inbox" class="nav-link">Messages</a>
                <c:if test="${sessionScope.isAdmin}">
                    <a href="/admin" class="nav-link admin-link">Admin</a>
                </c:if>
                <a href="/logout" class="nav-link logout-link">Logout</a>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <c:if test="${not empty error}">
            <div class="error-message">
                <p>${error}</p>
            </div>
        </c:if>

        <!-- Current Friends -->
        <section class="friends-section">
            <h2>My Friends (${fn:length(friends)})</h2>
            <c:choose>
                <c:when test="${not empty friends}">
                    <div class="friends-grid">
                        <c:forEach items="${friends}" var="friendship">
                            <div class="friend-card">
                                <div class="friend-info">
                                    <h3><a href="/user/${friendship.friendName}" class="friend-link">${friendship.friendName}</a></h3>
                                    <p class="friend-since">Friends since <fmt:formatDate value="${friendship.since}" pattern="MMM dd, yyyy"/></p>
                                </div>
                                <div class="friend-actions">
                                    <a href="/user/${friendship.friendName}" class="btn btn-secondary">View Profile</a>
                                    <button onclick="removeFriend('${friendship.friendName}')" class="btn btn-danger">Remove</button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>You don't have any friends yet. <a href="/friends/search">Find some friends!</a></p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Pending Sent Requests -->
        <c:if test="${not empty sentRequests}">
            <section class="requests-section">
                <h2>Pending Friend Requests (${fn:length(sentRequests)})</h2>
                <div class="requests-list">
                    <c:forEach items="${sentRequests}" var="request">
                        <div class="request-item sent">
                            <div class="request-info">
                                <h4>Request sent to <a href="/user/${request.requesteeName}">${request.requesteeName}</a></h4>
                                <p class="request-date">Sent on <fmt:formatDate value="${request.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm"/></p>
                            </div>
                            <div class="request-status">
                                <span class="status-badge pending">Pending</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- Received Requests -->
        <c:if test="${not empty receivedRequests}">
            <section class="requests-section">
                <h2>Friend Requests from Others (${fn:length(receivedRequests)})</h2>
                <p>Check your <a href="/messages/inbox">messages</a> to accept or decline these requests.</p>
                <div class="requests-list">
                    <c:forEach items="${receivedRequests}" var="request">
                        <div class="request-item received">
                            <div class="request-info">
                                <h4>Request from <a href="/user/${request.requesterName}">${request.requesterName}</a></h4>
                                <p class="request-date">Received on <fmt:formatDate value="${request.createdAt}" pattern="MMM dd, yyyy 'at' HH:mm"/></p>
                            </div>
                            <div class="request-actions">
                                <a href="/messages/inbox" class="btn btn-primary">View in Messages</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <!-- Quick Actions -->
        <section class="quick-actions-section">
            <h2>Quick Actions</h2>
            <div class="quick-actions">
                <a href="/friends/search" class="btn btn-primary">Find More Friends</a>
                <a href="/messages/inbox" class="btn btn-secondary">Check Messages</a>
                <a href="/quiz" class="btn btn-secondary">Browse Quizzes</a>
            </div>
        </section>
    </main>
</div>

<script>
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