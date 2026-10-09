package com.college.lostfound.controller;

import com.college.lostfound.dao.ChatDAO;
import com.college.lostfound.dao.ItemDAO;
import com.college.lostfound.dao.UserDAO;
import com.college.lostfound.model.Item;
import com.college.lostfound.model.Message;
import com.college.lostfound.model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/chat")
public class ChatServlet extends HttpServlet {
    private ChatDAO chatDAO = new ChatDAO();
    private ItemDAO itemDAO = new ItemDAO();
    private UserDAO userDAO = new UserDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            resp.sendRedirect("login.jsp?loginRequired=true");
            return;
        }

        try {
            String itemIdParam = req.getParameter("itemId");
            String partnerIdParam = req.getParameter("partnerId");

            if (itemIdParam == null) {
                resp.sendRedirect("items");
                return;
            }

            int itemId = Integer.parseInt(itemIdParam);
            int partnerId = (partnerIdParam != null && !partnerIdParam.isEmpty()) ? Integer.parseInt(partnerIdParam) : 0;
            String format = req.getParameter("format");

            if ("json".equals(format)) {
                List<Message> list;
                if (currentUser.isAdmin() && partnerId == 0) {
                    list = chatDAO.getAllMessagesForItem(itemId);
                } else {
                    list = chatDAO.getChatHistory(itemId, currentUser.getId(), partnerId);
                }
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(gson.toJson(list));
                return;
            }

            Item item = itemDAO.getItemById(itemId);
            if (item == null) {
                req.getSession().setAttribute("errorMessage", "The notice you are trying to view no longer exists.");
                resp.sendRedirect("items");
                return;
            }

            String partnerUsername = (partnerId > 0) ? userDAO.getUsernameById(partnerId) : "All Claimants (Admin View)";

            req.setAttribute("item", item);
            req.setAttribute("partnerId", partnerId);
            req.setAttribute("partnerUsername", partnerUsername);

            req.getRequestDispatcher("/chat.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setContentType("text/html");
            resp.getWriter().println("<!DOCTYPE html><html><body style='font-family:sans-serif;padding:30px;'>");
            resp.getWriter().println("<h2 style='color:#b91c1c;'>Chat Diagnostic Log</h2>");
            resp.getWriter().println("<p>An exception occurred while loading the chat room:</p><pre style='background:#f1f5f9;padding:15px;border-radius:6px;'>");
            e.printStackTrace(resp.getWriter());
            resp.getWriter().println("</pre><br><a href='items' style='color:#0284c7;font-weight:bold;'>&larr; Return to Campus Notice Board</a>");
            resp.getWriter().println("</body></html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        int senderId = 0;
        if (currentUser != null) {
            senderId = currentUser.getId();
        } else {
            // Fallback if mobile browser drops cookie during AJAX request
            String senderIdStr = req.getParameter("senderId");
            if (senderIdStr != null && !senderIdStr.isEmpty()) {
                try {
                    senderId = Integer.parseInt(senderIdStr);
                } catch (Exception ex) {}
            }
        }

        if (senderId <= 0) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("text/plain");
            resp.getWriter().write("Session expired. Please refresh and log in.");
            return;
        }

        try {
            int itemId = Integer.parseInt(req.getParameter("itemId"));
            int partnerId = Integer.parseInt(req.getParameter("partnerId"));
            String message = req.getParameter("message");

            if (message != null && !message.trim().isEmpty()) {
                boolean saved = chatDAO.saveMessage(itemId, senderId, partnerId, message.trim());
                if (!saved) {
                    resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    resp.setContentType("text/plain");
                    resp.getWriter().write("Failed to save message in database.");
                    return;
                }
            }

            resp.setContentType("application/json");
            resp.getWriter().write("{\"status\":\"ok\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.setContentType("text/plain");
            resp.getWriter().write("Error: " + e.getMessage());
        }
    }
}
