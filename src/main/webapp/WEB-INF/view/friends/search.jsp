<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ProfileStyle.css">
    <title>Super Awesome Quiz Website - Find Friends</title>
</head>
<body>
<div class="container">
    <header class="profile-header">
        <div class="header-content-centered">
            <h1>Super Awesome Quiz Website</h1>
            <div class="user-welcome">
                <span>Find Friends</span>
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
        <!-- Search Section -->
        <section class="search-section">
            <h2>Find Friends by Username</h2>
            <p>Enter the exact username of someone you want to add as a friend:</p>

            <form action="/friends/search" method="get" class="search-form">
                <div class="search-input-group">
                    <input type="text" name="query" value="${query}"
                           placeholder="Enter username..." class="search-input" required>
                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </form>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <p>${error}</p>
                </div>
            </c:if>

            <c:if test="${not empty query}">
                <div class="search-results">
                    <h3>Search Results for "${query}"</h3>
                    <c:choose>
                        <c:when test="${not empty searchResults}">
                            <c:forEach items="${searchResults}" var="username">
                                <div class="user-result-card">
                                    <div class="user-info">
                                        <h4>${username}</h4>
                                        <c:choose>
                                            <c:when test="${username == currentUser}">
                                                <span class="status-badge self">This is you!</span>
                                            </c:when>
                                            <c:when test="${fn:contains(currentFriends, username)}">
                                                <span class="status-badge friends">Already friends</span>
                                            </c:when>
                                            <c:when test="${fn:contains(pendingRequests, username)}">
                                                <span class="status-badge pending">Request sent</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge available">Available to add</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="user-actions">
                                        <a href="/user/${username}" class="btn btn-secondary">View Profile</a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:when test="${noResults}">
                            <div class="no-results">
                                <p>No user found with username "${query}". Please check the spelling and try again.</p>
                            </div>
                        </c:when>
                    </c:choose>
                </div>
            </c:if>
        </section>

        <!-- Current Friends Preview -->
        <c:if test="${not empty currentFriends}">
            <section class="friends-preview-section">
                <h2>Your Friends (${fn:length(currentFriends)})</h2>
                <div class="friends-preview-list">
                    <c:forEach items="${currentFriends}" var="friendName" varStatus="status">
                        <c:if test="${status.index < 10}">
                            <div class="friend-preview-item">
                                <a href="/user/${friendName}" class="friend-link">${friendName}</a>
                            </div>
                        </c:if>
                    </c:forEach>
                    <c:if test="${fn:length(currentFriends) > 10}">
                        <div class="friend-preview-item">
                            <a href="/friends/list" class="view-all-link">View all ${fn:length(currentFriends)} friends →</a>
                        </div>
                    </c:if>
                </div>
            </section>
        </c:if>

        <!-- Help Section -->
        <section class="help-section">
            <h2>How to Find Friends</h2>
            <div class="help-content">
                <div class="help-item">
                    <h4>1. Search by Username</h4>
                    <p>Use the search box above to find friends by their exact username. Ask your friends for their Quiz Website username!</p>
                </div>
                <div class="help-item">
                    <h4>2. Browse Quiz Creators</h4>
                    <p>When you see quizzes you like, click on the creator's name to visit their profile and add them as a friend.</p>
                </div>
                <div class="help-item">
                    <h4>3. Check Quiz Leaderboards</h4>
                    <p>Look for top scorers on quizzes and visit their profiles to connect with other quiz enthusiasts!</p>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>