<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
<%
    Item item = (Item) request.getAttribute("item");
    Object partnerIdObj = request.getAttribute("partnerId");
    int partnerId = (partnerIdObj != null) ? (Integer) partnerIdObj : 0;
    String partnerUsername = (String) request.getAttribute("partnerUsername");
    if (partnerUsername == null) partnerUsername = "Student";
    User currentUser = (User) session.getAttribute("user");
    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat with @<%= partnerUsername %> - Campus Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .guidelines-box {
            background-color: #f0fdf4;
            border-left: 4px solid #16a34a;
            border-bottom: 1px solid #bbf7d0;
            padding: 12px 16px;
            font-size: 0.86rem;
            color: #14532d;
        }
        .guideline-title {
            font-weight: 700;
            color: #166534;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
    </style>
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <% if (item != null) { %>
                <a href="items?action=view&id=<%= item.getId() %>" class="nav-link">&larr; Back to Item</a>
            <% } else { %>
                <a href="items" class="nav-link">&larr; Back to Notice Board</a>
            <% } %>
            <% if (currentUser != null) { %>
                <% if (currentUser.isAdmin()) { %>
                    <a href="admin" class="btn" style="background-color: #fef3c7; color: #b45309; padding: 4px 10px; font-size: 0.8rem;">Dept Admin</a>
                <% } %>
                <span class="nav-link" style="color: #0284c7; font-weight: 600;">@<%= currentUser.getUsername() %></span>
                <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <div class="chat-container" style="height: 600px;">
            <div class="chat-header">
                <div>
                    <h3>Chat with @<%= partnerUsername %></h3>
                    <% if (item != null) { %>
                        <span style="font-size: 0.8rem; color: #64748b;">Regarding: <%= item.getTitle() %> (<%= item.getClassroom() %>)</span>
                    <% } %>
                </div>
                <span style="font-size: 0.8rem; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; font-weight: 600;">Identity Protected</span>
            </div>

            <!-- Verification & Safety Guidelines Box -->
            <div class="guidelines-box">
                <div class="guideline-title">
                    <span>🛡️ Verification &amp; Safety Guidelines (Kaam ki Baat):</span>
                </div>
                <ul style="padding-left: 18px; line-height: 1.4;">
                    <li><strong>Ask for Hidden Proof:</strong> Ask the owner for details not visible in photos (e.g., sticker, unique scratch, last 4 digits of ID, lockscreen wallpaper).</li>
                    <li><strong>Meet in Public Campus Spots:</strong> Coordinate handoff at Library Counter, Security Gate 1, Canteen, or Admin Block.</li>
                    <li><strong>Zero Sensitive Data:</strong> Never share OTPs, UPI PINs, passwords, or personal phone numbers here.</li>
                </ul>
            </div>

            <!-- Messages list -->
            <div id="chatMessages" class="chat-messages">
                <div id="chatLoadingNotice" style="text-align: center; color: #94a3b8; font-size: 0.85rem; padding: 24px;">
                    Connecting to secure room...
                </div>
            </div>

            <!-- Input Bar -->
            <form id="chatForm" class="chat-input-bar">
                <input type="text" id="messageInput" class="form-control" placeholder="Ask questions or verify item details safely..." required autocomplete="off">
                <button type="submit" id="sendBtn" class="btn btn-primary">Send</button>
            </form>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 600; color: #1e293b; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 6px;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <p style="font-size: 0.82rem;">Support: <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

    <script>
        var currentItemId = <%= item != null ? item.getId() : 0 %>;
        var currentPartnerId = <%= partnerId %>;
        var myUserId = <%= currentUser != null ? currentUser.getId() : 0 %>;
        var chatMessages = document.getElementById("chatMessages");
        var chatForm = document.getElementById("chatForm");
        var messageInput = document.getElementById("messageInput");
        var sendBtn = document.getElementById("sendBtn");

        function escapeHtml(text) {
            if (!text) return "";
            var div = document.createElement("div");
            div.textContent = text;
            return div.innerHTML;
        }

        async function fetchMessages() {
            if (!currentItemId) return;
            try {
                var url = "chat?itemId=" + currentItemId + "&partnerId=" + currentPartnerId + "&format=json";
                var res = await fetch(url, { credentials: "same-origin" });
                if (res.ok) {
                    var data = await res.json();
                    renderMessages(data);
                }
            } catch (err) {
                console.error("Chat polling error:", err);
            }
        }

        function renderMessages(messages) {
            if (!messages || messages.length === 0) {
                chatMessages.innerHTML = '<div style="text-align:center;color:#64748b;font-size:0.9rem;padding:30px;">'
                    + 'No messages yet in this thread.<br>'
                    + '<span style="font-size:0.82rem;color:#94a3b8;">Send a message below to start identity-safe verification!</span>'
                    + '</div>';
                return;
            }

            var isNearBottom = chatMessages.scrollHeight - chatMessages.scrollTop <= chatMessages.clientHeight + 60;
            chatMessages.innerHTML = "";

            for (var i = 0; i < messages.length; i++) {
                var msg = messages[i];
                var isMe = (msg.senderId === myUserId);
                var bubble = document.createElement("div");
                bubble.className = "chat-bubble " + (isMe ? "chat-bubble-me" : "chat-bubble-partner");

                var senderLabel = isMe ? "You" : "@" + msg.senderUsername;
                var timeLabel = msg.sentAt && msg.sentAt.length >= 16 ? msg.sentAt.substring(11, 16) : "";

                bubble.innerHTML = '<div class="chat-sender-name">' + escapeHtml(senderLabel) + '</div>'
                                 + '<div>' + escapeHtml(msg.content) + '</div>'
                                 + '<div style="font-size:0.68rem;opacity:0.75;text-align:right;margin-top:3px;">' + timeLabel + '</div>';

                chatMessages.appendChild(bubble);
            }

            if (isNearBottom) {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }
        }

        chatForm.addEventListener("submit", async function(e) {
            e.preventDefault();
            var text = messageInput.value.trim();
            if (!text) return;

            sendBtn.disabled = true;
            try {
                var formData = new URLSearchParams();
                formData.append("itemId", currentItemId);
                formData.append("partnerId", currentPartnerId);
                formData.append("senderId", myUserId);
                formData.append("message", text);

                messageInput.value = "";
                var postUrl = window.location.pathname; // Always points accurately to /chat
                var response = await fetch(postUrl, {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    credentials: "same-origin",
                    body: formData.toString()
                });

                if (response.ok) {
                    await fetchMessages();
                } else {
                    var errorMsg = await response.text();
                    alert("Message error: " + (errorMsg || "Delivery failed."));
                }
            } catch (err) {
                console.error("Error sending message:", err);
                alert("Network communication error: " + err.message);
            } finally {
                sendBtn.disabled = false;
                messageInput.focus();
            }
        });

        fetchMessages();
        setInterval(fetchMessages, 2500);
    </script>
</body>
</html>
