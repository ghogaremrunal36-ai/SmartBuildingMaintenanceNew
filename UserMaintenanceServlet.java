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


public class UserMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        
        User user = (User) request.getSession()
                                  .getAttribute("user");

        
        if (user == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        
        MaintenanceRequestDAO dao =
                new MaintenanceRequestDAO();

        List<MaintenanceRequest> requests =
                dao.getRequestsByUser(user.getUserId());

       
        request.setAttribute("requests", requests);

        
        request.getRequestDispatcher(
                "user-maintenance.jsp")
                .forward(request, response);
    }
}