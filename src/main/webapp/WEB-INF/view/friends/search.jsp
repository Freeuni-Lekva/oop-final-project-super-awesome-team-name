<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Find Friends</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            min-height: 100vh;
            color: #ffffff;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header h1 {
            color: #333333;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .nav-link {
            color: #333333;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            background: rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
        }

        .nav-link:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }

        .main-content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .search-section {
            margin-bottom: 30px;
        }

        .search-form {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }

        .search-input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid #e1e5e9;
            border-radius: 15px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn {
            padding: 15px 25px;
            border: none;
            border-radius: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 10px 20px;
            font-size: 14px;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .btn-warning {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
            padding: 10px 20px;
            font-size: 14px;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 193, 7, 0.4);
        }

        .btn-danger {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            color: white;
            padding: 10px 20px;
            font-size: 14px;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.4);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.3);
            color: #155724;
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #721c24;
        }

        .search-results {
            margin-bottom: 30px;
        }

        .search-results h3 {
            color: #333333;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .user-card {
            background: rgba(102, 126, 234, 0.05);
            border: 2px solid rgba(102, 126, 234, 0.1);
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .user-card:hover {
            border-color: rgba(102, 126, 234, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }

        .user-info {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .username {
            font-size: 1.2rem;
            font-weight: 600;
            color: #333333;
        }

        .user-status {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .status-friends {
            color: #28a745;
            font-weight: 600;
        }

        .status-pending {
            color: #ffc107;
            font-weight: 600;
        }

        .status-received {
            color: #17a2b8;
            font-weight: 600;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .sections {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 20px;
        }

        @media (max-width: 768px) {
            .sections {
                grid-template-columns: 1fr;
            }

            .search-form {
                flex-direction: column;
            }
        }

        .section {
            background: rgba(102, 126, 234, 0.02);
            border-radius: 15px;
            padding: 20px;
            border: 1px solid rgba(102, 126, 234, 0.1);
        }

        .section h4 {
            color: #333333;
            margin-bottom: 15px;
            font-size: 1.1rem;
        }

        .friend-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .friend-item {
            background: white;
            border: 1px solid #e1e5e9;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .friend-item:hover {
            border-color: #667eea;
            transform: translateX(5px);
        }

        .friend-name {
            font-weight: 500;
            color: #333333;
        }

        .empty-state {
            text-align: center;
            padding: 30px;
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>Find Friends</h1>
        <div class="nav-links">
            <a href="/" class="nav-link">Home</a>
            <a href="/friends/list" class="nav-link">My Friends</a>
            <a href="/messages/inbox" class="nav-link">Messages</a>
            <a href="/quiz" class="nav-link">Browse Quizzes</a>
            <a href="/logout" class="nav-link">Logout</a>
        </div>
    </div>

    <div class="main-content">
        <div class="search-section">
            <h2 style="color: #333333; margin-bottom: 20px;">Search for Friends</h2>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>Success!</strong> <c:out value="${success}" escapeXml="true"/>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <strong>Error:</strong> <c:out value="${error}" escapeXml="true"/>
                </div>
            </c:if>

            <form action="/friends/search" method="get" class="search-form">
                <input type="text"
                       name="query"
                       class="search-input"
                       placeholder="Enter username to search..."
                       value="${query}"
                       required>
                <button type="submit" class="btn btn-primary">Search</button>
            </form>

            <c:if test="${not empty searchResults}">
                <div class="search-results">
                    <h3>Search Results</h3>
                    <c:forEach items="${searchResults}" var="username">
                        <div class="user-card">
                            <div class="user-info">
                                <div class="username"><c:out value="${username}" escapeXml="true"/></div>
                                <div class="user-status">
                                    <c:choose>
                                        <c:when test="${fn:contains(currentFriends, username)}">
                                            <span class="status-friends">Already Friends</span>
                                        </c:when>
                                        <c:when test="${fn:contains(pendingRequests, username)}">
                                            <span class="status-pending">Friend Request Sent</span>
                                        </c:when>
                                        <c:when test="${fn:contains(receivedRequests, username)}">
                                            <span class="status-received">Sent You a Friend Request</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>Not Connected</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="user-actions">
                                <c:choose>
                                    <c:when test="${fn:contains(currentFriends, username)}">
                                        <form action="/friends/remove" method="post" style="display: inline;"
                                              onsubmit="return confirm('Are you sure you want to remove ${username} from your friends?')">
                                            <input type="hidden" name="friendName" value="${username}">
                                            <button type="submit" class="btn btn-danger">Remove Friend</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${fn:contains(pendingRequests, username)}">
                                        <form action="/friends/cancel" method="post" style="display: inline;">
                                            <input type="hidden" name="friendName" value="${username}">
                                            <button type="submit" class="btn btn-warning">Cancel Request</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${fn:contains(receivedRequests, username)}">
                                        <a href="/messages/inbox" class="btn btn-primary">View Request</a>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="/friends/add" method="post" style="display: inline;">
                                            <input type="hidden" name="friendName" value="${username}">
                                            <button type="submit" class="btn btn-success">Add Friend</button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${not empty noResults}">
                <div class="no-results">
                    <h3>No users found</h3>
                    <p>No user with username "<c:out value="${query}" escapeXml="true"/>" was found.</p>
                </div>
            </c:if>
        </div>

        <div class="sections">
            <div class="section">
                <h4>Current Friends (${fn:length(currentFriends)})</h4>
                <div class="friend-list">
                    <c:choose>
                        <c:when test="${not empty currentFriends}">
                            <c:forEach items="${currentFriends}" var="friend">
                                <div class="friend-item">
                                    <span class="friend-name"><c:out value="${friend}" escapeXml="true"/></span>
                                    <form action="/friends/remove" method="post" style="display: inline;"
                                          onsubmit="return confirm('Are you sure you want to remove ${friend} from your friends?')">
                                        <input type="hidden" name="friendName" value="${friend}">
                                        <button type="submit" class="btn btn-danger">Remove</button>
                                    </form>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">No friends yet. Start by searching for users above!</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="section">
                <h4>Pending Requests (${fn:length(pendingRequests)})</h4>
                <div class="friend-list">
                    <c:choose>
                        <c:when test="${not empty pendingRequests}">
                            <c:forEach items="${pendingRequests}" var="pendingUser">
                                <div class="friend-item">
                                    <span class="friend-name"><c:out value="${pendingUser}" escapeXml="true"/></span>
                                    <form action="/friends/cancel" method="post" style="display: inline;">
                                        <input type="hidden" name="friendName" value="${pendingUser}">
                                        <button type="submit" class="btn btn-warning">Cancel</button>
                                    </form>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">No pending friend requests</div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>