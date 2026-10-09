package com.college.lostfound.controller;

import com.college.lostfound.dao.ChatDAO;
import com.college.lostfound.dao.ItemDAO;
import com.college.lostfound.model.Item;
import com.college.lostfound.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/items")
public class ItemServlet extends HttpServlet {
    private ItemDAO itemDAO = new ItemDAO();
    private ChatDAO chatDAO = new ChatDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("view".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Item item = itemDAO.getItemById(id);
                if (item != null) {
                    req.setAttribute("item", item);

                    HttpSession session = req.getSession(false);
                    User currentUser = (session != null) ? (User) session.getAttribute("user") : null;
                    if (currentUser != null && currentUser.getId() == item.getUserId()) {
                        List<User> partners = chatDAO.getChatPartnersForItem(item.getId(), currentUser.getId());
                        req.setAttribute("chatPartners", partners);
                    }

                    req.getRequestDispatcher("item-details.jsp").forward(req, resp);
                    return;
                }
            } catch (Exception e) {}
            resp.sendRedirect("items");
            return;
        }

        // List & filter items
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        String type = req.getParameter("type");

        List<Item> items = itemDAO.getItems(keyword, category, type);
        req.setAttribute("items", items);
        req.setAttribute("keyword", keyword != null ? keyword : "");
        req.setAttribute("selectedCategory", category != null ? category : "ALL");
        req.setAttribute("selectedType", type != null ? type : "ALL");
        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String title = req.getParameter("title");
        String category = req.getParameter("category");
        String type = req.getParameter("type");
        String classroom = req.getParameter("classroom");
        String description = req.getParameter("description");

        if (title == null || classroom == null || description == null || title.trim().isEmpty()) {
            req.setAttribute("errorMessage", "Title, Classroom, and Description are required.");
            req.getRequestDispatcher("post-item.jsp").forward(req, resp);
            return;
        }

        Item item = new Item();
        item.setTitle(title.trim());
        item.setCategory(category);
        item.setType(type);
        item.setClassroom(classroom.trim());
        item.setDescription(description.trim());
        item.setUserId(user.getId());

        boolean ok = itemDAO.addItem(item);
        if (ok) {
            resp.sendRedirect("thank-you.jsp");
        } else {
            req.setAttribute("errorMessage", "Failed to publish notice. Please try again.");
            req.getRequestDispatcher("post-item.jsp").forward(req, resp);
        }
    }
}
