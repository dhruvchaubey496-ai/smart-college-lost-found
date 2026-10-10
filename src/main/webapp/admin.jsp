<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User, com.college.lostfound.model.Message, java.time.Year" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Item> allItems = (List<Item>) request.getAttribute("allItems");
    List<User> allUsers = (List<User>) request.getAttribute("allUsers");
    List<Message> recentMessages = (List<Message>) request.getAttribute("recentMessages");

    int totalItems = (request.getAttribute("totalItems") != null) ? (Integer) request.getAttribute("totalItems") : 0;
    int openItems = (request.getAttribute("openItems") != null) ? (Integer) request.getAttribute("openItems") : 0;
    int resolvedItems = (request.getAttribute("resolvedItems") != null) ? (Integer) request.getAttribute("resolvedItems") : 0;
    int totalUsers = (request.getAttribute("totalUsers") != null) ? (Integer) request.getAttribute("totalUsers") : 0;

    String adminSuccess = (String) session.getAttribute("adminSuccess");
    if (adminSuccess != null) session.removeAttribute("adminSuccess");

    String adminError = (String) session.getAttribute("adminError");
    if (adminError != null) session.removeAttribute("adminError");

    int currentYear = Year.now().getValue();
    int helpdeskItemId = (request.getAttribute("helpdeskItemId") != null) ? (Integer) request.getAttribute("helpdeskItemId") : 1;
    int adminId = (request.getAttribute("adminId") != null) ? (Integer) request.getAttribute("adminId") : 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Lost &amp; Found Authority Portal</title>
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
            background-color: #f8fafc;
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
        .admin-form-panel {
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 28px;
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
            <a href="items" class="nav-link">&larr; Public Board</a>
            <span class="nav-link" style="color: #0284c7; font-weight: 700;">Officer: @<%= currentUser.getUsername() %></span>
            <a href="auth?action=logout" class="btn btn-secondary">Logout</a>
        </nav>
    </header>

    <main class="container">
        <!-- Header -->
        <div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 12px;">
            <div>
                <span style="font-size: 0.78rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">
                    Central Security &bull; Dean of Student Affairs
                </span>
                <h1 style="font-size: 1.7rem; color: #0f172a; margin-top: 8px;">Department Administration Portal</h1>
                <p style="font-size: 0.95rem; color: #64748b;">
                    Full privileged control: Delete notices, inspect student chat logs, broadcast official notices, and resolve claims.
                </p>
            </div>
            <div>
                <button onclick="document.getElementById('postNoticeSection').scrollIntoView({behavior: 'smooth'})" class="btn btn-primary">
                    + Broadcast Official Notice
                </button>
            </div>
        </div>

        <% if (adminSuccess != null) { %>
            <div class="alert alert-success"><%= adminSuccess %></div>
        <% } %>

        <% if (adminError != null) { %>
            <div class="alert alert-error"><%= adminError %></div>
        <% } %>

        <!-- Statistics Overview -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= totalItems %></div>
                <div class="stat-label">Total Notices</div>
            </div>
            <div class="stat-card" style="border-top: 3px solid #0284c7;">
                <div class="stat-number" style="color: #0284c7;"><%= openItems %></div>
                <div class="stat-label">Active Open Items</div>
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

        <!-- Section: Broadcast Official Department Notice -->
        <div id="postNoticeSection" class="admin-form-panel">
            <h3 style="font-size: 1.2rem; color: #0f172a; margin-bottom: 6px;">📢 Broadcast Official Department Notice (Flashcard on Student Portal)</h3>
            <p style="font-size: 0.88rem; color: #64748b; margin-bottom: 16px;">
                Publish items or urgent alerts from Campus Security, Main Gate, or Dean's Desk. 
                <strong style="color: #b45309;">Notices posted here appear as high-priority Flashcards on every student's homepage!</strong>
            </p>

            <form action="admin" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 14px;">
                <input type="hidden" name="action" value="publishOfficialNotice">

                <div>
                    <label class="form-label">Notice Type</label>
                    <select name="type" class="form-control" required>
                        <option value="FOUND">FOUND (Deposited at Department)</option>
                        <option value="LOST">LOST (Reported to Security)</option>
                    </select>
                </div>

                <div>
                    <label class="form-label">Item Title</label>
                    <input type="text" name="title" class="form-control" placeholder="e.g. Scientific Calculator, Smartwatch" required>
                </div>

                <div>
                    <label class="form-label">Location / Drop-off Point</label>
                    <input type="text" name="classroom" class="form-control" value="Campus Security Desk (Gate 1)" required>
                </div>

                <div>
                    <label class="form-label">Category</label>
                    <select name="category" class="form-control" required>
                        <option value="ID Card">ID Card / Wallet</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Stationery">Stationery</option>
                        <option value="Water Bottle">Water Bottle / Bag</option>
                        <option value="Keys">Keys</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div style="grid-column: 1 / -1;">
                    <label class="form-label">Description / Verification Instructions</label>
                    <textarea name="description" class="form-control" rows="2" placeholder="e.g. Item deposited at Central Security. Student must show college ID to claim." required></textarea>
                </div>

                <div style="grid-column: 1 / -1;">
                    <button type="submit" class="btn btn-primary">Publish Official Notice to Campus Board &rarr;</button>
                </div>
            </form>
        </div>

        <!-- Section 1: All Notices Oversight & Quick Deletion -->
        <div style="margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="font-size: 1.25rem; color: #0f172a;">All Campus Notices (<%= allItems != null ? allItems.size() : 0 %>)</h2>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Type</th>
                        <th>Item Details</th>
                        <th>Location</th>
                        <th>Category</th>
                        <th>Posted By</th>
                        <th>Status</th>
                        <th>Privileged Actions</th>
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
                                        <a href="chat?itemId=<%= item.getId() %>&partnerId=0" class="btn" style="background-color: #f0f9ff; color: #0284c7; border: 1px solid #bae6fd; font-size: 0.78rem; padding: 4px 8px;" title="Inspect student chat threads for this item">
                                            💬 Inspect Chats
                                        </a>
                                        <% if (!"RESOLVED".equalsIgnoreCase(item.getStatus())) { %>
                                            <a href="admin?action=resolve&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.78rem; padding: 4px 8px;" title="Mark as handed over to owner">Mark Resolved</a>
                                        <% } else { %>
                                            <a href="admin?action=reopen&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.78rem; padding: 4px 8px;">Reopen</a>
                                        <% } %>
                                        <a href="admin?action=deleteItem&id=<%= item.getId() %>" onclick="return confirm('Delete this notice permanently from the system?');" class="btn" style="background-color: #fee2e2; color: #b91c1c; font-size: 0.78rem; padding: 4px 8px;">Delete Notice</a>
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

        <!-- Dedicated Student Helpdesk Inquiries Box -->
        <div style="background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%); border: 1px solid #bfdbfe; border-radius: 12px; padding: 22px 24px; margin-top: 32px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 14px;">
            <div>
                <span style="font-size: 0.74rem; font-weight: 700; background: #2563eb; color: #ffffff; padding: 3px 8px; border-radius: 4px; text-transform: uppercase;">Direct Officer Line</span>
                <h3 style="font-size: 1.25rem; color: #1e3a8a; margin: 6px 0 4px 0;">🎧 Student Support &amp; Helpdesk Chat Room</h3>
                <p style="font-size: 0.9rem; color: #1e40af; margin: 0;">Students who click "Contact Admin" send messages to this official department channel.</p>
            </div>
            <div>
                <a href="chat?itemId=<%= helpdeskItemId %>&partnerId=0" class="btn btn-primary" style="background: #2563eb; border-color: #1d4ed8;">
                    Open Central Helpdesk Thread &rarr;
                </a>
            </div>
        </div>

        <!-- Section 2: Chat & Communications Oversight -->
        <div style="margin-bottom: 12px; margin-top: 28px;">
            <h2 style="font-size: 1.25rem; color: #0f172a;">💬 Campus Communications Oversight (Recent Chats)</h2>
            <p style="font-size: 0.88rem; color: #64748b;">Direct transcript access to student messages to monitor dispute resolutions and prevent campus abuse.</p>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>Notice ID</th>
                        <th>Sender Student</th>
                        <th>Message Content</th>
                        <th>Timestamp</th>
                        <th>Investigation / Reply</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (recentMessages != null && !recentMessages.isEmpty()) {
                        for (Message m : recentMessages) { 
                            boolean isHelpdesk = (m.getItemId() == helpdeskItemId);
                        %>
                            <tr style="<%= isHelpdesk ? "background-color: #f0fdf4;" : "" %>">
                                <td>
                                    <strong>#<%= m.getItemId() %></strong>
                                    <% if (isHelpdesk) { %>
                                        <span style="background-color: #dcfce7; color: #15803d; padding: 2px 6px; border-radius: 4px; font-size: 0.72rem; font-weight: 700; display: block; margin-top: 3px;">HELP DESK</span>
                                    <% } %>
                                </td>
                                <td><strong>@<%= m.getSenderUsername() %></strong></td>
                                <td style="max-width: 380px;">
                                    <% if (m.getContent() != null && m.getContent().startsWith("[IMAGE]")) { %>
                                        <a href="<%= m.getContent().substring(7) %>" target="_blank" style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none; color: #0284c7; font-weight: 600;">
                                            <img src="<%= m.getContent().substring(7) %>" alt="Photo" style="max-height: 40px; border-radius: 4px; border: 1px solid #cbd5e1;">
                                            <span>📷 [Attached Photo Verification]</span>
                                        </a>
                                    <% } else { %>
                                        <%= m.getContent() %>
                                    <% } %>
                                </td>
                                <td style="font-size: 0.8rem; color: #64748b;"><%= m.getSentAt() %></td>
                                <td>
                                    <% if (isHelpdesk) { %>
                                        <a href="chat?itemId=<%= m.getItemId() %>&partnerId=<%= m.getSenderId() %>" class="btn btn-primary" style="font-size: 0.78rem; padding: 4px 10px;">
                                            Reply to @<%= m.getSenderUsername() %> &rarr;
                                        </a>
                                    <% } else { %>
                                        <a href="chat?itemId=<%= m.getItemId() %>&partnerId=0" class="btn btn-secondary" style="font-size: 0.78rem; padding: 3px 8px;">
                                            Open Thread &rarr;
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                    <%  }
                    } else { %>
                        <tr>
                            <td colspan="5" style="text-align: center; color: #64748b; padding: 24px;">No student communications logged yet.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Section 3: Student Directory Oversight & Ban/Delete -->
        <div style="margin-bottom: 12px; margin-top: 32px;">
            <h2 style="font-size: 1.25rem; color: #0f172a;">Student Directory Oversight (<%= allUsers != null ? allUsers.size() : 0 %>)</h2>
            <p style="font-size: 0.88rem; color: #64748b;">Direct access to student handles and emails with account ban/delete permissions.</p>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Handle / Username</th>
                        <th>College Email Address</th>
                        <th>Role</th>
                        <th>Department Action</th>
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
                                        <span style="background-color: #e0e7ff; color: #4338ca; padding: 3px 8px; border-radius: 4px; font-weight: 700; font-size: 0.78rem;">OFFICER (ADMIN)</span>
                                    <% } else { %>
                                        <span style="background-color: #f1f5f9; color: #475569; padding: 3px 8px; border-radius: 4px; font-size: 0.78rem;">STUDENT</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (!u.isAdmin()) { %>
                                        <a href="admin?action=deleteUser&id=<%= u.getId() %>" onclick="return confirm('Ban and permanently delete student @<%= u.getUsername() %>?');" class="btn" style="background-color: #fee2e2; color: #b91c1c; font-size: 0.78rem; padding: 4px 8px;">Ban / Delete Student</a>
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
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %></p>
        <p style="margin-bottom: 10px; color: #475569;">System Architecture &amp; Developed by <strong>Dhruv Choubey</strong></p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Administrator Support:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
    </footer>

</body>
</html>
