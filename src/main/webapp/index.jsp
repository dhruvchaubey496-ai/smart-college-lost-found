<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
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
    int currentYear = Year.now().getValue();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Smart College Lost and Found Portal - Secure, classroom-tagged recovery system for students designed by Dhruv Choubey.">
    <title>Smart College Lost &amp; Found Portal</title>
    <!-- Inline SVG Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <!-- Subtle Top Rainbow Accent Bar -->
    <div class="rainbow-strip"></div>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="items" class="brand" title="Return to Home">
            <span class="brand-icon">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
            </span>
            <span>Campus Lost &amp; Found</span>
        </a>

        <!-- Mobile Menu Toggle Button -->
        <button class="mobile-toggle" id="mobileMenuBtn" aria-label="Toggle Navigation">&#9776;</button>

        <nav class="nav-links" id="navLinks">
            <a href="items" class="nav-link">Home</a>
            <a href="#noticeBoard" class="nav-link">Notices</a>
            <a href="#campusDirections" class="nav-link">Drop-off Desk</a>
            <a href="#faqSection" class="nav-link">FAQs</a>

            <% if (currentUser != null) { %>
                <% if (currentUser.isAdmin()) { %>
                    <a href="admin" class="btn" style="background-color: #fef3c7; color: #b45309; border: 1px solid #fde68a;">Dept Admin Portal</a>
                <% } %>
                <a href="post-item.jsp" class="btn btn-secondary">+ Report Item</a>
                <span class="nav-link" style="color: #0284c7; font-weight: 600;">@<%= currentUser.getUsername() %></span>
                <a href="auth?action=logout" class="btn btn-primary">Logout</a>
            <% } else { %>
                <a href="login.jsp" class="nav-link">Login</a>
                <a href="register.jsp" class="btn btn-primary">Register <span class="arrow-anim">&rarr;</span></a>
            <% } %>
        </nav>
    </header>

    <main class="container">
        <% if (successMsg != null) { %>
            <div class="alert alert-success"><%= successMsg %></div>
        <% } %>

        <!-- Hero Section -->
        <section class="hero-card">
            <div>
                <div class="hero-pill">
                    <span class="hero-pill-dot"></span>
                    Campus System Live &bull; Real-time Verification
                </div>
                <h1 class="hero-title">
                    Smart College Lost &amp; Found Management System
                </h1>
                <p class="hero-subtitle">
                    Left your ID card, notebook, or earphones in a classroom? Found someone else's valuables? 
                    This portal helps students coordinate quick, secure returns across campus using <strong>anonymous identity-safe messaging</strong>.
                </p>

                <!-- 3 Feature Points -->
                <div class="feature-grid">
                    <div class="feature-box">
                        <div class="feature-title">📍 1. Tag by Classroom</div>
                        <p class="feature-text">Search and tag by Room Number, Floor, or Computer Lab to find where items were left.</p>
                    </div>
                    <div class="feature-box">
                        <div class="feature-title">🛡️ 2. Privacy Protected</div>
                        <p class="feature-text">Your personal email and mobile number remain private. Only your chosen handle is visible.</p>
                    </div>
                    <div class="feature-box">
                        <div class="feature-title">💬 3. Direct Peer Chat</div>
                        <p class="feature-text">Message finder directly in real-time, share proof photos, and coordinate safe handovers.</p>
                    </div>
                </div>

                <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                    <% if (currentUser == null) { %>
                        <a href="register.jsp" class="btn btn-primary">Create Student Account <span class="arrow-anim">&rarr;</span></a>
                        <a href="#noticeBoard" class="btn btn-secondary">Explore Live Board</a>
                    <% } else { %>
                        <a href="post-item.jsp" class="btn btn-primary">+ Report Found or Lost Item <span class="arrow-anim">&rarr;</span></a>
                        <a href="#noticeBoard" class="btn btn-secondary">View Live Notices</a>
                    <% } %>
                </div>
            </div>
        </section>

        <!-- Live Notice Board Section -->
        <div id="noticeBoard" style="margin-bottom: 16px;">
            <h2 style="font-size: 1.35rem; color: #0f172a; margin-bottom: 4px;">Live Notices &amp; Reports</h2>
            <p style="font-size: 0.9rem; color: #64748b;">Search by room number, keywords, or filter by category.</p>
        </div>

        <!-- Filter Form -->
        <form action="items" method="get" class="filter-bar">
            <input type="text" name="keyword" class="filter-input" placeholder="Search item or classroom (e.g. Lab 302, Bench 4)..." value="<%= keyword != null ? keyword : "" %>">
            
            <select name="type" class="filter-select">
                <option value="ALL" <%= "ALL".equals(selectedType) ? "selected" : "" %>>All Types (Found &amp; Lost)</option>
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

        <!-- Items Grid with Colored Left Strips -->
        <div class="items-grid">
            <% if (items != null && !items.isEmpty()) {
                for (Item item : items) { %>
                    <div class="item-card <%= "FOUND".equals(item.getType()) ? "item-card-found" : "item-card-lost" %>">
                        <div>
                            <span class="<%= "FOUND".equals(item.getType()) ? "item-badge-found" : "item-badge-lost" %>">
                                <%= item.getType() %>
                            </span>
                            <h3 class="item-title"><%= item.getTitle() %></h3>
                            <div class="item-meta">
                                Classroom: <strong><%= item.getClassroom() %></strong> &bull; Category: <%= item.getCategory() %>
                            </div>
                            <p class="item-desc"><%= item.getDescription() %></p>
                        </div>
                        <div style="border-top: 1px solid #f1f5f9; padding-top: 12px; display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-size: 0.85rem; color: #64748b;">By: <strong>@<%= item.getFinderUsername() %></strong></span>
                            <a href="items?action=view&id=<%= item.getId() %>" class="btn btn-secondary" style="font-size: 0.85rem; padding: 6px 14px;">
                                View &amp; Claim <span class="arrow-anim">&rarr;</span>
                            </a>
                        </div>
                    </div>
            <%  } 
            } else { %>
                <div style="grid-column: 1 / -1; padding: 40px; text-align: center; border: 1px dashed #cbd5e1; border-radius: 8px;">
                    <p style="color: #64748b; font-size: 1rem;">No notices currently posted for this search. Found something? Click "Report Item" above!</p>
                </div>
            <% } %>
        </div>

        <!-- Campus Directions & Central Drop-off Desk Section -->
        <section id="campusDirections" class="section-card">
            <h3 style="font-size: 1.25rem; color: #0f172a; margin-bottom: 6px;">Campus Drop-off Desk &amp; Directions</h3>
            <p style="font-size: 0.92rem; color: #64748b; margin-bottom: 16px;">
                Can't meet the student directly? Deposit the item at our official campus lost &amp; found centers:
            </p>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 14px;">
                <div style="background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 14px;">
                    <strong style="color: #0284c7;">Main Admin Block Desk</strong>
                    <p style="font-size: 0.85rem; color: #475569; margin-top: 4px;">Ground Floor, Window 3 &bull; Open: 9:00 AM - 5:00 PM</p>
                </div>
                <div style="background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 14px;">
                    <strong style="color: #0284c7;">Central Library Issue Counter</strong>
                    <p style="font-size: 0.85rem; color: #475569; margin-top: 4px;">1st Floor Library Entrance &bull; Open: 8:00 AM - 8:00 PM</p>
                </div>
                <div style="background-color: #ffffff; border: 1px solid #e2e8f0; border-radius: 6px; padding: 14px;">
                    <strong style="color: #0284c7;">Security Guard Gate 1</strong>
                    <p style="font-size: 0.85rem; color: #475569; margin-top: 4px;">Campus Main Entrance &bull; Available 24/7 for valuable items</p>
                </div>
            </div>
        </section>

        <!-- Frequently Asked Questions (FAQs) -->
        <section id="faqSection" class="section-card">
            <h3 style="font-size: 1.25rem; color: #0f172a; margin-bottom: 12px;">Frequently Asked Questions (FAQs)</h3>
            
            <div class="faq-item">
                <div class="faq-question">How does the anonymous chat protect my identity?</div>
                <div class="faq-answer">
                    When you chat, only your chosen public username is shown. Your personal college email, phone number, and student roll number remain completely hidden in the database.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">What should I do if I find someone's lost ID Card or valuable?</div>
                <div class="faq-answer">
                    Click "Report Item", select the classroom where you found it, write a short description without sharing sensitive card numbers, and coordinate handoff with the owner via anonymous chat.
                </div>
            </div>

            <div class="faq-item">
                <div class="faq-question">Is this system free for all students?</div>
                <div class="faq-answer">
                    Yes, 100% free community initiative built specifically for campus students.
                </div>
            </div>
        </section>

        <!-- Dedicated Campus Student Support & Helpdesk -->
        <section class="support-card">
            <div>
                <div style="font-weight: 800; font-size: 1.15rem; color: #0369a1; margin-bottom: 4px;">
                    💬 Need Help or Immediate Support?
                </div>
                <p style="font-size: 0.92rem; color: #334155; margin: 0;">
                    Have questions about a lost item or need portal assistance? Contact <strong>Dhruv Choubey</strong>:
                </p>
            </div>
            <div class="support-contacts">
                <a href="tel:+919321185628" class="support-pill">
                    <span>📞 +91 9321185628</span>
                </a>
                <a href="mailto:dhruvchoubey496@gmail.com" class="support-pill">
                    <span>✉️ dhruvchoubey496@gmail.com</span>
                </a>
            </div>
        </section>
    </main>

    <!-- Professional Footer with Dynamic Year & Dhruv Choubey Attribution -->
    <footer class="footer">
        <p style="font-weight: 700; color: #0f172a; margin-bottom: 4px;">
            Smart College Lost &amp; Found Management System &bull; &copy; <%= currentYear %>
        </p>
        <p style="margin-bottom: 12px; color: #475569;">
            Architectural Design &amp; Developed by <strong>Dhruv Choubey</strong>
        </p>
        <div class="footer-support-box">
            <span style="font-weight: 700; color: #0f172a;">Official Student Helpline:</span>
            <a href="mailto:dhruvchoubey496@gmail.com">✉️ dhruvchoubey496@gmail.com</a>
            <span>&bull;</span>
            <a href="tel:+919321185628">📞 +91 9321185628</a>
        </div>
        <div style="font-size: 0.88rem; margin-top: 12px;">
            <a href="items" style="color: #0284c7; text-decoration: none; margin: 0 8px;">Home</a> &bull;
            <a href="#campusDirections" style="color: #0284c7; text-decoration: none; margin: 0 8px;">Campus Desks</a> &bull;
            <a href="#faqSection" style="color: #0284c7; text-decoration: none; margin: 0 8px;">FAQs</a> &bull;
            <a href="admin" style="color: #64748b; text-decoration: none; margin: 0 8px;">Department Desk Portal</a>
        </div>
    </footer>

    <!-- Mobile Menu Interactivity Script -->
    <script>
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const navLinks = document.getElementById('navLinks');
        if (mobileMenuBtn && navLinks) {
            mobileMenuBtn.addEventListener('click', () => {
                navLinks.classList.toggle('active');
            });
        }
    </script>
</body>
</html>
