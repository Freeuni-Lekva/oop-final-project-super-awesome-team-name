<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages - Compose</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4b0082 0%, #663399 25%, #2f1b69 50%, #1a1a2e 75%, #000000 100%);
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
            background: #8a2be2;
            color: #ffffff;
            box-shadow: 0 5px 15px rgba(138, 43, 226, 0.4);
            width: 100%;
        }

        .btn-primary:hover {
            background: #7a24d1;
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(138, 43, 226, 0.6);
        }

        .btn-secondary {
            background: rgba(108, 117, 125, 0.1);
            color: #495057;
            border: 1px solid rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            background: rgba(108, 117, 125, 0.2);
            transform: translateY(-2px);
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
            border-color: #8a2be2;
            box-shadow: 0 3px 10px rgba(138, 43, 226, 0.2);
        };
        justify-content: space-between;
        align-items: center;
        }

        .nav-item:hover {
            background: rgba(138, 43, 226, 0.1);
            transform: translateX(5px);
        }

        .nav-item.active {
            background: rgba(138, 43, 226, 0.2);
            border-color: rgba(138, 43, 226, 0.5);
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

        /* Form Styles */
        .compose-form {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.row {
            flex-direction: row;
            gap: 20px;
            align-items: end;
        }

        .form-group.row .form-group {
            flex: 1;
        }

        label {
            font-weight: 600;
            color: #495057;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        input[type="text"],
        select,
        textarea {
            padding: 15px 20px;
            border: 1px solid #ced4da;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.9);
            color: #495057;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #8a2be2;
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 0 20px rgba(138, 43, 226, 0.1);
        }

        input[type="text"]::placeholder,
        textarea::placeholder {
            color: rgba(73, 80, 87, 0.5);
        }

        textarea {
            min-height: 150px;
            resize: vertical;
            font-family: inherit;
        }

        select {
            cursor: pointer;
        }

        select option {
            background: #ffffff;
            color: #495057;
        }

        /* Recipient Section */
        .recipient-section {
            background: rgba(255, 255, 255, 0.8);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid #e9ecef;
        }

        .recipient-input-group {
            display: flex;
            gap: 15px;
            align-items: end;
        }

        .recipient-input-group input {
            flex: 1;
        }

        .quick-select-btn {
            background: rgba(138, 43, 226, 0.1);
            color: #8a2be2;
            border: 1px solid rgba(138, 43, 226, 0.3);
            padding: 15px 20px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            white-space: nowrap;
        }

        .quick-select-btn:hover {
            background: rgba(138, 43, 226, 0.2);
            transform: translateY(-2px);
        }

        /* Friends List */
        .friends-dropdown {
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid #e9ecef;
            border-radius: 12px;
            margin-top: 10px;
            max-height: 150px;
            overflow-y: auto;
            display: none;
        }

        .friends-dropdown.show {
            display: block;
        }

        .friend-option {
            padding: 12px 15px;
            cursor: pointer;
            transition: background 0.2s ease;
            border-bottom: 1px solid #e9ecef;
            color: #495057;
        }

        .friend-option:hover {
            background: rgba(138, 43, 226, 0.1);
        }

        .friend-option:last-child {
            border-bottom: none;
        }


        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        @media (max-width: 600px) {
            .form-actions {
                flex-direction: column;
            }

            .recipient-input-group {
                flex-direction: column;
                align-items: stretch;
            }
        }


        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .compose-form {
            animation: slideInUp 0.6s ease forwards;
        }


        .character-counter {
            font-size: 12px;
            color: #6c757d;
            text-align: right;
            margin-top: 5px;
        }

        .character-counter.warning {
            color: #ffc107;
        }

        .character-counter.danger {
            color: #dc3545;
        }
    </style>
</head>
<body>
<div class="container">
    <header class="messages-header">
        <div class="header-content">
            <h1>Messages</h1>
            <nav class="main-nav">
                <a href="/home" class="nav-link">Home</a>
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
                    Compose Message
                </a>
            </div>

            <nav class="messages-nav">
                <a href="/messages/inbox" class="nav-item">
                    Inbox
                </a>
                <a href="/messages/sent" class="nav-item">
                    Sent Messages
                </a>
            </nav>
        </div>

        <div class="messages-content">
            <div class="content-header">
                <h2>Compose Message</h2>
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

            <form action="/messages/send" method="post" class="compose-form">
                <div class="recipient-section">
                    <div class="form-group">
                        <label for="recipientName">To</label>
                        <div class="recipient-input-group">
                            <input type="text"
                                   id="recipientName"
                                   name="recipientName"
                                   value="${recipientName}"
                                   placeholder="Enter username..."
                                   required
                                   autocomplete="off">
                            <button type="button" class="quick-select-btn" onclick="toggleFriendsDropdown()">
                                Choose from Friends
                            </button>
                        </div>
                        <div id="friendsDropdown" class="friends-dropdown">
                            <c:choose>
                                <c:when test="${not empty friends}">
                                    <c:forEach items="${friends}" var="friend">
                                        <div class="friend-option" onclick="selectFriend('${friend.friendName}')">
                                                ${friend.friendName}
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div class="friend-option" style="opacity: 0.6; cursor: default;">
                                        No friends found. Add some friends first!
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="subject">Subject</label>
                    <input type="text"
                           id="subject"
                           name="subject"
                           value="${subject}"
                           placeholder="Enter message subject..."
                           required
                           maxlength="100">
                    <div class="character-counter" id="subjectCounter">0 / 100</div>
                </div>

                <div class="form-group">
                    <label for="messageText">Message</label>
                    <textarea id="messageText"
                              name="messageText"
                              placeholder="Write your message here..."
                              required
                              maxlength="1000">${messageText}</textarea>
                    <div class="character-counter" id="messageCounter">0 / 1000</div>
                </div>

                <div class="form-actions">
                    <a href="/messages/inbox" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Send Message</button>
                </div>
            </form>
        </div>
    </main>
</div>

<script>

    function updateCharacterCounter(inputId, counterId, maxLength) {
        const input = document.getElementById(inputId);
        const counter = document.getElementById(counterId);

        function updateCounter() {
            const currentLength = input.value.length;
            counter.textContent = currentLength + ' / ' + maxLength;


            counter.classList.remove('warning', 'danger');
            if (currentLength > maxLength * 0.9) {
                counter.classList.add('danger');
            } else if (currentLength > maxLength * 0.7) {
                counter.classList.add('warning');
            }
        }

        input.addEventListener('input', updateCounter);
        updateCounter();
    }


    function toggleFriendsDropdown() {
        const dropdown = document.getElementById('friendsDropdown');
        dropdown.classList.toggle('show');
    }

    function selectFriend(friendName) {
        document.getElementById('recipientName').value = friendName;
        document.getElementById('friendsDropdown').classList.remove('show');
    }


    document.addEventListener('click', function(event) {
        const dropdown = document.getElementById('friendsDropdown');
        const button = document.querySelector('.quick-select-btn');

        if (!dropdown.contains(event.target) && !button.contains(event.target)) {
            dropdown.classList.remove('show');
        }
    });


    function validateForm() {
        const recipientName = document.getElementById('recipientName').value.trim();
        const subject = document.getElementById('subject').value.trim();
        const messageText = document.getElementById('messageText').value.trim();

        if (!recipientName) {
            alert('Please enter a recipient name.');
            return false;
        }

        if (!subject) {
            alert('Please enter a subject.');
            return false;
        }

        if (!messageText) {
            alert('Please enter a message.');
            return false;
        }

        return true;
    }


    document.addEventListener('DOMContentLoaded', function() {
        updateCharacterCounter('subject', 'subjectCounter', 100);
        updateCharacterCounter('messageText', 'messageCounter', 1000);


        document.querySelector('.compose-form').addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
            }
        });
    });

    
    document.getElementById('messageText').addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = Math.max(150, this.scrollHeight) + 'px';
    });
</script>
</body>
</html>