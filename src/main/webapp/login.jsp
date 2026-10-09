<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
    String successMsg = (String) session.getAttribute("successMessage");
    if (successMsg != null) session.removeAttribute("successMessage");
    String adminRequired = request.getParameter("adminRequired");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student &amp; Staff Login - Smart College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <a href="register.jsp" class="btn btn-secondary">Register</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card">
            <div style="text-align: center; margin-bottom: 20px;">
                <span style="font-size: 0.75rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; text-transform: uppercase;">
                    Campus Sign-in
                </span>
                <h2 style="font-size: 1.5rem; color: #0f172a; margin: 8px 0 4px 0;">Sign In to Your Account</h2>
                <p style="font-size: 0.88rem; color: #64748b;">
                    Login to post notices, chat anonymously, or access department management.
                </p>
            </div>

            <% if (adminRequired != null) { %>
                <div class="alert alert-error">Officer authentication required to access Department Desk.</div>
            <% } %>

            <% if (successMsg != null) { %>
                <div class="alert alert-success"><%= successMsg %></div>
            <% } %>

            <% if (errorMsg != null) { %>
                <div class="alert alert-error"><%= errorMsg %></div>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">

                <div class="form-group">
                    <label class="form-label">Username or College Email</label>
                    <input type="text" name="identifier" class="form-control" required placeholder="e.g. dhruv_81 or admin">
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required placeholder="Enter password">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In</button>
            </form>

            <div style="margin-top: 18px; text-align: center; font-size: 0.9rem; color: #64748b;">
                New student? <a href="register.jsp" style="color: #0284c7; font-weight: 600; text-decoration: none;">Create an account</a>
            </div>

            <!-- Quick Department Officer Access Demo Box -->
            <div style="margin-top: 24px; padding: 14px; background-color: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 6px; text-align: center;">
                <span style="font-size: 0.75rem; font-weight: 700; color: #475569; text-transform: uppercase;">Dean &amp; Security Officer Access</span>
                <p style="font-size: 0.8rem; color: #64748b; margin: 4px 0 10px 0;">Username: <code>admin</code> &bull; Password: <code>admin123</code></p>
                <a href="admin?quickAuth=true" class="btn btn-secondary" style="font-size: 0.85rem; padding: 6px 14px; width: 100%;">
                    ⚡ 1-Click Department Officer Entry &rarr;
                </a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 600; color: #1e293b; margin-bottom: 4px;">Smart College Lost &amp; Found Management System</p>
        <p style="margin-bottom: 6px;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <p style="font-size: 0.82rem;">Questions? <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
