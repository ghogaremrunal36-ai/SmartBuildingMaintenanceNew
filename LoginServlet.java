package com.smartbuilding.controller;

import com.smartbuilding.dao.UserDAO;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;


public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("========== LOGIN TEST ==========");
        System.out.println("Email received: " + email);
        System.out.println("Password received: " + password);

        if (email == null || password == null ||
                email.trim().isEmpty() || password.isEmpty()) {

            System.out.println("ERROR: Empty email or password");

            request.setAttribute("error",
                    "Please enter email and password.");

            request.getRequestDispatcher("login.jsp")
                    .forward(request, response);

            return;
        }

        UserDAO dao = new UserDAO();

        User user = dao.login(email.trim(), password);

        if (user != null) {

            System.out.println("LOGIN SUCCESS!");
            System.out.println("User: " + user.getName());
            System.out.println("Role: " + user.getRole());

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {

                response.sendRedirect("admin-dashboard.jsp");

            } else {

                response.sendRedirect("user-dashboard.jsp");
            }

        } else {

            System.out.println("LOGIN FAILED - USER NOT FOUND");

            request.setAttribute("error",
                    "Invalid email or password.");

            request.getRequestDispatcher("login.jsp")
                    .forward(request, response);
        }
    }
}