<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Item> allItems = (List<Item>) request.getAttribute("allItems");
    List<User> allUsers = (List<User>) request.getAttribute("allUsers");

    int totalItems = (request.getAttribute("totalItems") != null) ? (Integer) request.getAttribute("totalItems") : 0;
    int openItems = (request.getAttribute("openItems") != null) ? (Integer) request.getAttribute("openItems") : 0;
    int resolvedItems = (request.getAttribute("resolvedItems") != null) ? (Integer) request.getAttribute("resolvedItems") : 0;
    int totalUsers = (request.getAttribute("totalUsers") != null) ? (Integer) request.getAttribute("totalUsers") : 0;

    String adminSuccess = (String) session.getAttribute("adminSuccess");
    if (adminSuccess != null) session.removeAttribute("adminSuccess");

    String adminError = (String) session.getAttribute("adminError");
    if (adminError != null) session.removeAttribute("adminError");

    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Admin Desk - Smart College Lost &amp; Found</title>
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
    <style>
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 24px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            text-align: left;
        }
        th, td {
            padding: 12px 14px;
            border-bottom: 1px solid #e2e8f0;
        }
        th {
            background-color: #f8fafc;
            color: #334155;
            font-weight: 600;
        }
        tr:hover {
            background-color: #f1f5f9;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background-color: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 18px;
            text-align: center;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: #0284c7;
            margin-bottom: 4px;
        }
        .stat-label {
            font-size: 0.85rem;
            color: #64748b;
            font-weight: 500;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <div class="rainbow-strip"></div>

    <header class="navbar">
        <a href="items" class="brand">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: #0284c7;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
            Lost &amp; Found Department Desk
        </a>
        <nav class="nav-links">
            <a href="items" class="nav-link">Campus View</a>
            <span class="nav-link" style="color: #0284c7; font-weight: 700;">Officer: @<%= currentUser.getUsername() %></span>
            <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
        </nav>
    </header>

    <main class="container">
        <!-- Admin Welcome Banner -->
        <div style="margin-bottom: 24px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 12px;">
                <div>
                    <span style="font-size: 0.78rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">
                        Dean of Student Affairs &bull; Campus Security
                    </span>
                    <h1 style="font-size: 1.7rem; color: #0f172a; margin-top: 8px;">Department Administration Portal</h1>
                    <p style="font-size: 0.95rem; color: #64748b;">
                        Direct oversight of all campus lost and found notices, student registrations, and safe item returns.
                    </p>
                </div>
                <div>
                    <a href="items" class="btn btn-secondary">&larr; Back to Public Board</a>
                </div>
            </div>
        </div>

        <% if (adminSuccess != null) { %>
            <div class="alert alert-success"><%= adminSuccess %></div>
        <% } %>

        <% if (adminError != null) { %>
            <div class="alert alert-error"><%= adminError %></div>
        <% } %>

        <!-- Metrics Overview -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalItems %></div>
                <div class="stat-label">Total Notices</div>
            </div>
            <div class="stat-card" style="border-top: 3px solid #0284c7;">
                <div class="stat-number" style="color: #0284c7;"><%= openItems %></div>
                <div class="stat-label">Open Active Items</div>
            </div>
            <div class="stat-card" style="border-top: 3px solid #22c55e;">
                <div class="stat-number" style="color: #16a34a;"><%= resolvedItems %></div>
                <div class="stat-label">Handed Over / Resolved</div>
            </div>
            <div class="stat-card" style="border-top: 3px solid #8b5cf6;">
                <div class="stat-number" style="color: #7c3aed;"><%= totalUsers %></div>
                <div class="stat-label">Registered Students</div>
            </div>
        </div>

        <!-- Section 1: All Items Management -->
        <div style="margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="font-size: 1.25rem; color: #0f172a;">All Campus Notices (<%= allItems != null ? allItems.size() : 0 %>)</h2>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Type</th>
                        <th>Item Title</th>
                        <th>Classroom</th>
                        <th>Category</th>
                        <th>Posted By</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (allItems != null && !allItems.isEmpty()) {
                        for (Item item : allItems) { %>
                            <tr>
                                <td><strong>#<%= item.getId() %></strong></td>
                                <td>
                                    <span class="<%= "FOUND".equals(item.getType()) ? "item-badge-found" : "item-badge-lost" %>">
                                        <%= item.getType() %>
                                    </span>
                                </td>
                                <td>
                                    <strong><%= item.getTitle() %></strong>
                                    <div style="font-size: 0.8rem; color: #64748b;"><%= item.getDescription() %></div>
                                </td>
                                <td><%= item.getClassroom() %></td>
                                <td><%= item.getCategory() %></td>
                                <td>@<%= item.getFinderUsername() %></td>
                                <td>
                                    <% if ("RESOLVED".equalsIgnoreCase(item.getStatus())) { %>
                                        <span style="background-color: #dcfce7; color: #15803d; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 0.78rem;">RESOLVED</span>
                                    <% } else if ("CLAIMED".equalsIgnoreCase(item.getStatus())) { %>
                                        <span style="background-color: #fef3c7; color: #b45309; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 0.78rem;">CLAIMED</span>
                                    <% } else { %>
                                        <span style="background-color: #e0f2fe; color: #0369a1; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 0.78rem;">OPEN</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div style="display: flex; gap: 6px; flex-wrap: wrap;">
                                        <% if (!"RESOLVED".equalsIgnoreCase(item.getStatus())) { %>
                                            <a href="admin?action=resolve&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.78rem; padding: 4px 8px;" title="Mark as handed over to owner">Mark Resolved</a>
                                        <% } else { %>
                                            <a href="admin?action=reopen&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.78rem; padding: 4px 8px;">Reopen</a>
                                        <% } %>
                                        <a href="admin?action=deleteItem&id=<%= item.getId() %>" onclick="return confirm('Delete this notice permanently?');" class="btn" style="background-color: #fee2e2; color: #b91c1c; font-size: 0.78rem; padding: 4px 8px;">Delete</a>
                                    </div>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="8" style="text-align: center; color: #64748b; padding: 24px;">No notices registered yet.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Section 2: Registered Students Management -->
        <div style="margin-bottom: 12px; margin-top: 32px;">
            <h2 style="font-size: 1.25rem; color: #0f172a;">Registered Students &amp; Directory (<%= allUsers != null ? allUsers.size() : 0 %>)</h2>
            <p style="font-size: 0.88rem; color: #64748b;">Direct oversight of registered student usernames and college emails.</p>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Handle / Username</th>
                        <th>College Email Address</th>
                        <th>Role</th>
                        <th>Management</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (allUsers != null && !allUsers.isEmpty()) {
                        for (User u : allUsers) { %>
                            <tr>
                                <td>#<%= u.getId() %></td>
                                <td><strong>@<%= u.getUsername() %></strong></td>
                                <td><%= u.getEmail() %></td>
                                <td>
                                    <% if (u.isAdmin()) { %>
                                        <span style="background-color: #e0e7ff; color: #4338ca; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 0.78rem;">ADMIN</span>
                                    <% } else { %>
                                        <span style="background-color: #f1f5f9; color: #475569; padding: 3px 8px; border-radius: 4px; font-size: 0.78rem;">STUDENT</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!u.isAdmin()) { %>
                                        <a href="admin?action=deleteUser&id=<%= u.getId() %>" onclick="return confirm('Remove student account @<%= u.getUsername() %>?');" class="btn" style="background-color: #fee2e2; color: #b91c1c; font-size: 0.78rem; padding: 4px 8px;">Remove User</a>
                                    <% } else { %>
                                        <span style="font-size: 0.8rem; color: #94a3b8;">Protected Officer</span>
                                    <% } %>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #64748b; padding: 24px;">No students registered yet.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <footer class="footer">
        <p style="font-weight: 600; color: #1e293b; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 6px;">Designed &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <p style="font-size: 0.82rem;">Administration Contact: <a href="mailto:admin-lostfound@college.edu" class="clickable-email">admin-lostfound@college.edu</a></p>
    </footer>

</body>
</html>
