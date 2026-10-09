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

        // Ensure user is logged in and has Admin privileges
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
                    session.setAttribute("adminSuccess", "Item #" + id + " status reset to Open.");
                } else if ("deleteItem".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    itemDAO.deleteItem(id);
                    session.setAttribute("adminSuccess", "Item #" + id + " deleted by department.");
                } else if ("deleteUser".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    userDAO.deleteUser(id);
                    session.setAttribute("adminSuccess", "User #" + id + " account deleted.");
                }
            } catch (Exception e) {
                session.setAttribute("adminError", "Operation could not be completed: " + e.getMessage());
            }
            resp.sendRedirect("admin");
            return;
        }

        // Load all items and users for Department dashboard
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

        req.getRequestDispatcher("admin.jsp").forward(req, resp);
    }
}
