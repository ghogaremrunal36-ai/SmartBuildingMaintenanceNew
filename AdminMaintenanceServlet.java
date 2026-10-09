package com.smartbuilding.controller;

import com.smartbuilding.dao.MaintenanceRequestDAO;
import com.smartbuilding.model.MaintenanceRequest;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;


public class AdminMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check logged-in user
        User user = (User) request.getSession()
                                  .getAttribute("user");

        // Only ADMIN can access this page
        if (user == null ||
                !"ADMIN".equalsIgnoreCase(user.getRole())) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get all maintenance requests
        MaintenanceRequestDAO dao =
                new MaintenanceRequestDAO();

        List<MaintenanceRequest> requests =
                dao.getAllRequests();

        // Send list to JSP
        request.setAttribute("requests", requests);

        request.getRequestDispatcher(
                "admin-maintenance.jsp")
                .forward(request, response);
    }
}