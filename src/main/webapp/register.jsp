<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Findr | by Dhruv Choubey</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

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

            <!-- Google Sign-Up Option -->
            <div style="margin: 18px 0; text-align: center;">
                <div style="display: flex; align-items: center; margin-bottom: 14px;">
                    <hr style="flex: 1; border: none; border-top: 1px solid #e2e8f0;">
                    <span style="padding: 0 10px; font-size: 0.74rem; color: #94a3b8; font-weight: 700; letter-spacing: 0.04em;">OR SIGN UP WITH</span>
                    <hr style="flex: 1; border: none; border-top: 1px solid #e2e8f0;">
                </div>
                <button type="button" onclick="handleGoogleRegister()" class="btn" style="width: 100%; background: #ffffff; border: 1px solid #cbd5e1; color: #1e293b; font-weight: 600; display: flex; align-items: center; justify-content: center; gap: 10px; padding: 10px 16px;">
                    <svg width="18" height="18" viewBox="0 0 24 24"><path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/><path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/><path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"/><path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/></svg>
                    Sign Up with Google (Campus Account)
                </button>
            </div>

            <!-- Hidden form for Google Login submission -->
            <form id="googleRegisterForm" action="auth" method="post" style="display: none;">
                <input type="hidden" name="action" value="googleLogin">
                <input type="hidden" name="googleEmail" id="googleRegEmailInput">
                <input type="hidden" name="googleName" id="googleRegNameInput">
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

    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        function handleGoogleRegister() {
            var email = prompt("Google One-Tap Sign-Up:\nEnter your College or Personal Google Email (@gmail.com or @college.edu):", "dhruvchoubey496@gmail.com");
            if (email && email.trim()) {
                var name = prompt("Enter your Name for Google profile:", "Dhruv Choubey");
                document.getElementById("googleRegEmailInput").value = email.trim();
                document.getElementById("googleRegNameInput").value = name && name.trim() ? name.trim() : "Student";
                document.getElementById("googleRegisterForm").submit();
            }
        }
    </script>
</body>
</html>
