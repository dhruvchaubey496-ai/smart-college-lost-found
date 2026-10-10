<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String errorMsg = (String) request.getAttribute("errorMessage");
    String successMsg = (String) session.getAttribute("successMessage");
    if (successMsg != null) session.removeAttribute("successMessage");
    String adminRequired = request.getParameter("adminRequired");
    String loginRequired = request.getParameter("loginRequired");
    boolean isDeanMode = (adminRequired != null) || ("true".equalsIgnoreCase(request.getParameter("dean")));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Findr | by Dhruv Choubey</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .portal-tabs {
            display: flex;
            background: #f1f5f9;
            border-radius: 8px;
            padding: 4px;
            margin-bottom: 22px;
            gap: 4px;
        }
        .portal-tab-btn {
            flex: 1;
            padding: 10px 14px;
            border: none;
            background: transparent;
            font-size: 0.88rem;
            font-weight: 600;
            color: #64748b;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }
        .portal-tab-btn.active {
            background: #ffffff;
            color: #0f172a;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }
        .portal-tab-btn.dean-tab.active {
            color: #92400e;
            background: #fffbeb;
            border: 1px solid #fde68a;
        }
        .dean-badge {
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border: 1px solid #f59e0b;
            color: #92400e;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.74rem;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
        }
        .portal-pane {
            display: none;
        }
        .portal-pane.active {
            display: block;
            animation: fadeIn 0.25s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
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
            <a href="register.jsp" class="btn btn-secondary">Register</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card" style="max-width: 460px;">
            <!-- Tab Switcher -->
            <div class="portal-tabs">
                <button type="button" class="portal-tab-btn <%= !isDeanMode ? "active" : "" %>" id="tabStudentBtn" onclick="switchPortal('student')">
                    🎓 Student Login
                </button>
                <button type="button" class="portal-tab-btn dean-tab <%= isDeanMode ? "active" : "" %>" id="tabDeanBtn" onclick="switchPortal('dean')">
                    🏛️ Dean / Authority Login
                </button>
            </div>

            <% if (loginRequired != null) { %>
                <div class="alert alert-error">Please login or register to access the anonymous chat room.</div>
            <% } %>

            <% if (adminRequired != null) { %>
                <div class="alert alert-error">Dean or Administrative Authority authentication required.</div>
            <% } %>

            <% if (successMsg != null) { %>
                <div class="alert alert-success"><%= successMsg %></div>
            <% } %>

            <% if (errorMsg != null) { %>
                <div class="alert alert-error"><%= errorMsg %></div>
            <% } %>

            <!-- PANE 1: STUDENT LOGIN -->
            <div id="studentPane" class="portal-pane <%= !isDeanMode ? "active" : "" %>">
                <div style="text-align: center; margin-bottom: 20px;">
                    <span style="font-size: 0.75rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 8px; border-radius: 4px; text-transform: uppercase;">
                        Student Sign-in
                    </span>
                    <h2 style="font-size: 1.45rem; color: #0f172a; margin: 8px 0 4px 0;">Student Portal</h2>
                    <p style="font-size: 0.88rem; color: #64748b;">
                        Coordinate lost &amp; found items, chat safely with peers, or contact the Dean desk.
                    </p>
                </div>

                <form action="auth" method="post">
                    <input type="hidden" name="action" value="login">

                    <div class="form-group">
                        <label class="form-label">Username or College Email</label>
                        <input type="text" name="identifier" class="form-control" required placeholder="e.g. roll_no or college email">
                    </div>

                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="Enter your password">
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%;">Sign In as Student</button>
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

                <div style="margin-top: 18px; text-align: center; font-size: 0.9rem; color: #64748b;">
                    New student? <a href="register.jsp" style="color: #0284c7; font-weight: 600; text-decoration: none;">Create an account</a>
                </div>

                <div style="margin-top: 20px; text-align: center; border-top: 1px solid #f1f5f9; padding-top: 14px;">
                    <a href="javascript:void(0)" onclick="switchPortal('dean')" style="font-size: 0.84rem; color: #92400e; text-decoration: none; font-weight: 600;">
                        🏛️ Campus Dean or Administrator? Switch to Dean Portal &rarr;
                    </a>
                </div>
            </div>

            <!-- PANE 2: DEAN & AUTHORITY LOGIN -->
            <div id="deanPane" class="portal-pane <%= isDeanMode ? "active" : "" %>">
                <div style="text-align: center; margin-bottom: 20px;">
                    <span class="dean-badge">
                        🏛️ Official Authority &bull; Dean's Office
                    </span>
                    <h2 style="font-size: 1.45rem; color: #0f172a; margin: 8px 0 4px 0;">Dean &amp; Authority Portal</h2>
                    <p style="font-size: 0.88rem; color: #64748b;">
                        Authorized login for Dean of Student Affairs, dispute arbitration, and official notice broadcast.
                    </p>
                </div>

                <form action="auth" method="post">
                    <input type="hidden" name="action" value="login">

                    <div class="form-group">
                        <label class="form-label" style="font-weight: 600; color: #1e293b;">Authority Username</label>
                        <input type="text" name="identifier" class="form-control" required value="admin" style="border-color: #fde68a; background-color: #fffbeb;">
                    </div>

                    <div class="form-group">
                        <label class="form-label" style="font-weight: 600; color: #1e293b;">Dean Security Password</label>
                        <input type="password" name="password" class="form-control" required placeholder="Enter administrative password">
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; background: linear-gradient(135deg, #d97706 0%, #b45309 100%); border-color: #b45309; padding: 11px;">
                        🏛️ Sign In to Dean Portal &rarr;
                    </button>
                </form>

                <div style="margin-top: 20px; padding: 14px; background: #fffbeb; border: 1px dashed #fde68a; border-radius: 8px; text-align: center;">
                    <span style="font-size: 0.76rem; font-weight: 700; color: #92400e; text-transform: uppercase; letter-spacing: 0.05em;">Authorized Dean Quick Access</span>
                    <p style="font-size: 0.82rem; color: #78350f; margin: 4px 0 10px 0;">Direct 1-Click authenticated access for Dean of Student Affairs.</p>
                    <a href="admin?quickAuth=true" class="btn" style="background: #ffffff; border: 1px solid #d97706; color: #92400e; font-weight: 600; font-size: 0.85rem; width: 100%; display: block;">
                        ⚡ 1-Click Authorized Dean Entry &rarr;
                    </a>
                </div>

                <div style="margin-top: 16px; text-align: center;">
                    <a href="javascript:void(0)" onclick="switchPortal('student')" style="font-size: 0.84rem; color: #0284c7; text-decoration: none; font-weight: 600;">
                        &larr; Return to Student Login
                    </a>
                </div>
            </div>

            <!-- Hidden form for Google Login submission -->
            <form id="googleLoginForm" action="auth" method="post" style="display: none;">
                <input type="hidden" name="action" value="googleLogin">
                <input type="hidden" name="googleEmail" id="googleEmailInput">
                <input type="hidden" name="googleName" id="googleNameInput">
            </form>
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
        function switchPortal(portal) {
            var studentPane = document.getElementById('studentPane');
            var deanPane = document.getElementById('deanPane');
            var tabStudentBtn = document.getElementById('tabStudentBtn');
            var tabDeanBtn = document.getElementById('tabDeanBtn');

            if (portal === 'dean') {
                studentPane.classList.remove('active');
                deanPane.classList.add('active');
                tabStudentBtn.classList.remove('active');
                tabDeanBtn.classList.add('active');
            } else {
                deanPane.classList.remove('active');
                studentPane.classList.add('active');
                tabDeanBtn.classList.remove('active');
                tabStudentBtn.classList.add('active');
            }
        }

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
