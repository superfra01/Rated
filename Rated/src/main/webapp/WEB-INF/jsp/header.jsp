<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" import="model.Entity.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rated</title>
    <link rel="stylesheet" href="static/css/Header.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body>
    <header>
        <div class="logo">
            <a href="<%= request.getContextPath() %>">
                <span>RATED</span>
            </a>
        </div>
        <div class="search-container">
            <div class="search-bar">
                <input type="text" placeholder="Cerca Film su RATED">
            </div>
            <a href="<%= request.getContextPath() %>/catalogo">
                <button class="catalogue-button">Catalogo</button>
            </a>
        </div>
        <div class="user-icon">
        	<% UtenteBean user = (UtenteBean) request.getSession().getAttribute("user");
            if (user != null) { %>
                <a href="<%= request.getContextPath() %>/profile">
                	<i class="fas fa-user-circle"></i> 
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/login">
                	<i class="fas fa-user-circle"></i>
            	</a>
            <% } %>
        </div>
    </header>
</body>
</html>
