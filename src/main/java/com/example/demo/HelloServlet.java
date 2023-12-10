package com.example.demo;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;

import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "helloServlet", value = "/hello-servlet")
public class HelloServlet extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");

        PrintWriter writer = response.getWriter();

        try{

            String url = "jdbc:mysql://localhost:3306/students";

            String username = "root";

            String password = "root";

            Class.forName("com.mysql.jdbc.Driver").getDeclaredConstructor().newInstance();

            try (Connection conn = DriverManager.getConnection(url, username, password)){

                writer.println("Connection to ProductDB succesfull!");

            }

        }

        catch(Exception ex){

            writer.println("Connection failed...");

            writer.println(ex);

        }

        finally {

            writer.close();

        }

    }

    public void destroy() {
    }
}