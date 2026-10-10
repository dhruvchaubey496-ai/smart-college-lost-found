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
    <title>Chat with @<%= partnerUsername %> - Findr | by Dhruv Choubey</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        /* Themes styling */
        .theme-blue .chat-bubble-me { background-color: #0284c7; color: #ffffff; }
        .theme-blue .chat-bubble-partner { background-color: #f1f5f9; color: #1e293b; border: 1px solid #e2e8f0; }

        .theme-green .chat-bubble-me { background-color: #15803d; color: #ffffff; }
        .theme-green .chat-bubble-partner { background-color: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
        .theme-green .chat-header { background-color: #f0fdf4; }

        .theme-dark { background-color: #0f172a !important; border-color: #334155 !important; }
        .theme-dark .chat-header { background-color: #1e293b; border-color: #334155; color: #f8fafc; }
        .theme-dark .chat-header h3 { color: #38bdf8; }
        .theme-dark .chat-messages { background-color: #0f172a; }
        .theme-dark .chat-bubble-me { background-color: #0284c7; color: #ffffff; }
        .theme-dark .chat-bubble-partner { background-color: #1e293b; color: #f1f5f9; border: 1px solid #334155; }
        .theme-dark .chat-input-bar { background-color: #1e293b; border-color: #334155; }
        .theme-dark .form-control { background-color: #0f172a; border-color: #475569; color: #f8fafc; }

        .theme-amber .chat-bubble-me { background-color: #d97706; color: #ffffff; }
        .theme-amber .chat-bubble-partner { background-color: #fffbeb; color: #92400e; border: 1px solid #fde68a; }
        .theme-amber .chat-header { background-color: #fffbeb; }

        /* Guidelines card */
        .guidelines-box {
            background-color: #f0fdf4;
            border-left: 4px solid #16a34a;
            border-bottom: 1px solid #bbf7d0;
            padding: 12px 16px;
            font-size: 0.86rem;
            color: #14532d;
            transition: all 0.3s ease;
        }

        .chat-image {
            max-width: 220px;
            max-height: 220px;
            border-radius: 6px;
            cursor: pointer;
            margin-top: 4px;
            display: block;
        }

        .theme-select {
            padding: 4px 8px;
            font-size: 0.8rem;
            border-radius: 4px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand" title="Findr - Campus Lost &amp; Found">
            <span class="brand-icon">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </span>
            <div class="brand-text">
                <span class="brand-name">Findr</span>
                <span class="brand-byline">by Dhruv Choubey</span>
            </div>
        </a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <% if (item != null) { %>
                <a href="items?action=view&id=<%= item.getId() %>" class="nav-link">&larr; Back to Item</a>
            <% } else { %>
                <a href="items" class="nav-link">&larr; Back to Notice Board</a>
            <% } %>
            <% if (currentUser != null) { %>
                <% if (currentUser.isAdmin()) { %>
                    <a href="admin" class="btn" style="background-color: #fef3c7; color: #92400e; padding: 4px 10px; font-size: 0.8rem; font-weight: 700; border: 1px solid #fde68a;">🏛️ Dean Portal</a>
                    <span class="nav-link" style="color: #92400e; font-weight: 700;">🏛️ Dean (@admin)</span>
                <% } else { %>
                    <span class="nav-link" style="color: #0284c7; font-weight: 600;">@<%= currentUser.getUsername() %></span>
                <% } %>
                <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <div id="chatBoxContainer" class="chat-container theme-blue" style="height: 640px;">
            <!-- Header with Themes & Nickname Controls -->
            <div class="chat-header">
                <div>
                    <h3 id="chatHeaderTitle">
                        <% if ("admin".equalsIgnoreCase(partnerUsername)) { %>
                            🏛️ Official Helpdesk &bull; Dean's Office (@admin)
                        <% } else if (currentUser != null && currentUser.isAdmin()) { %>
                            🏛️ Dean Desk &bull; Responding to @<%= partnerUsername %>
                        <% } else { %>
                            Chat with @<%= partnerUsername %>
                        <% } %>
                    </h3>
                    <% if (item != null) { %>
                        <span style="font-size: 0.8rem; color: #64748b;">Regarding: <%= item.getTitle() %> (<%= item.getClassroom() %>)</span>
                    <% } %>
                </div>

                <div style="display: flex; gap: 8px; align-items: center; flex-wrap: wrap;">
                    <!-- Theme Selector -->
                    <select id="themeSelector" class="theme-select" title="Switch Chat Theme">
                        <option value="theme-blue">🎨 Blue (Default)</option>
                        <option value="theme-green">🌿 Emerald Green</option>
                        <option value="theme-dark">🌙 Midnight Dark</option>
                        <option value="theme-amber">🌅 Sunset Amber</option>
                    </select>

                    <!-- Custom Nickname Button -->
                    <button type="button" id="nicknameBtn" class="theme-select" style="background-color: #f8fafc;" title="Set temporary display nickname">
                        🏷️ Nickname
                    </button>

                    <span style="font-size: 0.78rem; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; font-weight: 600;">
                        IST Active
                    </span>
                </div>
            </div>

            <!-- Enhanced Verification & Safety Guidelines -->
            <div id="guidelinesBox" class="guidelines-box">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px;">
                    <strong style="color: #166534; font-size: 0.9rem;">🛡️ Safe Item Verification &amp; Coordination Rules:</strong>
                    <button type="button" onclick="toggleGuidelines()" style="background:none;border:none;color:#166534;cursor:pointer;font-size:0.8rem;text-decoration:underline;">
                        Minimize
                    </button>
                </div>
                <div id="guidelinesContent">
                    <ul style="padding-left: 18px; line-height: 1.4; margin-top: 4px;">
                        <li><strong>Ask for Secret Proof:</strong> Ask for details hidden in photos (e.g. lockscreen wallpaper, sticker behind phone, last 4 digits of ID card).</li>
                        <li><strong>Safe Public Meeting:</strong> Meet only at Campus Library Counter, Security Gate 1, Canteen, or Admin Window.</li>
                        <li><strong>Photo Proof:</strong> Use the 📷 button below to attach photos of the item or verification marks.</li>
                        <li><strong>No Sensitive Info:</strong> Never share UPI PIN, OTP, passwords, or personal mobile numbers.</li>
                    </ul>
                </div>
            </div>

            <!-- Messages list -->
            <div id="chatMessages" class="chat-messages">
                <div id="chatLoadingNotice" style="text-align: center; color: #94a3b8; font-size: 0.85rem; padding: 24px;">
                    Loading conversation...
                </div>
            </div>

            <!-- Input Bar with Photo Upload -->
            <form id="chatForm" class="chat-input-bar">
                <!-- Hidden photo input -->
                <input type="file" id="photoInput" accept="image/*" style="display: none;">

                <!-- Photo upload button -->
                <button type="button" id="photoBtn" class="btn btn-secondary" style="padding: 8px 12px; font-size: 1rem;" title="Attach photo of item or proof">
                    📷
                </button>

                <input type="text" id="messageInput" class="form-control" placeholder="Type message to coordinate safely without revealing personal credentials..." required autocomplete="off">
                <button type="submit" id="sendBtn" class="btn btn-primary">Send</button>
            </form>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 10px; color: #475569;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Student Helpline:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
    </footer>

    <script>
        var currentItemId = <%= item != null ? item.getId() : 0 %>;
        var currentPartnerId = <%= partnerId %>;
        var myUserId = <%= currentUser != null ? currentUser.getId() : 0 %>;
        var originalUsername = "<%= currentUser != null ? currentUser.getUsername() : "Student" %>";

        var chatBoxContainer = document.getElementById("chatBoxContainer");
        var chatMessages = document.getElementById("chatMessages");
        var chatForm = document.getElementById("chatForm");
        var messageInput = document.getElementById("messageInput");
        var sendBtn = document.getElementById("sendBtn");
        var themeSelector = document.getElementById("themeSelector");
        var nicknameBtn = document.getElementById("nicknameBtn");
        var photoBtn = document.getElementById("photoBtn");
        var photoInput = document.getElementById("photoInput");

        // Nickname Support
        var customNickname = localStorage.getItem("chat_nickname_" + myUserId) || "";
        if (customNickname) {
            nicknameBtn.textContent = "🏷️ " + customNickname;
        }

        nicknameBtn.addEventListener("click", function() {
            var input = prompt("Enter a custom display nickname for this chat (e.g., 'ID Card Owner' or 'Student 302'):", customNickname);
            if (input !== null) {
                customNickname = input.trim();
                if (customNickname) {
                    localStorage.setItem("chat_nickname_" + myUserId, customNickname);
                    nicknameBtn.textContent = "🏷️ " + customNickname;
                } else {
                    localStorage.removeItem("chat_nickname_" + myUserId);
                    nicknameBtn.textContent = "🏷️ Nickname";
                }
            }
        });

        // Theme Support
        var savedTheme = localStorage.getItem("chat_theme") || "theme-blue";
        chatBoxContainer.className = "chat-container " + savedTheme;
        themeSelector.value = savedTheme;

        themeSelector.addEventListener("change", function() {
            var selected = themeSelector.value;
            chatBoxContainer.className = "chat-container " + selected;
            localStorage.setItem("chat_theme", selected);
        });

        function toggleGuidelines() {
            var content = document.getElementById("guidelinesContent");
            if (content.style.display === "none") {
                content.style.display = "block";
            } else {
                content.style.display = "none";
            }
        }

        function escapeHtml(text) {
            if (!text) return "";
            var div = document.createElement("div");
            div.textContent = text;
            return div.innerHTML;
        }

        // Indian Standard Time (IST) Formatter (UTC + 5:30)
        function formatToIST(utcStr) {
            if (!utcStr) return "";
            try {
                var clean = utcStr.replace(" ", "T");
                if (!clean.endsWith("Z")) clean += "Z";
                var d = new Date(clean);
                if (isNaN(d.getTime())) d = new Date(utcStr);
                return d.toLocaleTimeString("en-IN", { timeZone: "Asia/Kolkata", hour: "2-digit", minute: "2-digit", hour12: true });
            } catch (e) {
                return utcStr.substring(11, 16);
            }
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
                    + '<span style="font-size:0.82rem;color:#94a3b8;">Send a message or photo below to start identity-safe verification!</span>'
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

                var senderLabel = isMe ? (customNickname ? customNickname + " (You)" : "You") : "@" + msg.senderUsername;
                var istTime = formatToIST(msg.sentAt);

                var messageBody = "";
                if (msg.content && msg.content.indexOf("[IMAGE]") === 0) {
                    var imgSrc = msg.content.substring(7);
                    messageBody = '<a href="' + imgSrc + '" target="_blank"><img src="' + imgSrc + '" class="chat-image" alt="Item Photo"></a>';
                } else {
                    messageBody = escapeHtml(msg.content);
                }

                bubble.innerHTML = '<div class="chat-sender-name">' + escapeHtml(senderLabel) + '</div>'
                                 + '<div>' + messageBody + '</div>'
                                 + '<div style="font-size:0.68rem;opacity:0.75;text-align:right;margin-top:4px;">' + istTime + ' (IST)</div>';

                chatMessages.appendChild(bubble);
            }

            if (isNearBottom) {
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }
        }

        // Send Text Message
        chatForm.addEventListener("submit", async function(e) {
            e.preventDefault();
            var text = messageInput.value.trim();
            if (!text) return;

            await sendMessagePayload(text);
            messageInput.value = "";
        });

        // Photo Upload Trigger & Handling
        photoBtn.addEventListener("click", function() {
            photoInput.click();
        });

        photoInput.addEventListener("change", function() {
            var file = photoInput.files[0];
            if (!file) return;

            var reader = new FileReader();
            reader.onload = function(event) {
                var img = new Image();
                img.onload = function() {
                    // Compress image using canvas (max width 500px to send super fast)
                    var canvas = document.createElement("canvas");
                    var maxDim = 500;
                    var width = img.width;
                    var height = img.height;

                    if (width > height && width > maxDim) {
                        height = Math.round(height * (maxDim / width));
                        width = maxDim;
                    } else if (height > maxDim) {
                        width = Math.round(width * (maxDim / height));
                        height = maxDim;
                    }

                    canvas.width = width;
                    canvas.height = height;
                    var ctx = canvas.getContext("2d");
                    ctx.drawImage(img, 0, 0, width, height);

                    var compressedBase64 = canvas.toDataURL("image/jpeg", 0.7);
                    sendMessagePayload("[IMAGE]" + compressedBase64);
                };
                img.src = event.target.result;
            };
            reader.readAsDataURL(file);
            photoInput.value = "";
        });

        async function sendMessagePayload(content) {
            sendBtn.disabled = true;
            try {
                var formData = new URLSearchParams();
                formData.append("itemId", currentItemId);
                formData.append("partnerId", currentPartnerId);
                formData.append("senderId", myUserId);
                formData.append("message", content);

                var postUrl = window.location.pathname;
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
                console.error("Error sending payload:", err);
                alert("Network error: " + err.message);
            } finally {
                sendBtn.disabled = false;
                messageInput.focus();
            }
        }

        fetchMessages();
        setInterval(fetchMessages, 2500);
    </script>
</body>
</html>
