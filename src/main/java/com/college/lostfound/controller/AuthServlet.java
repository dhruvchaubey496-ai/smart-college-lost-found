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

            String result = userDAO.registerUser(username, email, password);
            if ("SUCCESS".equals(result)) {
                req.getSession().setAttribute("successMessage", "Account created successfully for @" + username.trim() + "! Please login.");
                resp.sendRedirect("login.jsp");
            } else {
                req.setAttribute("errorMessage", result);
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
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
                req.setAttribute("errorMessage", "Invalid Username/Email or Password. Try again.");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
        } else if ("googleLogin".equals(action)) {
            String googleEmail = req.getParameter("googleEmail");
            String googleName = req.getParameter("googleName");

            if (googleEmail != null && !googleEmail.trim().isEmpty()) {
                googleEmail = googleEmail.trim().toLowerCase();
                User user = userDAO.getUserByEmail(googleEmail);
                if (user == null) {
                    String baseUsername = (googleName != null && !googleName.trim().isEmpty())
                        ? googleName.trim().toLowerCase().replaceAll("[^a-z0-9]", "_")
                        : googleEmail.split("@")[0].toLowerCase().replaceAll("[^a-z0-9]", "_");
                    if (baseUsername.length() > 14) baseUsername = baseUsername.substring(0, 14);
                    String regUsername = baseUsername;
                    int suffix = 1;
                    while (userDAO.isUsernameTaken(regUsername)) {
                        regUsername = baseUsername + (suffix++);
                    }
                    userDAO.registerUser(regUsername, googleEmail, "GAuth_" + System.currentTimeMillis());
                    user = userDAO.getUserByEmail(googleEmail);
                }

                if (user != null) {
                    HttpSession session = req.getSession();
                    session.setAttribute("user", user);
                    session.setAttribute("successMessage", "Welcome, @" + user.getUsername() + " (Signed in with Google)!");
                    resp.sendRedirect("items");
                    return;
                }
            }
            req.setAttribute("errorMessage", "Google authentication could not be completed. Try standard sign-in.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
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
