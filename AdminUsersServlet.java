package com.smartbuilding.controller;

import com.smartbuilding.dao.UserDAO;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


public class AdminUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check logged-in user
        User user = (User) request.getSession().getAttribute("user");

        // Only ADMIN can access this page
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve registered users
        UserDAO dao = new UserDAO();
        List<User> users = dao.getAllUsers();

        // Forward to admin-users.jsp
        request.setAttribute("users", users);
        request.getRequestDispatcher("admin-users.jsp").forward(request, response);
    }
}
