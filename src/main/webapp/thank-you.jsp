<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.Year" %>
<%
    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notice Published - Smart College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <a href="items" class="btn btn-primary">View Notice Board &rarr;</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card" style="text-align: center; padding: 40px 24px;">
            <div style="width: 56px; height: 56px; background-color: #f0fdf4; border: 2px solid #bbf7d0; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 16px auto; color: #166534; font-size: 1.6rem; font-weight: 700;">
                &#10003;
            </div>
            <h1 style="font-size: 1.5rem; color: #0f172a; margin-bottom: 8px;">Notice Published Successfully!</h1>
            <p style="font-size: 0.95rem; color: #475569; margin-bottom: 24px; line-height: 1.6;">
                Thank you for helping fellow students! Your notice is now live on the campus notice board. 
                Any student claiming the item can initiate an identity-safe anonymous chat with you.
            </p>
            <div style="display: flex; gap: 12px; justify-content: center; flex-wrap: wrap;">
                <a href="items" class="btn btn-primary">Go to Notice Board <span class="arrow-anim">&rarr;</span></a>
                <a href="post-item.jsp" class="btn btn-secondary">+ Post Another Item</a>
            </div>
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
