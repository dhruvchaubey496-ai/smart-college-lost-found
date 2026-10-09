<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ page import="java.time.Year" %>
<%
    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Not Found | Findr by Dhruv Choubey</title>
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
            <a href="items" class="btn btn-primary">Return to Notice Board</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card" style="text-align: center; padding: 48px 24px;">
            <div style="font-size: 3rem; font-weight: 800; color: #0284c7; margin-bottom: 8px;">404</div>
            <h1 style="font-size: 1.4rem; color: #0f172a; margin-bottom: 10px;">Notice Page Not Found</h1>
            <p style="font-size: 0.95rem; color: #64748b; margin-bottom: 24px; line-height: 1.5;">
                The notice or page you are looking for might have been resolved, removed, or never existed.
            </p>
            <a href="items" class="btn btn-primary">Back to Campus Notice Board <span class="arrow-anim">&rarr;</span></a>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
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
