<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Item> items = (List<Item>) request.getAttribute("items");
    String keyword = (String) request.getAttribute("keyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedType = (String) request.getAttribute("selectedType");
    String successMsg = (String) session.getAttribute("successMessage");
    if (successMsg != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <header class="navbar">
        <a href="items" class="brand">Campus Lost &amp; Found</a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Home</a>
            <% if (currentUser != null) { %>
                <a href="post-item.jsp" class="btn btn-secondary">Report Item</a>
                <span class="nav-link">@<%= currentUser.getUsername() %></span>
                <a href="auth?action=logout" class="btn btn-primary">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="nav-link">Login</a>
                <a href="register.jsp" class="btn btn-primary">Register</a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <% if (successMsg != null) { %>
            <div class="alert alert-success"><%= successMsg %></div>
        <% } %>

        <div style="margin-bottom: 20px;">
            <h1 style="font-size: 1.6rem; color: #0f172a; margin-bottom: 4px;">Campus Notice Board</h1>
            <p style="font-size: 0.95rem; color: #64748b;">Find items left behind in classrooms or post something you found.</p>
        </div>

        <form action="items" method="get" class="filter-bar">
            <input type="text" name="keyword" class="filter-input" placeholder="Search item or classroom (e.g. Lab 302)..." value="<%= keyword != null ? keyword : "" %>">
            
            <select name="type" class="filter-select">
                <option value="ALL" <%= "ALL".equals(selectedType) ? "selected" : "" %>>All Types</option>
                <option value="FOUND" <%= "FOUND".equals(selectedType) ? "selected" : "" %>>Found Items</option>
                <option value="LOST" <%= "LOST".equals(selectedType) ? "selected" : "" %>>Lost Items</option>
            </select>

            <select name="category" class="filter-select">
                <option value="ALL" <%= "ALL".equals(selectedCategory) ? "selected" : "" %>>All Categories</option>
                <option value="ID Card" <%= "ID Card".equals(selectedCategory) ? "selected" : "" %>>ID Card / Wallet</option>
                <option value="Electronics" <%= "Electronics".equals(selectedCategory) ? "selected" : "" %>>Electronics</option>
                <option value="Stationery" <%= "Stationery".equals(selectedCategory) ? "selected" : "" %>>Notebooks / Stationery</option>
                <option value="Water Bottle" <%= "Water Bottle".equals(selectedCategory) ? "selected" : "" %>>Bottles / Bags</option>
                <option value="Keys" <%= "Keys".equals(selectedCategory) ? "selected" : "" %>>Keys</option>
                <option value="Other" <%= "Other".equals(selectedCategory) ? "selected" : "" %>>Other</option>
            </select>

            <button type="submit" class="btn btn-primary">Filter</button>
            <a href="items" class="btn btn-secondary">Reset</a>
        </form>

        <div class="items-grid">
            <% if (items != null && !items.isEmpty()) {
                for (Item item : items) { %>
                    <div class="item-card">
                        <div>
                            <span class="<%= "FOUND".equals(item.getType()) ? "item-badge-found" : "item-badge-lost" %>">
                                <%= item.getType() %>
                            </span>
                            <h2 class="item-title"><%= item.getTitle() %></h2>
                            <div class="item-meta">
                                Classroom: <strong><%= item.getClassroom() %></strong> &bull; Category: <%= item.getCategory() %>
                            </div>
                            <p class="item-desc"><%= item.getDescription() %></p>
                        </div>
                        <div style="border-top: 1px solid #f1f5f9; padding-top: 12px; display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 0.85rem; color: #64748b;">Posted by: <strong>@<%= item.getFinderUsername() %></strong></span>
                            <a href="items?action=view&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 6px 12px;">View &amp; Claim</a>
                        </div>
                    </div>
            <%  } 
            } else { %>
                <div style="grid-column: 1 / -1; padding: 40px; text-align: center; border: 1px dashed #cbd5e1; border-radius: 8px;">
                    <p style="color: #64748b; font-size: 1rem;">No items currently listed matching your criteria.</p>
                </div>
            <% } %>
        </div>
    </main>

    <footer class="footer">
        <p>Smart College Lost &amp; Found Portal &bull; Need help? Contact <a href="mailto:support-lostfound@college.edu" class="clickable-email">support-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
