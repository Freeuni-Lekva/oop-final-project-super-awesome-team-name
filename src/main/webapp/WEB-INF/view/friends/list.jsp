<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Friends</title>
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
            max-width: 1400px;
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
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        .nav-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .nav-link {
            color: #333333;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 25px;
            background: rgba(102, 126, 234, 0.1);
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link:hover {
            background: rgba(102, 126, 234, 0.2);
            transform: translateY(-2px);
        }

        .stats-bar {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
        }

        .stat-item {
            text-align: center;
            color: #333333;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 30px;
        }

        @media (max-width: 1200px) {
            .main-content {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
        }

        .section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 25px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }

        .section h3 {
            color: #333333;
            margin-bottom: 20px;
            font-size: 1.4rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-icon {
            width: 30px;
            height: 30px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
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

        .friend-item, .request-item {
            background: rgba(102, 126, 234, 0.05);
            border: 1px solid rgba(102, 126, 234, 0.1);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .friend-item:hover, .request-item:hover {
            border-color: rgba(102, 126, 234, 0.3);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .friend-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: #333333;
        }

        .friend-since {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            font-size: 0.9rem;
        }

        .btn-danger {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(220, 53, 69, 0.4);
        }

        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(40, 167, 69, 0.4);
        }

        .btn-warning {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(255, 193, 7, 0.4);
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 12px 24px;
            font-size: 1rem;
            margin-bottom: 20px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #6c757d;
        }

        .empty-state h4 {
            margin-bottom: 10px;
            color: #495057;
        }

        .empty-state p {
            margin-bottom: 20px;
            line-height: 1.5;
        }

        .request-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 10px;
        }

        .request-actions {
            display: flex;
            gap: 10px;
        }

        .request-date {
            font-size: 0.85rem;
            color: #6c757d;
        }

        .status-badge {
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-pending {
            background: rgba(255, 193, 7, 0.1);
            color: #856404;
        }

        .quick-actions {
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>My Friends</h1>
        <div class="nav-links">
            <a href="/" class="nav-link">Home</a>
            <a href="/friends/search" class="nav-link">Find Friends</a>
            <a href="/messages/inbox" class="nav-link">Messages</a>
            <a href="/quiz" class="nav-link">Browse Quizzes</a>
            <a href="/logout" class="nav-link">Logout</a>
        </div>
    </div>

    <div class="stats-bar">
        <div class="stat-item">
            <span class="stat-number">${fn:length(friends)}</span>
            <span class="stat-label">Friends</span>
        </div>
        <div class="stat-item">
            <span class="stat-number">${fn:length(sentRequests)}</span>
            <span class="stat-label">Sent Requests</span>
        </div>
        <div class="stat-item">
            <span class="stat-number">${fn:length(receivedRequests)}</span>
            <span class="stat-label">Received Requests</span>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">
            <strong>Success!</strong> <c:out value="${param.success}" escapeXml="true"/>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-error">
            <strong>Error:</strong> <c:out value="${param.error}" escapeXml="true"/>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">
            <strong>Error:</strong> <c:out value="${error}" escapeXml="true"/>
        </div>
    </c:if>

    <div class="main-content">
        <!-- My Friends Section -->
        <div class="section">
            <h3>
                <div class="section-icon">F</div>
                My Friends
            </h3>

            <div class="quick-actions">
                <a href="/friends/search" class="btn btn-primary">Find New Friends</a>
            </div>

            <c:choose>
                <c:when test="${not empty friends}">
                    <c:forEach items="${friends}" var="friendship">
                        <div class="friend-item">
                            <div class="item-header">
                                <div class="friend-name">
                                    <c:out value="${friendship.friendName}" escapeXml="true"/>
                                </div>
                                <form action="/friends/remove" method="post" style="display: inline;"
                                      onsubmit="return confirm('Are you sure you want to remove ${friendship.friendName} from your friends?')">
                                    <input type="hidden" name="friendName" value="${friendship.friendName}">
                                    <button type="submit" class="btn btn-danger">Remove</button>
                                </form>
                            </div>
                            <div class="friend-since">
                                Friends since: <fmt:formatDate value="${friendship.since}" pattern="MMM dd, yyyy"/>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h4>No friends yet</h4>
                        <p>Start building your network by searching for users and sending friend requests!</p>
                        <a href="/friends/search" class="btn btn-primary">Find Friends</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Received Friend Requests Section -->
        <div class="section">
            <h3>
                <div class="section-icon">R</div>
                Friend Requests
            </h3>

            <c:choose>
                <c:when test="${not empty receivedRequests}">
                    <c:forEach items="${receivedRequests}" var="request">
                        <div class="request-item">
                            <div class="item-header">
                                <div class="friend-name">
                                    <c:out value="${request.requesterName}" escapeXml="true"/>
                                </div>
                                <span class="status-badge status-pending">Pending</span>
                            </div>
                            <div class="request-date">
                                Received: <fmt:formatDate value="${request.createdAt}" pattern="MMM dd, yyyy"/>
                            </div>
                            <div class="request-details">
                                <span style="font-size: 0.9rem; color: #6c757d;">
                                    Check your messages to accept or decline
                                </span>
                                <a href="/messages/inbox" class="btn btn-primary">View Messages</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h4>No pending requests</h4>
                        <p>When someone sends you a friend request, it will appear here.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Sent Friend Requests Section -->
        <div class="section">
            <h3>
                <div class="section-icon">S</div>
                Sent Requests
            </h3>

            <c:choose>
                <c:when test="${not empty sentRequests}">
                    <c:forEach items="${sentRequests}" var="request">
                        <div class="request-item">
                            <div class="item-header">
                                <div class="friend-name">
                                    <c:out value="${request.requesteeName}" escapeXml="true"/>
                                </div>
                                <span class="status-badge status-pending">Pending</span>
                            </div>
                            <div class="request-date">
                                Sent: <fmt:formatDate value="${request.createdAt}" pattern="MMM dd, yyyy"/>
                            </div>
                            <div class="request-details">
                                <span style="font-size: 0.9rem; color: #6c757d;">
                                    Waiting for response
                                </span>
                                <form action="/friends/cancel" method="post" style="display: inline;">
                                    <input type="hidden" name="friendName" value="${request.requesteeName}">
                                    <button type="submit" class="btn btn-warning">Cancel</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h4>No sent requests</h4>
                        <p>Friend requests you send will appear here until they're accepted or declined.</p>
                        <a href="/friends/search" class="btn btn-primary">Send a Request</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>