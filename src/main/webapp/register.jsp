<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Student Account - Smart College Lost &amp; Found</title>
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
            <div style="text-align: center; margin-bottom: 20px;">
                <span style="font-size: 0.75rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; text-transform: uppercase;">
                    Student Registration
                </span>
                <h2 style="font-size: 1.5rem; color: #0f172a; margin: 8px 0 4px 0;">Join Campus Lost &amp; Found</h2>
                <p style="font-size: 0.88rem; color: #64748b;">
                    Pick a unique username. Your real email and contact details remain strictly confidential and safe during student chats.
                </p>
            </div>

            <% if (errorMsg != null) { %>
                <div class="alert alert-error"><%= errorMsg %></div>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">

                <div class="form-group">
                    <label class="form-label">Public Username (Visible to others)</label>
                    <input type="text" name="username" class="form-control" required placeholder="e.g. rahul_cs, tech_sam" pattern="[A-Za-z0-9_]{3,20}" title="Letters, numbers and underscores only (3-20 chars)">
                    <span style="font-size: 0.78rem; color: #64748b; margin-top: 2px; display: block;">This handle is all other students will see in chats.</span>
                </div>

                <div class="form-group">
                    <label class="form-label">College Email Address (Private)</label>
                    <input type="email" name="email" class="form-control" required placeholder="e.g. student@college.edu">
                    <span style="font-size: 0.78rem; color: #64748b; margin-top: 2px; display: block;">Never exposed publicly or in message threads.</span>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required placeholder="Create password" minlength="4">
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Create Student Account</button>
            </form>

            <div style="margin-top: 18px; text-align: center; font-size: 0.9rem; color: #64748b;">
                Already have an account? <a href="login.jsp" style="color: #0284c7; font-weight: 600; text-decoration: none;">Login here</a>
            </div>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System</p>
        <p style="margin-bottom: 10px; color: #475569;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Student Support:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
    </footer>

</body>
</html>
