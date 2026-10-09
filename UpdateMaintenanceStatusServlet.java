package com.smartbuilding.controller;

import com.smartbuilding.dao.MaintenanceRequestDAO;
import com.smartbuilding.model.User;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;


public class UpdateMaintenanceStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        // Check logged-in user
        User user = (User) request.getSession()
                                  .getAttribute("user");

        // Only admin can update status
        if (user == null ||
                !"ADMIN".equalsIgnoreCase(user.getRole())) {

            response.sendRedirect("login.jsp");
            return;
        }

        // Get request ID and new status
        String requestIdText =
                request.getParameter("requestId");

        String status =
                request.getParameter("status");

        if (requestIdText == null || status == null) {

            response.sendRedirect("admin-maintenance");
            return;
        }

        try {

            int requestId =
                    Integer.parseInt(requestIdText);

            MaintenanceRequestDAO dao =
                    new MaintenanceRequestDAO();

            boolean success =
                    dao.updateStatus(requestId, status);

            if (success) {

                response.sendRedirect(
                        "admin-maintenance?updated=true");

            } else {

                response.sendRedirect(
                        "admin-maintenance?updated=false");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect("admin-maintenance");
        }
    }
}