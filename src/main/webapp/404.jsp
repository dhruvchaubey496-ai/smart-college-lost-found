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
    <title>404 - Notice Not Found | Smart College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
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
        <p style="font-weight: 600; color: #1e293b; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 6px;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <p style="font-size: 0.82rem;">Support: <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
