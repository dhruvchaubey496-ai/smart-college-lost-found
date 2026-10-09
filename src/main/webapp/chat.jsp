<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
<%
    Item item = (Item) request.getAttribute("item");
    int partnerId = (Integer) request.getAttribute("partnerId");
    String partnerUsername = (String) request.getAttribute("partnerUsername");
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
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <a href="items?action=view&id=<%= item.getId() %>" class="nav-link">&larr; Back to Item</a>
            <span class="nav-link" style="color: #0284c7; font-weight: 600;">@<%= currentUser.getUsername() %></span>
            <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
        </nav>
    </header>

    <main class="container">
        <div class="chat-container">
            <div class="chat-header">
                <div>
                    <h3>Chat with @<%= partnerUsername %></h3>
                    <span style="font-size: 0.8rem; color: #64748b;">Regarding: <%= item.getTitle() %> (<%= item.getClassroom() %>)</span>
                </div>
                <span style="font-size: 0.8rem; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; font-weight: 600;">Identity Protected</span>
            </div>

            <!-- Messages list -->
            <div id="chatMessages" class="chat-messages">
                <div id="chatLoadingNotice" style="text-align: center; color: #94a3b8; font-size: 0.85rem; padding: 24px;">
                    Connecting to secure room...
                </div>
            </div>

            <!-- Input Bar -->
            <form id="chatForm" class="chat-input-bar">
                <input type="text" id="messageInput" class="form-control" placeholder="Type message to verify details (e.g. colour, brand, unique mark)..." required autocomplete="off">
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
        const itemId = <%= item.getId() %>;
        const partnerId = <%= partnerId %>;
        const currentUserId = <%= currentUser.getId() %>;
        const chatMessages = document.getElementById("chatMessages");
        const chatForm = document.getElementById("chatForm");
        const messageInput = document.getElementById("messageInput");
        const sendBtn = document.getElementById("sendBtn");

        async function fetchMessages() {
            try {
                const res = await fetch(`chat?itemId=${itemId}&partnerId=${partnerId}&format=json`);
                if (res.ok) {
                    const data = await res.json();
                    renderMessages(data);
                }
            } catch (err) {
                console.error("Chat polling error:", err);
            }
        }

        function renderMessages(messages) {
            if (!messages || messages.length === 0) {
                chatMessages.innerHTML = `
                    <div style="text-align: center; color: #64748b; font-size: 0.9rem; padding: 30px;">
                        No messages yet in this thread.<br>
                        <span style="font-size: 0.82rem; color: #94a3b8;">Send a message below to start identity-safe coordination!</span>
                    </div>
                `;
                return;
            }

            const isNearBottom = chatMessages.scrollHeight - chatMessages.scrollTop <= chatMessages.clientHeight + 60;
            chatMessages.innerHTML = "";

            messages.forEach(msg => {
                const isMe = msg.senderId === currentUserId;
                const bubble = document.createElement("div");
                bubble.className = "chat-bubble " + (isMe ? "chat-bubble-me" : "chat-bubble-partner");
                bubble.innerHTML = `
                    <div class="chat-sender-name">${isMe ? "You" : "@" + msg.senderUsername}</div>
                    <div>${escapeHtml(msg.content)}</div>
                    <div style="font-size: 0.68rem; opacity: 0.75; text-align: right; margin-top: 3px;">
                        ${msg.sentAt ? msg.sentAt.substring(11, 16) : ""}
                    </div>
                `;
                chatMessages.appendChild(bubble);
            });

            if (isNearBottom) {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }
        }

        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        chatForm.addEventListener("submit", async (e) => {
            e.preventDefault();
            const text = messageInput.value.trim();
            if (!text) return;

            sendBtn.disabled = true;
            try {
                const formData = new URLSearchParams();
                formData.append("itemId", itemId);
                formData.append("partnerId", partnerId);
                formData.append("message", text);

                messageInput.value = "";
                const response = await fetch("chat", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData.toString()
                });

                if (response.ok) {
                    await fetchMessages();
                } else {
                    alert("Could not deliver message. Please check connection.");
                }
            } catch (err) {
                console.error("Error sending message:", err);
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
