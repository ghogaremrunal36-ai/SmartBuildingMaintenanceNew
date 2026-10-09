package com.smartbuilding.controller;

import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;


public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Destroy the current session
        request.getSession().invalidate();

        // Go back to home page
        response.sendRedirect("index.html");
    }
}