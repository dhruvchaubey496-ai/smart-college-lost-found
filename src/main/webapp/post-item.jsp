<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.college.lostfound.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String errorMsg = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Item - Findr | by Dhruv Choubey</title>
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
            <% if (!user.isAdmin()) { %>
                <a href="chat?adminSupport=true" class="btn" style="background-color: #f0f9ff; color: #0284c7; border: 1px solid #bae6fd;">💬 Contact Admin</a>
            <% } %>
            <span class="nav-link" style="color: #0284c7; font-weight: 700;">@<%= user.getUsername() %></span>
            <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
        </nav>
    </header>

    <main class="container">
        <div class="form-card">
            <h2 style="font-size: 1.4rem; color: #0f172a; margin-bottom: 6px;">Report an Item</h2>
            <p style="font-size: 0.9rem; color: #64748b; margin-bottom: 20px;">Notice something left behind in a lecture hall or lost something? Post it here.</p>

            <% if (errorMsg != null) { %>
                <div class="alert alert-error"><%= errorMsg %></div>
            <% } %>

            <form action="items" method="post">
                <div class="form-group">
                    <label class="form-label">Notice Type</label>
                    <select name="type" class="form-control" required>
                        <option value="FOUND">Someone left this behind in class (Found)</option>
                        <option value="LOST">I lost this item (Lost)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Item Title</label>
                    <input type="text" name="title" class="form-control" placeholder="e.g. Casio Scientific Calculator, Blue Water Bottle" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Classroom / Location Found</label>
                    <input type="text" name="classroom" class="form-control" placeholder="e.g. Room 302, Bench 3 or Computer Lab 2" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Category</label>
                    <select name="category" class="form-control" required>
                        <option value="ID Card">ID Card / Wallet</option>
                        <option value="Electronics">Electronics (Laptop, Phone, Charger)</option>
                        <option value="Stationery">Stationery / Notebooks</option>
                        <option value="Water Bottle">Water Bottle / Bag</option>
                        <option value="Keys">Keys</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Description / Identifier</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Describe where it was kept or any visible features without revealing private secret codes." required></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%;">Publish Notice</button>
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

</body>
</html>
