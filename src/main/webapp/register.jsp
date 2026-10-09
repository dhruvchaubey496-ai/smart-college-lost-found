<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <a href="login.jsp" class="btn btn-secondary">Login</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card">
            <h2 style="font-size: 1.4rem; color: #0f172a; margin-bottom: 6px;">Register Student Account</h2>
            <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 20px;">Your username will be public in anonymous chats. Your email remains protected.</p>

            <% if (errorMsg != null) { %>
                <div class="alert alert-error"><%= errorMsg %></div>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label class="form-label">Public Username (Visible to other students)</label>
                    <input type="text" name="username" class="form-control" required placeholder="e.g. dhruv_81" pattern="[A-Za-z0-9_]{3,20}" title="Letters, numbers and underscores only (3-20 chars)">
                </div>

                <div class="form-group">
                    <label class="form-label">College Email Address (Kept Private)</label>
                    <input type="email" name="email" class="form-control" required placeholder="e.g. student@college.edu">
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required placeholder="Create password" minlength="4">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Create Account</button>
            </form>

            <div style="margin-top: 16px; text-align: center; font-size: 0.9rem; color: #64748b;">
                Already have an account? <a href="login.jsp" style="color: #0284c7; font-weight: 600; text-decoration: none;">Login here</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p>Smart College Lost &amp; Found Portal &bull; <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
