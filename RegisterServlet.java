package com.smartbuilding.controller;

import com.smartbuilding.dao.UserDAO;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;


public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // Check empty fields
        if (name == null || email == null || password == null || phone == null
                || name.trim().isEmpty()
                || email.trim().isEmpty()
                || password.isEmpty()
                || phone.trim().isEmpty()) {

            request.setAttribute("error", "Please fill all fields.");
            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // Check duplicate email
        if (dao.emailExists(email)) {

            request.setAttribute("error",
                    "Email already registered.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
            return;
        }

        // Create user
        User user = new User();

        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPassword(password);
        user.setPhone(phone.trim());

        // Save user
        boolean success = dao.register(user);

        if (success) {

            response.sendRedirect("login.jsp?registered=true");

        } else {

            request.setAttribute("error",
                    "Registration failed. Please try again.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
        }
    }
}