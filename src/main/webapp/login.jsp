<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
    String successMsg = (String) session.getAttribute("successMessage");
    if (successMsg != null) session.removeAttribute("successMessage");
    String adminRequired = request.getParameter("adminRequired");
    String loginRequired = request.getParameter("loginRequired");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Login - Findr | by Dhruv Choubey</title>
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

            <% if (loginRequired != null) { %>
                <div class="alert alert-error">Please login or register to access the anonymous chat room.</div>
            <% } %>

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

            <!-- Google Sign-In Option -->
            <div style="margin: 18px 0; text-align: center;">
                <div style="display: flex; align-items: center; margin-bottom: 14px;">
                    <hr style="flex: 1; border: none; border-top: 1px solid #e2e8f0;">
                    <span style="padding: 0 10px; font-size: 0.74rem; color: #94a3b8; font-weight: 700; letter-spacing: 0.04em;">OR CONTINUE WITH</span>
                    <hr style="flex: 1; border: none; border-top: 1px solid #e2e8f0;">
                </div>
                <button type="button" onclick="handleGoogleSignIn()" class="btn" style="width: 100%; background: #ffffff; border: 1px solid #cbd5e1; color: #1e293b; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 10px; padding: 10px 16px;">
                    <svg width="18" height="18" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/></svg>
                    Continue with Google (Campus Account)
                </button>
            </div>

            <!-- Hidden form for Google Login submission -->
            <form id="googleLoginForm" action="auth" method="post" style="display: none;">
                <input type="hidden" name="action" value="googleLogin">
                <input type="hidden" name="googleEmail" id="googleEmailInput">
                <input type="hidden" name="googleName" id="googleNameInput">
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
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System</p>
        <p style="margin-bottom: 10px; color: #475569;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Student Support:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
    </footer>

    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        function handleGoogleSignIn() {
            var email = prompt("Google Sign-In:\nEnter your College or Personal Google Email (@gmail.com or @college.edu):", "dhruvchoubey496@gmail.com");
            if (email && email.trim()) {
                var name = prompt("Enter your Display Name for your Google Profile:", "Dhruv Choubey");
                document.getElementById("googleEmailInput").value = email.trim();
                document.getElementById("googleNameInput").value = name && name.trim() ? name.trim() : "Student";
                document.getElementById("googleLoginForm").submit();
            }
        }
    </script>
</body>
</html>
