<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/MessagesStyle.css">
    <title>Messages - Compose</title>
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
                <a href="/messages/compose" class="btn btn-primary active">
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
            <div class="content-header">
                <h2>✏️ Compose Message</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>

            <div class="compose-form">
                <form action="/messages/send" method="post" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label for="recipientName">To:</label>
                        <input type="text"
                               id="recipientName"
                               name="recipientName"
                               value="${recipientName}"
                               placeholder="Enter username..."
                               required>
                        <small class="form-help">Enter the username of the person you want to message</small>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject:</label>
                        <input type="text"
                               id="subject"
                               name="subject"
                               value="${subject}"
                               placeholder="Enter message subject..."
                               required>
                    </div>

                    <div class="form-group">
                        <label for="messageText">Message:</label>
                        <textarea id="messageText"
                                  name="messageText"
                                  rows="8"
                                  placeholder="Type your message here..."
                                  required>${messageText}</textarea>
                        <div class="character-counter">
                            <span id="charCount">0</span> / 1000 characters
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            📤 Send Message
                        </button>
                        <a href="/messages/inbox" class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>

            <div class="compose-tips">
                <h3>💡 Messaging Tips</h3>
                <ul>
                    <li><strong>Be respectful:</strong> Keep your messages friendly and appropriate</li>
                    <li><strong>Be clear:</strong> Use descriptive subjects to help organize conversations</li>
                    <li><strong>Stay safe:</strong> Don't share personal information like passwords or addresses</li>
                    <li><strong>Challenge friends:</strong> You can challenge friends to beat your quiz scores from the quiz details page</li>
                </ul>
            </div>
        </div>
    </main>
</div>

<script>
    function validateForm() {
        const recipient = document.getElementById('recipientName').value.trim();
        const subject = document.getElementById('subject').value.trim();
        const message = document.getElementById('messageText').value.trim();

        if (!recipient) {
            alert('Please enter a recipient username.');
            return false;
        }

        if (!subject) {
            alert('Please enter a subject.');
            return false;
        }

        if (!message) {
            alert('Please enter a message.');
            return false;
        }

        if (message.length > 1000) {
            alert('Message is too long. Please keep it under 1000 characters.');
            return false;
        }

        return true;
    }

    // Character counter
    document.addEventListener('DOMContentLoaded', function() {
        const messageText = document.getElementById('messageText');
        const charCount = document.getElementById('charCount');

        function updateCharCount() {
            const count = messageText.value.length;
            charCount.textContent = count;

            if (count > 1000) {
                charCount.style.color = '#dc3545';
            } else if (count > 800) {
                charCount.style.color = '#ffc107';
            } else {
                charCount.style.color = '#28a745';
            }
        }

        messageText.addEventListener('input', updateCharCount);
        updateCharCount(); // Initial count
    });

    // Auto-resize textarea
    document.getElementById('messageText').addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = this.scrollHeight + 'px';
    });
</script>
</body>
</html>