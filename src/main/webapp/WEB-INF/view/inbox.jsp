<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - Inbox</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #000000 0%, #2d1b2e 25%, #5d2e5d 50%, #8b3a62 75%, #c6426e 100%);
            min-height: 100vh;
            color: #ffffff;
            overflow-x: hidden;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            min-height: 100vh;
        }

        /* Header Styles */
        .messages-header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 20px 30px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header-content h1 {
            font-size: 2.5rem;
            color: #333333;
            text-shadow: none;
        }

        .main-nav {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .nav-link {
            color: #333333;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 25px;
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .nav-link:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .logout-link {
            background: rgba(220, 53, 69, 0.1);
            border-color: rgba(220, 53, 69, 0.3);
            color: #dc3545;
        }

        .logout-link:hover {
            background: rgba(220, 53, 69, 0.2);
            box-shadow: 0 5px 15px rgba(220, 53, 69, 0.2);
        }

        /* Main Content Layout */
        .main-content {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
            align-items: start;
        }

        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
        }

        /* Sidebar Styles */
        .messages-sidebar {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 25px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .message-actions {
            margin-bottom: 25px;
        }

        .btn {
            display: inline-block;
            padding: 15px 25px;
            border-radius: 15px;
            text-decoration: none;
            font-weight: 600;
            text-align: center;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-primary {
            background: linear-gradient(45deg, #8b3a62, #c6426e);
            color: #ffffff;
            box-shadow: 0 5px 15px rgba(139, 58, 98, 0.5);
            width: 100%;
        }

        .btn-primary:hover {
            background: linear-gradient(45deg, #7a2d4f, #b83a5e);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 58, 98, 0.7);
        }

        .messages-nav {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .nav-item {
            color: #333333;
            text-decoration: none;
            padding: 15px 20px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.3);
            transition: all 0.3s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-item:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateX(5px);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }

        .nav-item.active {
            background: rgba(255, 255, 255, 1);
            border-color: #8b3a62;
            box-shadow: 0 3px 10px rgba(139, 58, 98, 0.4);
        }

        .unread-badge {
            background: #dc3545;
            color: white;
            padding: 4px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }

        /* Messages Content */
        .messages-content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e9ecef;
        }

        .content-header h2 {
            font-size: 2rem;
            color: #333333;
        }

        .message-stats {
            display: flex;
            gap: 20px;
            font-size: 14px;
        }

        .total-count {
            color: #c6426e;
        }

        .unread-count {
            color: #dc3545;
            font-weight: bold;
        }

        /* Alert Styles */
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            border: 1px solid;
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.1);
            border-color: rgba(220, 53, 69, 0.3);
            color: #ff6b7d;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            border-color: rgba(40, 167, 69, 0.3);
            color: #4ecdc4;
        }

        /* Messages List */
        .messages-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .message-item {
            background: rgba(255, 255, 255, 0.9);
            border: 1px solid #e9ecef;
            border-radius: 15px;
            padding: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }

        .message-item:hover {
            background: rgba(255, 255, 255, 1);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .message-item.unread {
            border-color: #8b3a62;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 3px 10px rgba(139, 58, 98, 0.3);
        }

        .message-type-icon {
            font-size: 12px;
            min-width: 60px;
            text-align: center;
            margin-top: 5px;
            color: #c6426e;
            font-weight: bold;
            text-transform: uppercase;
        }

        .message-content {
            flex: 1;
            min-width: 0;
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .sender-name {
            font-weight: 600;
            color: #333333;
            font-size: 16px;
        }

        .message-date {
            color: #6c757d;
            font-size: 12px;
        }

        .message-subject {
            font-weight: 500;
            margin-bottom: 8px;
            color: #333333;
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .message-type-badge {
            padding: 4px 8px;
            border-radius: 8px;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .friend-request {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }

        .challenge {
            background: rgba(255, 193, 7, 0.1);
            color: #ffc107;
        }

        .message-preview {
            color: #6c757d;
            font-size: 14px;
            line-height: 1.4;
        }

        .message-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .unread-indicator {
            color: #dc3545;
            font-size: 20px;
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.3);
            color: #dc3545;
            padding: 8px 12px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 12px;
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.2);
            transform: scale(1.1);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-icon {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.7;
            color: #c6426e;
        }

        .empty-icon::before {
            content: "";
            display: none;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #333333;
        }

        .empty-state p {
            color: #6c757d;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .empty-state .btn-primary {
            background: linear-gradient(45deg, #8b3a62, #c6426e);
            color: #ffffff;
            max-width: 250px;
            margin: 0 auto;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message-item {
            animation: fadeInUp 0.5s ease forwards;
        }

        .message-item:nth-child(1) { animation-delay: 0.1s; }
        .message-item:nth-child(2) { animation-delay: 0.2s; }
        .message-item:nth-child(3) { animation-delay: 0.3s; }
        .message-item:nth-child(4) { animation-delay: 0.4s; }
        .message-item:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body>
<div class="container">
    <header class="messages-header">
        <div class="header-content">
            <h1>Messages</h1>
            <nav class="main-nav">
                <a href="/" class="nav-link">Home</a>
                <a href="/quiz" class="nav-link">Browse Quizzes</a>
                <a href="/history" class="nav-link">My History</a>
                <a href="/profile" class="nav-link">Profile</a>
                <a href="/logout" class="nav-link logout-link">Logout</a>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <div class="messages-sidebar">
            <div class="message-actions">
                <a href="/messages/compose" class="btn btn-primary">
                    Compose Message
                </a>
            </div>

            <nav class="messages-nav">
                <a href="/messages/inbox" class="nav-item active">
                    Inbox
                    <c:if test="${not empty unreadCount and unreadCount > 0}">
                        <span class="unread-badge"><c:out value="${unreadCount}"/></span>
                    </c:if>
                </a>
                <a href="/messages/sent" class="nav-item">
                    Sent Messages
                </a>
            </nav>
        </div>

        <div class="messages-content">
            <div class="content-header">
                <h2>Inbox</h2>
                <div class="message-stats">
                    <c:choose>
                        <c:when test="${not empty messages}">
                            <span class="total-count">
                                <c:set var="messageCount" value="${fn:length(messages)}"/>
                                <c:out value="${messageCount}"/> messages
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="total-count">0 messages</span>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${not empty unreadCount and unreadCount > 0}">
                        <span class="unread-count">
                            <c:out value="${unreadCount}"/> unread
                        </span>
                    </c:if>
                </div>
            </div>


            <c:if test="${not empty param.error}">
                <div class="alert alert-error">
                    <strong>Error:</strong> <c:out value="${param.error}" escapeXml="true"/>
                </div>
            </c:if>

            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <strong>Success:</strong> <c:out value="${param.success}" escapeXml="true"/>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <strong>Error:</strong> <c:out value="${error}" escapeXml="true"/>
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>Success:</strong> <c:out value="${success}" escapeXml="true"/>
                </div>
            </c:if>

            <div class="messages-list">
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach items="${messages}" var="message">
                            <div class="message-item ${message.read ? '' : 'unread'}" onclick="viewMessage(${message.messageId})">
                                <div class="message-type-icon">
                                    <c:choose>
                                        <c:when test="${message.messageType == 'FRIEND_REQUEST'}">Friend</c:when>
                                        <c:when test="${message.messageType == 'CHALLENGE'}">Challenge</c:when>
                                        <c:otherwise>Message</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="message-content">
                                    <div class="message-header">
                                        <span class="sender-name"><c:out value="${message.senderName}" escapeXml="true"/></span>
                                        <span class="message-date">
                                            <fmt:formatDate value="${message.createdAt}" pattern="MMM dd, HH:mm"/>
                                        </span>
                                    </div>

                                    <div class="message-subject">
                                        <c:out value="${message.subject}" escapeXml="true"/>
                                        <c:if test="${message.messageType == 'FRIEND_REQUEST'}">
                                            <span class="message-type-badge friend-request">Friend Request</span>
                                        </c:if>
                                        <c:if test="${message.messageType == 'CHALLENGE'}">
                                            <span class="message-type-badge challenge">Challenge</span>
                                        </c:if>
                                    </div>

                                    <div class="message-preview">
                                        <c:choose>
                                            <c:when test="${fn:length(message.messageText) > 100}">
                                                <c:out value="${fn:substring(message.messageText, 0, 100)}" escapeXml="true"/>...
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${message.messageText}" escapeXml="true"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="message-actions">
                                    <c:if test="${not message.read}">
                                        <span class="unread-indicator">●</span>
                                    </c:if>
                                    <button onclick="deleteMessage(${message.messageId}, event)" class="btn-delete" title="Delete">
                                        Delete
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon"></div>
                            <h3>No messages yet</h3>
                            <p>Your inbox is empty. When someone sends you a message, it will appear here.</p>
                            <a href="/messages/compose" class="btn btn-primary">Send your first message</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<script>
    function viewMessage(messageId) {
        window.location.href = '/messages/' + messageId;
    }

    function deleteMessage(messageId, event) {
        event.stopPropagation();

        if (confirm('Are you sure you want to delete this message?')) {
            fetch('/messages/' + messageId + '/delete', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'success') {
                        location.reload();
                    } else {
                        alert('Error: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error deleting message');
                });
        }
    }
</script>
</body>
</html>