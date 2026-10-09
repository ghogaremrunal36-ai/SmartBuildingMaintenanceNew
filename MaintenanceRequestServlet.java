package com.smartbuilding.controller;

import com.smartbuilding.dao.MaintenanceRequestDAO;
import com.smartbuilding.model.MaintenanceRequest;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;


public class MaintenanceRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Get logged-in user from session
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        // Check fields
        if (title == null || category == null || description == null
                || title.trim().isEmpty()
                || category.trim().isEmpty()
                || description.trim().isEmpty()) {

            request.setAttribute("error",
                    "Please fill all fields.");

            request.getRequestDispatcher("maintenance-request.jsp")
                    .forward(request, response);

            return;
        }

        // Create request object
        MaintenanceRequest maintenanceRequest =
                new MaintenanceRequest();

        maintenanceRequest.setUserId(user.getUserId());
        maintenanceRequest.setTitle(title.trim());
        maintenanceRequest.setCategory(category.trim());
        maintenanceRequest.setDescription(description.trim());

        // Save to database
        MaintenanceRequestDAO dao =
                new MaintenanceRequestDAO();

        boolean success = dao.addRequest(maintenanceRequest);

        if (success) {

            // Redirect back to user dashboard
            response.sendRedirect("user-dashboard.jsp?requestSubmitted=true");

        } else {

            request.setAttribute("error",
                    "Request could not be submitted.");

            request.getRequestDispatcher("maintenance-request.jsp")
                    .forward(request, response);
        }
    }
}