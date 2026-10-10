<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.college.lostfound.model.Item, com.college.lostfound.model.User, java.time.Year" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<Item> items = (List<Item>) request.getAttribute("items");
    List<Item> adminNotices = (List<Item>) request.getAttribute("adminNotices");
    String keyword = (String) request.getAttribute("keyword");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedType = (String) request.getAttribute("selectedType");
    Boolean isNoticesViewAttr = (Boolean) request.getAttribute("isNoticesView");
    boolean isNoticesView = (isNoticesViewAttr != null && isNoticesViewAttr.booleanValue());
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
    <meta name="description" content="Findr - Smart College Lost and Found Portal by Dhruv Choubey. Secure, classroom-tagged recovery and peer coordination system.">
    <title><%= isNoticesView ? "Campus Notices Board - Findr" : "Findr - Smart College Lost & Found" %> | by Dhruv Choubey</title>
    <!-- Inline SVG Favicon -->
    <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%230284c7'><path d='M10 2a8 8 0 105.293 14.707l5 5 1.414-1.414-5-5A8 8 0 0010 2zm0 2a6 6 0 110 12 6 6 0 010-12z'/></svg>">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>

    <!-- Subtle Top Rainbow Accent Bar -->
    <div class="rainbow-strip"></div>

    <!-- Header Navigation -->
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

        <!-- Mobile Menu Toggle Button -->
        <button class="mobile-toggle" id="mobileMenuBtn" aria-label="Toggle Navigation">&#9776;</button>

        <nav class="nav-links" id="navLinks">
            <a href="items" class="nav-link <%= !isNoticesView ? "active-link" : "" %>" style="<%= !isNoticesView ? "color: #0284c7; font-weight: 700;" : "" %>">Home</a>
            <a href="items?view=notices" class="nav-link <%= isNoticesView ? "active-link" : "" %>" style="<%= isNoticesView ? "color: #0284c7; font-weight: 700;" : "" %>">Campus Notices</a>

            <% if (currentUser != null) { %>
                <% if (currentUser.isAdmin()) { %>
                    <a href="admin" class="btn" style="background-color: #fef3c7; color: #92400e; border: 1px solid #fde68a; font-weight: 700;">🏛️ Dean Portal</a>
                    <span class="nav-link" style="color: #92400e; font-weight: 700; background: #fffbeb; padding: 4px 10px; border-radius: 6px; border: 1px solid #fde68a;">🏛️ Dean (@admin)</span>
                <% } else { %>
                    <a href="chat?adminSupport=true" class="btn" style="background-color: #f0f9ff; color: #0284c7; border: 1px solid #bae6fd;">💬 Contact Dean Desk</a>
                    <span class="nav-link" style="color: #0284c7; font-weight: 700;">@<%= currentUser.getUsername() %></span>
                <% } %>
                <a href="post-item.jsp" class="btn btn-secondary">+ Report Item</a>
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

        <% if (!isNoticesView) { %>
            <!-- ========================================== -->
            <!-- 🌟 STUNNING INTRO / OVERVIEW LANDING PAGE -->
            <!-- ========================================== -->

            <!-- Hero Section with Modern Visual Split -->
            <section class="hero-card" style="padding: 40px 32px; margin-bottom: 24px;">
                <div class="intro-hero-grid">
                    <div>
                        <div class="hero-pill" style="margin-bottom: 16px;">
                            <span class="hero-pill-dot"></span>
                            Smart Campus Network &bull; Identity-Safe Coordination
                        </div>
                        <h1 class="hero-title" style="font-size: 2.35rem; line-height: 1.2; margin-bottom: 16px;">
                            Never Lose Your Valuables on Campus Again.
                        </h1>
                        <p class="hero-subtitle" style="font-size: 1.05rem; line-height: 1.6; margin-bottom: 24px;">
                            <strong>Findr</strong> connects college students, faculty, and the <strong>Dean of Student Affairs</strong> to report, verify, and return lost items in minutes. Built with exact classroom geo-tagging, anonymous real-time chat, and verified photo proof.
                        </p>

                        <div style="display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 20px;">
                            <a href="items?view=notices" class="btn btn-primary" style="padding: 12px 22px; font-size: 0.98rem; box-shadow: 0 4px 14px rgba(2, 132, 199, 0.3);">
                                🔍 Browse Campus Notices &rarr;
                            </a>
                            <a href="post-item.jsp" class="btn btn-secondary" style="padding: 12px 20px; font-size: 0.98rem;">
                                + Report Lost or Found Item
                            </a>
                            <% if (currentUser == null) { %>
                                <a href="login.jsp?dean=true" class="btn" style="background: #fffbeb; border: 1px solid #fde68a; color: #92400e; font-weight: 700; padding: 12px 18px; font-size: 0.92rem;">
                                    🏛️ Dean Portal Login
                                </a>
                            <% } else if (!currentUser.isAdmin()) { %>
                                <a href="chat?adminSupport=true" class="btn" style="background: #f0f9ff; border: 1px solid #bae6fd; color: #0284c7; font-weight: 700; padding: 12px 18px; font-size: 0.92rem;">
                                    💬 Contact Dean Desk
                                </a>
                            <% } else { %>
                                <a href="admin" class="btn" style="background: #fef3c7; border: 1px solid #fde68a; color: #92400e; font-weight: 700; padding: 12px 18px; font-size: 0.92rem;">
                                    🏛️ Open Dean Portal &rarr;
                                </a>
                            <% } %>
                        </div>
                    </div>

                    <!-- Right Visual Mockup Showcase -->
                    <div class="intro-mockup-wrapper">
                        <div class="intro-mockup-card">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                                <div style="display: flex; align-items: center; gap: 6px;">
                                    <span style="width: 10px; height: 10px; background: #ef4444; border-radius: 50%;"></span>
                                    <span style="width: 10px; height: 10px; background: #f59e0b; border-radius: 50%;"></span>
                                    <span style="width: 10px; height: 10px; background: #10b981; border-radius: 50%;"></span>
                                </div>
                                <span style="font-size: 0.75rem; font-weight: 700; color: #0284c7; background: #e0f2fe; padding: 3px 8px; border-radius: 4px;">LIVE PREVIEW</span>
                            </div>

                            <!-- Mockup Card 1 -->
                            <div class="mockup-item-pill">
                                <div>
                                    <span class="item-badge-found" style="font-size: 0.68rem; padding: 2px 6px;">FOUND</span>
                                    <h4 style="font-size: 0.92rem; color: #0f172a; margin-top: 4px;">Scientific Calculator (TI-84)</h4>
                                    <span style="font-size: 0.78rem; color: #64748b;">📍 Computer Lab 302, Bench 14</span>
                                </div>
                                <span style="font-size: 1.25rem;">📐</span>
                            </div>

                            <!-- Mockup Card 2 -->
                            <div class="mockup-item-pill" style="border-left: 3px solid #f59e0b;">
                                <div>
                                    <span class="item-badge-lost" style="font-size: 0.68rem; padding: 2px 6px;">LOST</span>
                                    <h4 style="font-size: 0.92rem; color: #0f172a; margin-top: 4px;">College ID Card &bull; Roll S 081</h4>
                                    <span style="font-size: 0.78rem; color: #64748b;">📍 Central Library 1st Floor</span>
                                </div>
                                <span style="font-size: 1.25rem;">🪪</span>
                            </div>

                            <!-- Simulated Real-time Verification Chat Bubble -->
                            <div class="mockup-chat-bubble">
                                <div style="display: flex; align-items: center; gap: 6px; font-weight: 700; margin-bottom: 4px;">
                                    <span>💬 Identity-Safe Peer Chat</span>
                                    <span style="font-size: 0.7rem; color: #15803d; background: #dcfce7; padding: 1px 6px; border-radius: 3px;">VERIFIED</span>
                                </div>
                                <p style="font-size: 0.8rem; margin: 0; line-height: 1.4;">
                                    <strong>@rahul_cs:</strong> "Uploaded photo of the sticker on back 📷. Deposited at Dean Office!"
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Campus Trust Stats Bar -->
            <div class="intro-stats-bar">
                <div class="intro-stat-item">
                    <div class="intro-stat-val">100%</div>
                    <div class="intro-stat-lbl">Identity Protected</div>
                    <p style="font-size: 0.8rem; color: #64748b; margin-top: 4px;">Zero personal phone or email leaks</p>
                </div>
                <div class="intro-stat-item">
                    <div class="intro-stat-val">30 Sec</div>
                    <div class="intro-stat-lbl">Fast Reporting</div>
                    <p style="font-size: 0.8rem; color: #64748b; margin-top: 4px;">Tag classroom, category &amp; upload proof</p>
                </div>
                <div class="intro-stat-item">
                    <div class="intro-stat-val">Real-Time</div>
                    <div class="intro-stat-lbl">Photo Proof Chat</div>
                    <p style="font-size: 0.8rem; color: #64748b; margin-top: 4px;">Verify ownership before meeting up</p>
                </div>
                <div class="intro-stat-item">
                    <div class="intro-stat-val">🏛️ Dean</div>
                    <div class="intro-stat-lbl">Official Authority</div>
                    <p style="font-size: 0.8rem; color: #64748b; margin-top: 4px;">Official flashcards &amp; dispute oversight</p>
                </div>
            </div>

            <!-- Core Features Showcase -->
            <div style="margin: 44px 0;">
                <div style="text-align: center; margin-bottom: 32px;">
                    <span style="font-size: 0.78rem; font-weight: 700; background-color: #e0f2fe; color: #0284c7; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">
                        ENGINEERED FOR CAMPUS
                    </span>
                    <h2 style="font-size: 1.85rem; color: #0f172a; margin-top: 8px;">Why Findr Works Faster Than Campus Groups</h2>
                    <p style="font-size: 0.95rem; color: #64748b; max-width: 620px; margin: 6px auto 0 auto;">
                        Traditional college WhatsApp groups are messy, noisy, and expose your private mobile numbers. Findr provides a dedicated, structured, secure platform.
                    </p>
                </div>

                <div class="feature-grid" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));">
                    <div class="feature-box" style="padding: 24px;">
                        <div style="font-size: 2rem; margin-bottom: 12px;">📍</div>
                        <h3 style="font-size: 1.15rem; color: #0f172a; margin-bottom: 8px;">1. Exact Classroom Tagging</h3>
                        <p style="font-size: 0.9rem; color: #475569; line-height: 1.5;">
                            Search by exact lecture hall (e.g., Room 204, Chemistry Lab 2, Library 2nd Floor). Students in that block can spot your item immediately.
                        </p>
                    </div>

                    <div class="feature-box" style="padding: 24px;">
                        <div style="font-size: 2rem; margin-bottom: 12px;">🛡️</div>
                        <h3 style="font-size: 1.15rem; color: #0f172a; margin-bottom: 8px;">2. 100% Identity-Safe Chat</h3>
                        <p style="font-size: 0.9rem; color: #475569; line-height: 1.5;">
                            Chat directly with finders without exposing personal mobile numbers, roll numbers, or personal emails. Only your custom handle is visible.
                        </p>
                    </div>

                    <div class="feature-box" style="padding: 24px;">
                        <div style="font-size: 2rem; margin-bottom: 12px;">📷</div>
                        <h3 style="font-size: 1.15rem; color: #0f172a; margin-bottom: 8px;">3. Image Proof Verification</h3>
                        <p style="font-size: 0.9rem; color: #475569; line-height: 1.5;">
                            Upload clear photo proofs, unique markings, or scratch marks in the chat room to guarantee the item goes to its rightful owner.
                        </p>
                    </div>

                    <div class="feature-box" style="padding: 24px;">
                        <div style="font-size: 2rem; margin-bottom: 12px;">🏛️</div>
                        <h3 style="font-size: 1.15rem; color: #0f172a; margin-bottom: 8px;">4. Official Dean Oversight</h3>
                        <p style="font-size: 0.9rem; color: #475569; line-height: 1.5;">
                            Direct channel with the Dean of Student Affairs. Official notices appear as high-priority Flashcards, and students can escalate claims anytime.
                        </p>
                    </div>
                </div>
            </div>

            <!-- How Findr Works (3 Steps) -->
            <div class="steps-container">
                <div style="text-align: center; margin-bottom: 24px;">
                    <span style="font-size: 0.78rem; font-weight: 700; background-color: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">
                        SIMPLE 3-STEP PROCESS
                    </span>
                    <h2 style="font-size: 1.75rem; color: #0f172a; margin-top: 8px;">How Easy It Is To Recover Items</h2>
                </div>

                <div class="steps-grid">
                    <div class="step-card">
                        <div class="step-number">1</div>
                        <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 8px;">Spot or Report Item</h3>
                        <p style="font-size: 0.9rem; color: #64748b; line-height: 1.5;">
                            Whether you lost your wallet or found someone's notebook, post a notice in 30 seconds tagged with the exact classroom or campus area.
                        </p>
                    </div>

                    <div class="step-card">
                        <div class="step-number">2</div>
                        <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 8px;">Verify via Anonymous Chat</h3>
                        <p style="font-size: 0.9rem; color: #64748b; line-height: 1.5;">
                            The claimant and finder chat safely. Share photo proof, verify secret details (like wallpaper or sticker), and set a safe handover spot.
                        </p>
                    </div>

                    <div class="step-card">
                        <div class="step-number">3</div>
                        <h3 style="font-size: 1.1rem; color: #0f172a; margin-bottom: 8px;">Safe Campus Handover</h3>
                        <p style="font-size: 0.9rem; color: #64748b; line-height: 1.5;">
                            Meet safely at the Dean's Office, Security Gate 1, or Central Library Counter to hand over the item and mark the claim as resolved!
                        </p>
                    </div>
                </div>
            </div>

            <!-- Portal Gateway Cards (Student vs Dean) -->
            <div class="gateway-grid">
                <div class="gateway-card">
                    <div>
                        <span style="font-size: 0.75rem; font-weight: 700; background: #e0f2fe; color: #0284c7; padding: 4px 10px; border-radius: 4px; text-transform: uppercase;">
                            CAMPUS STUDENTS
                        </span>
                        <h3 style="font-size: 1.35rem; color: #0f172a; margin: 10px 0 8px 0;">Student Community Access</h3>
                        <p style="font-size: 0.92rem; color: #64748b; line-height: 1.5; margin-bottom: 20px;">
                            Browse all active campus lost &amp; found reports, contact finders anonymously, or ask the Dean Helpdesk for support.
                        </p>
                    </div>
                    <div>
                        <a href="items?view=notices" class="btn btn-primary" style="width: 100%; text-align: center; padding: 12px;">
                            🚀 Open Campus Notices Board &rarr;
                        </a>
                    </div>
                </div>

                <div class="gateway-card dean">
                    <div>
                        <span style="font-size: 0.75rem; font-weight: 700; background: #fef3c7; color: #92400e; padding: 4px 10px; border-radius: 4px; text-transform: uppercase; border: 1px solid #fde68a;">
                            COLLEGE ADMINISTRATION
                        </span>
                        <h3 style="font-size: 1.35rem; color: #0f172a; margin: 10px 0 8px 0;">Dean &amp; Authority Portal</h3>
                        <p style="font-size: 0.92rem; color: #64748b; line-height: 1.5; margin-bottom: 20px;">
                            Exclusive administrative access for Dean of Student Affairs &amp; Security Desk to broadcast urgent Flashcard notices and inspect dispute logs.
                        </p>
                    </div>
                    <div>
                        <a href="login.jsp?dean=true" class="btn" style="width: 100%; text-align: center; background: linear-gradient(135deg, #d97706 0%, #b45309 100%); color: #ffffff; padding: 12px; font-weight: 700;">
                            🏛️ Enter Dean Portal &rarr;
                        </a>
                    </div>
                </div>
            </div>

            <!-- Dedicated Campus Student Support & Helpdesk -->
            <section class="support-card" style="margin-top: 36px;">
                <div>
                    <div style="font-weight: 800; font-size: 1.15rem; color: #0369a1; margin-bottom: 4px;">
                        💬 Need Immediate Assistance or Lost an Important Valuables?
                    </div>
                    <p style="font-size: 0.92rem; color: #334155; margin: 0;">
                        Direct helpline for campus lost &amp; found support managed by <strong>Dhruv Choubey</strong>:
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

        <% } else { %>
            <!-- ========================================== -->
            <!-- 📋 DEDICATED LIVE CAMPUS NOTICES BOARD    -->
            <!-- ========================================== -->

            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; margin-bottom: 20px;">
                <div>
                    <a href="items" style="color: #0284c7; font-weight: 600; text-decoration: none; font-size: 0.88rem; display: inline-block; margin-bottom: 6px;">
                        &larr; Back to Findr Intro &amp; Overview
                    </a>
                    <h1 style="font-size: 1.75rem; color: #0f172a; margin: 0;">Live Campus Notices Board</h1>
                    <p style="font-size: 0.92rem; color: #64748b; margin-top: 2px;">Search by classroom, keywords, or filter by category.</p>
                </div>
                <div>
                    <a href="post-item.jsp" class="btn btn-primary">+ Report New Item &rarr;</a>
                </div>
            </div>

            <!-- Official Notices by Dean (Flashcard Section) -->
            <% if (adminNotices != null && !adminNotices.isEmpty()) { %>
                <section class="admin-flashcard-section" style="margin-bottom: 28px;">
                    <div class="flashcard-header">
                        <div style="display: flex; align-items: center; gap: 10px;">
                            <span class="flashcard-pill" style="background: linear-gradient(135deg, #d97706 0%, #b45309 100%);">⚡ OFFICIAL NOTICE BY DEAN</span>
                            <span style="font-size: 0.92rem; color: #92400e; font-weight: 700;">Dean of Student Affairs &amp; Campus Authority Broadcast</span>
                        </div>
                        <span style="font-size: 0.8rem; color: #b45309; font-weight: 600;">Verified High Priority</span>
                    </div>

                    <div class="flashcard-deck">
                        <% for (Item an : adminNotices) { %>
                            <div class="admin-flashcard">
                                <div>
                                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px;">
                                        <span class="flashcard-tag">🏛️ <%= an.getType() %> AT DEAN / SECURITY</span>
                                        <span style="font-size: 0.74rem; color: #94a3b8; font-weight: 600;"><%= an.getCategory() %></span>
                                    </div>
                                    <h3 class="flashcard-title"><%= an.getTitle().replace("[DEPT OFFICIAL] ", "").replace("[OFFICIAL NOTICE] ", "").replace("[DEAN NOTICE] ", "") %></h3>
                                    <p style="font-size: 0.84rem; color: #0284c7; font-weight: 600; margin-bottom: 8px;">
                                        📍 <%= an.getClassroom() %>
                                    </p>
                                    <p class="flashcard-body"><%= an.getDescription() %></p>
                                </div>
                                <div style="border-top: 1px dashed #fde68a; padding-top: 10px; display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-size: 0.78rem; color: #78350f;">Notice by: <strong>Dean's Desk (@<%= an.getFinderUsername() %>)</strong></span>
                                    <a href="items?action=view&id=<%= an.getId() %>" class="btn btn-sm btn-primary" style="background: linear-gradient(135deg, #d97706 0%, #b45309 100%); border-color: #b45309; font-size: 0.8rem;">
                                        Claim / Inquire &rarr;
                                    </a>
                                </div>
                            </div>
                        <% } %>
                    </div>
                </section>
            <% } %>

            <!-- Filter Bar -->
            <form action="items" method="get" class="filter-bar" style="margin-bottom: 24px;">
                <input type="hidden" name="view" value="notices">
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
                <a href="items?view=notices" class="btn btn-secondary">Reset</a>
            </form>

            <!-- Items Grid -->
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
                    <div style="grid-column: 1 / -1; padding: 50px 20px; text-align: center; border: 1px dashed #cbd5e1; border-radius: 12px; background: #ffffff;">
                        <span style="font-size: 2.2rem; display: block; margin-bottom: 8px;">📭</span>
                        <h3 style="font-size: 1.15rem; color: #0f172a; margin-bottom: 6px;">No notices found for this search</h3>
                        <p style="color: #64748b; font-size: 0.92rem; margin-bottom: 16px;">Found something on campus? Be a hero and post a report!</p>
                        <a href="post-item.jsp" class="btn btn-primary">+ Post Found or Lost Item &rarr;</a>
                    </div>
                <% } %>
            </div>

        <% } %>
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
            <a href="items" style="color: #0284c7; text-decoration: none; margin: 0 8px;">Home Overview</a> &bull;
            <a href="items?view=notices" style="color: #0284c7; text-decoration: none; margin: 0 8px;">Campus Notices</a> &bull;
            <a href="login.jsp?dean=true" style="color: #92400e; text-decoration: none; margin: 0 8px; font-weight: 600;">Dean &amp; Authority Portal</a>
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
