<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.college.lostfound.model.Item, com.college.lostfound.model.User" %>
<%
    Item item = (Item) request.getAttribute("item");
    User currentUser = (User) session.getAttribute("user");
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

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <% if (currentUser != null) { %>
                <a href="post-item.jsp" class="btn btn-secondary">Report Item</a>
                <a href="auth?action=logout" class="btn btn-primary">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="btn btn-primary">Login</a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <% if (item != null) { %>
            <div class="form-card" style="max-width: 650px;">
                <a href="items" style="color: #0284c7; text-decoration: none; font-size: 0.9rem; margin-bottom: 12px; display: inline-block;">&larr; Back to Notice Board</a>
                
                <div>
                    <span class="<%= "FOUND".equals(item.getType()) ? "item-badge-found" : "item-badge-lost" %>">
                        <%= item.getType() %>
                    </span>
                </div>
                
                <h1 style="font-size: 1.5rem; margin-top: 10px; color: #0f172a;"><%= item.getTitle() %></h1>
                
                <div style="background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 6px; padding: 12px; margin: 16px 0; font-size: 0.92rem;">
                    <p style="margin-bottom: 4px;"><strong>Classroom / Hall:</strong> <%= item.getClassroom() %></p>
                    <p style="margin-bottom: 4px;"><strong>Category:</strong> <%= item.getCategory() %></p>
                    <p><strong>Reported By:</strong> @<%= item.getFinderUsername() %> <span style="color: #64748b; font-size: 0.82rem;">(Identity Protected)</span></p>
                </div>

                <div style="margin-bottom: 24px;">
                    <h3 style="font-size: 1rem; color: #334155; margin-bottom: 6px;">Description:</h3>
                    <p style="color: #475569; line-height: 1.5;"><%= item.getDescription() %></p>
                </div>

                <% if (currentUser == null) { %>
                    <div class="alert alert-error">
                        Please <a href="login.jsp" style="font-weight: 700; color: #991b1b;">Login</a> to chat with @<%= item.getFinderUsername() %> anonymously.
                    </div>
                <% } else if (currentUser.getId() == item.getUserId()) { %>
                    <div class="alert alert-success">
                        You reported this item. Any student claiming it can chat with you directly.
                    </div>
                <% } else { %>
                    <a href="chat?itemId=<%= item.getId() %>&partnerId=<%= item.getUserId() %>" class="btn btn-primary" style="width: 100%;">
                        Message @<%= item.getFinderUsername() %> Anonymously
                    </a>
                <% } %>
            </div>
        <% } %>
    </main>

    <footer class="footer">
        <p>Smart College Lost &amp; Found Portal &bull; Questions? Reach out at <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
