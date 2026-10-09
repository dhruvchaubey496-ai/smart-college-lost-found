package com.college.lostfound.controller;

import com.college.lostfound.dao.UserDAO;
import com.college.lostfound.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("register".equals(action)) {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            if (username == null || email == null || password == null || username.trim().isEmpty()) {
                req.setAttribute("errorMessage", "All fields are required.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }

            boolean registered = userDAO.registerUser(username.trim(), email.trim(), password);
            if (registered) {
                req.getSession().setAttribute("successMessage", "Account created successfully. Please login.");
                resp.sendRedirect("login.jsp");
            } else {
                req.setAttribute("errorMessage", "Username or Email already registered.");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
            }
        } else if ("login".equals(action)) {
            String identifier = req.getParameter("identifier");
            String password = req.getParameter("password");

            User user = userDAO.login(identifier, password);
            if (user != null) {
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("successMessage", "Welcome back, @" + user.getUsername() + "!");
                resp.sendRedirect("items");
            } else {
                req.setAttribute("errorMessage", "Invalid Username/Email or Password.");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect("login.jsp?logout=true");
        }
    }
}
