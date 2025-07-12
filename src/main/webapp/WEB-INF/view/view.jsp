<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MessagesStyle.css">
    <title>Messages - View Message</title>
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
                <a href="/messages/sent" class="nav-item">
                    📤 Sent Messages
                </a>
            </nav>
        </div>

        <div class="messages-content">
            <div class="message-view">
                <div class="message-header-view">
                    <div class="message-navigation">
                        <a href="/messages/inbox" class="btn btn-secondary">← Back to Inbox</a>
                        <button onclick="deleteMessage(${message.messageId})" class="btn btn-danger">🗑️ Delete</button>
                    </div>

                    <div class="message-type-indicator">
                        <c:choose>
                            <c:when test="${message.messageType == 'FRIEND_REQUEST'}">
                                <span class="type-badge friend-request">🤝 Friend Request</span>
                            </c:when>
                            <c:when test="${message.messageType == 'CHALLENGE'}">
                                <span class="type-badge challenge">⚔️ Quiz Challenge</span>
                            </c:when>
                            <c:otherwise>
                                <span class="type-badge note">💬 Message</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="message-details">
                    <h2 class="message-subject">${message.subject}</h2>

                    <div class="message-meta">
                        <div class="meta-item">
                            <strong>From:</strong> ${message.senderName}
                        </div>
                        <div class="meta-item">
                            <strong>To:</strong> ${message.recipientName}
                        </div>
                        <div class="meta-item">
                            <strong>Date:</strong> <fmt:formatDate value="${message.createdAt}" pattern="MMMM dd, yyyy 'at' hh:mm a"/>
                        </div>
                    </div>
                </div>

                <div class="message-body">
                    <p>${message.messageText}</p>
                </div>

                <!-- Friend Request Actions -->
                <c:if test="${message.messageType == 'FRIEND_REQUEST' && message.recipientName == userName}">
                    <div class="message-actions-panel" id="friendRequestActions">
                        <h3>Friend Request Actions</h3>
                        <p>Do you want to accept <strong>${message.senderName}</strong> as a friend?</p>
                        <div class="action-buttons">
                            <button onclick="handleFriendRequest('accept')" class="btn btn-success">
                                ✅ Accept Friend Request
                            </button>
                            <button onclick="handleFriendRequest('decline')" class="btn btn-danger">
                                ❌ Decline Request
                            </button>
                        </div>
                    </div>
                </c:if>

                <!-- Challenge Actions -->
                <c:if test="${message.messageType == 'CHALLENGE' && message.recipientName == userName}">
                    <div class="message-actions-panel challenge-panel">
                        <h3>Quiz Challenge</h3>
                        <div class="challenge-details">
                            <c:if test="${not empty quiz}">
                                <div class="quiz-info">
                                    <h4>${quiz.quizName}</h4>
                                    <p>${quiz.description}</p>
                                    <div class="quiz-meta">
                                        <span><strong>Questions:</strong> ${quiz.NQuestions}</span>
                                        <c:if test="${quiz.practiceMode}">
                                            <span><strong>Practice Mode:</strong> Available</span>
                                        </c:if>
                                    </div>
                                </div>
                            </c:if>

                            <div class="challenger-score">
                                <h4>Challenge Score to Beat:</h4>
                                <div class="score-display">
                                    <span class="score">${message.formattedChallengerScore}</span>
                                    <span class="percentage">(<fmt:formatNumber value="${message.challengerPercentage}" maxFractionDigits="1"/>%)</span>
                                </div>
                            </div>
                        </div>

                        <div class="challenge-actions">
                            <c:if test="${not empty quiz}">
                                <a href="/quiz/${quiz.quizID}/take" class="btn btn-primary btn-large">
                                    🎯 Accept Challenge - Take Quiz
                                </a>
                                <a href="/quiz/${quiz.quizID}" class="btn btn-secondary">
                                    📋 View Quiz Details
                                </a>
                                <c:if test="${quiz.practiceMode}">
                                    <a href="/quiz/${quiz.quizID}/take?practiceMode=true" class="btn btn-info">
                                        🏃 Practice Mode First
                                    </a>
                                </c:if>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <!-- Reply Action -->
                <c:if test="${message.messageType == 'NOTE' && message.recipientName == userName}">
                    <div class="message-actions-panel">
                        <a href="/messages/compose?to=${message.senderName}&subject=Re: ${message.subject}" class="btn btn-primary">
                            ↩️ Reply to ${message.senderName}
                        </a>
                    </div>
                </c:if>

                <!-- Response Status -->
                <div id="responseMessage" class="response-message" style="display: none;"></div>
            </div>
        </div>
    </main>
</div>

<script>
    function handleFriendRequest(action) {
        const buttons = document.querySelectorAll('#friendRequestActions button');
        buttons.forEach(btn => btn.disabled = true);

        fetch('/messages/${message.messageId}/friend-request', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=' + action
        })
            .then(response => response.json())
            .then(data => {
                const responseDiv = document.getElementById('responseMessage');
                responseDiv.style.display = 'block';

                if (data.status === 'success') {
                    responseDiv.className = 'response-message success';
                    responseDiv.innerHTML = '<strong>Success!</strong> ' + data.message;

                    // Hide the friend request actions
                    document.getElementById('friendRequestActions').style.display = 'none';
                } else {
                    responseDiv.className = 'response-message error';
                    responseDiv.innerHTML = '<strong>Error!</strong> ' + data.message;

                    // Re-enable buttons on error
                    buttons.forEach(btn => btn.disabled = false);
                }
            })
            .catch(error => {
                const responseDiv = document.getElementById('responseMessage');
                responseDiv.style.display = 'block';
                responseDiv.className = 'response-message error';
                responseDiv.innerHTML = '<strong>Error!</strong> Failed to process friend request.';

                // Re-enable buttons on error
                buttons.forEach(btn => btn.disabled = false);
            });
    }

    function deleteMessage(messageId) {
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
                        window.location.href = '/messages/inbox';
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