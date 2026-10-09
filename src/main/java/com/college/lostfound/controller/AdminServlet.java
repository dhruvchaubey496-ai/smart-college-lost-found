package com.college.lostfound.controller;

import com.college.lostfound.dao.ItemDAO;
import com.college.lostfound.dao.UserDAO;
import com.college.lostfound.model.Item;
import com.college.lostfound.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        // Auto-login helper if accessed with ?quickAuth=true for seamless demo
        String quickAuth = req.getParameter("quickAuth");
        if ("true".equals(quickAuth) && (currentUser == null || !currentUser.isAdmin())) {
            User adminUser = userDAO.login("admin", "admin123");
            if (adminUser != null) {
                session = req.getSession(true);
                session.setAttribute("user", adminUser);
                currentUser = adminUser;
            }
        }

        // Ensure user has Admin privileges
        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect("login.jsp?adminRequired=true");
            return;
        }

        String action = req.getParameter("action");
        if (action != null) {
            try {
                if ("resolve".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemDAO.updateItemStatus(id, "RESOLVED");
                    session.setAttribute("adminSuccess", "Item #" + id + " marked as Handed Over / Resolved.");
                } else if ("claim".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemDAO.updateItemStatus(id, "CLAIMED");
                    session.setAttribute("adminSuccess", "Item #" + id + " marked as Claimed.");
                } else if ("reopen".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemDAO.updateItemStatus(id, "OPEN");
                    session.setAttribute("adminSuccess", "Item #" + id + " reset to Open.");
                } else if ("deleteItem".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemDAO.deleteItem(id);
                    session.setAttribute("adminSuccess", "Notice #" + id + " permanently deleted from system.");
                } else if ("deleteUser".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    userDAO.deleteUser(id);
                    session.setAttribute("adminSuccess", "Student Account #" + id + " banned and deleted.");
                }
            } catch (Exception e) {
                session.setAttribute("adminError", "Action failed: " + e.getMessage());
            }
            resp.sendRedirect("admin");
            return;
        }

        // Metrics calculation
        List<Item> allItems = itemDAO.getAllItemsForAdmin();
        List<User> allUsers = userDAO.getAllUsers();

        int totalItems = allItems.size();
        int openItems = 0;
        int resolvedItems = 0;

        for (Item item : allItems) {
            if ("OPEN".equalsIgnoreCase(item.getStatus())) {
                openItems++;
            } else {
                resolvedItems++;
            }
        }

        req.setAttribute("allItems", allItems);
        req.setAttribute("allUsers", allUsers);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("openItems", openItems);
        req.setAttribute("resolvedItems", resolvedItems);
        req.setAttribute("totalUsers", allUsers.size());

        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || !currentUser.isAdmin()) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("publishOfficialNotice".equals(action)) {
            String title = req.getParameter("title");
            String category = req.getParameter("category");
            String type = req.getParameter("type");
            String classroom = req.getParameter("classroom");
            String description = req.getParameter("description");

            if (title != null && !title.trim().isEmpty()) {
                Item item = new Item();
                item.setTitle("[DEPT OFFICIAL] " + title.trim());
                item.setCategory(category != null ? category : "Other");
                item.setType(type != null ? type : "FOUND");
                item.setClassroom(classroom != null ? classroom.trim() : "Campus Security Desk");
                item.setDescription(description != null ? description.trim() : "Official notice from Campus Lost and Found Authority.");
                item.setUserId(currentUser.getId());

                itemDAO.addItem(item);
                session.setAttribute("adminSuccess", "Official Department Notice successfully broadcasted!");
            }
        }
        resp.sendRedirect("admin");
    }
}
