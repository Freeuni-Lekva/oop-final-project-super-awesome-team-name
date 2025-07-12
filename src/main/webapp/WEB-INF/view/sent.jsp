<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MessagesStyle.css">
    <title>Messages - Sent</title>
</head>
<body>
<div class="container">
    <header class="messages-header">
        <div class="header-content">
            <h1>📬 Messages</h1>
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
                    ✏️ Compose Message
                </a>
            </div>

            <nav class="messages-nav">
                <a href="/messages/inbox" class="nav-item">
                    📥 Inbox
                </a>
                <a href="/messages/sent" class="nav-item active">
                    📤 Sent Messages
                </a>
            </nav>
        </div>

        <div class="messages-content">
            <div class="content-header">
                <h2>Sent Messages</h2>
                <div class="message-stats">
                    <span class="total-count">${fn:length(messages)} messages</span>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <strong>Success:</strong> ${success}
                </div>
            </c:if>

            <div class="messages-list">
                <c:choose>
                    <c:when test="${not empty messages}">
                        <c:forEach items="${messages}" var="message">
                            <div class="message-item sent" onclick="viewMessage(${message.messageId})">
                                <div class="message-type-icon">
                                    <c:choose>
                                        <c:when test="${message.messageType == 'FRIEND_REQUEST'}">🤝</c:when>
                                        <c:when test="${message.messageType == 'CHALLENGE'}">⚔️</c:when>
                                        <c:otherwise>💬</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="message-content">
                                    <div class="message-header">
                                        <span class="recipient-name">To: ${message.recipientName}</span>
                                        <span class="message-date">
                                            <fmt:formatDate value="${message.createdAt}" pattern="MMM dd, HH:mm"/>
                                        </span>
                                    </div>

                                    <div class="message-subject">
                                            ${message.subject}
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
                                                ${fn:substring(message.messageText, 0, 100)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${message.messageText}
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="message-actions">
                                    <button onclick="deleteMessage(${message.messageId}, event)" class="btn-delete" title="Delete">
                                        🗑️
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-icon">📤</div>
                            <h3>No sent messages</h3>
                            <p>You haven't sent any messages yet. Compose a message to get started!</p>
                            <a href="/messages/compose" class="btn btn-primary">Compose Message</a>
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