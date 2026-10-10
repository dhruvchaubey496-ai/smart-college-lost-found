<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
<%
    Item item = (Item) request.getAttribute("item");
    User currentUser = (User) session.getAttribute("user");
    List<User> chatPartners = (List<User>) request.getAttribute("chatPartners");
    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= item != null ? item.getTitle() : "Item Details" %> - College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
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
            <% if (currentUser != null) { %>
                <a href="post-item.jsp" class="btn btn-secondary">+ Report Item</a>
                <% if (!currentUser.isAdmin()) { %>
                    <a href="chat?adminSupport=true" class="btn" style="background-color: #f0f9ff; color: #0284c7; border: 1px solid #bae6fd;">💬 Contact Admin</a>
                <% } %>
                <span class="nav-link" style="color: #0284c7; font-weight: 700;">@<%= currentUser.getUsername() %></span>
                <a href="auth?action=logout" class="btn btn-primary">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-primary">Login</a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <% if (item != null) { %>
            <div class="form-card" style="max-width: 650px;">
                <a href="items" style="color: #0284c7; text-decoration: none; font-size: 0.9rem; margin-bottom: 14px; display: inline-block;">&larr; Back to Notice Board</a>
                
                <div>
                    <span class="<%= "FOUND".equals(item.getType()) ? "item-badge-found" : "item-badge-lost" %>">
                        <%= item.getType() %>
                    </span>
                </div>
                
                <h1 style="font-size: 1.5rem; margin-top: 10px; color: #0f172a;"><%= item.getTitle() %></h1>
                
                <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 14px; margin: 16px 0; font-size: 0.92rem;">
                    <p style="margin-bottom: 6px;"><strong>Classroom / Location:</strong> <%= item.getClassroom() %></p>
                    <p style="margin-bottom: 6px;"><strong>Category:</strong> <%= item.getCategory() %></p>
                    <p><strong>Reported By:</strong> @<%= item.getFinderUsername() %> <span style="color: #64748b; font-size: 0.82rem;">(Identity Protected)</span></p>
                </div>

                <div style="margin-bottom: 24px;">
                    <h3 style="font-size: 1rem; color: #334155; margin-bottom: 6px;">Description:</h3>
                    <p style="color: #475569; line-height: 1.5;"><%= item.getDescription() %></p>
                </div>

                <% if (currentUser == null) { %>
                    <div class="alert alert-error">
                        Please <a href="login.jsp" style="font-weight: 700; color: #991b1b;">Login</a> or <a href="register.jsp" style="font-weight: 700; color: #991b1b;">Register</a> to message @<%= item.getFinderUsername() %> anonymously.
                    </div>
                <% } else if (currentUser.getId() == item.getUserId()) { %>
                    <!-- User is the Creator of this Item Notice -->
                    <div class="alert alert-success" style="margin-bottom: 16px;">
                        <strong>You posted this notice.</strong> Below are the student inquiries received for this item:
                    </div>

                    <% if (chatPartners != null && !chatPartners.isEmpty()) { %>
                        <div style="margin-bottom: 20px;">
                            <h4 style="font-size: 0.95rem; color: #1e293b; margin-bottom: 10px;">Inquiries from Students:</h4>
                            <% for (User partner : chatPartners) { %>
                                <div style="display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 10px 14px; margin-bottom: 8px;">
                                    <span>Chat with <strong>@<%= partner.getUsername() %></strong></span>
                                    <a href="chat?itemId=<%= item.getId() %>&partnerId=<%= partner.getId() %>" class="btn btn-primary" style="font-size: 0.85rem; padding: 6px 12px;">
                                        Open Chat &rarr;
                                    </a>
                                </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 16px;">
                            No student messages received yet. Once someone messages you regarding this item, their private thread will show here.
                        </p>
                    <% } %>

                    <!-- Preview / Test Chat Room -->
                    <a href="chat?itemId=<%= item.getId() %>&partnerId=<%= item.getUserId() %>" class="btn btn-secondary" style="width: 100%; text-align: center;">
                        Preview / Test Chat Room &rarr;
                    </a>

                <% } else { %>
                    <!-- User is a Seeker claiming the item -->
                    <a href="chat?itemId=<%= item.getId() %>&partnerId=<%= item.getUserId() %>" class="btn btn-primary" style="width: 100%;">
                        Message @<%= item.getFinderUsername() %> Anonymously <span class="arrow-anim">&rarr;</span>
                    </a>
                <% } %>
            </div>
        <% } %>
    </main>

    <footer class="footer">
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 10px; color: #475569;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Helpline:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
    </footer>

</body>
</html>
