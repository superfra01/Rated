<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Entity.UtenteBean" %>
<%@ page import="model.Entity.RecensioneBean" %>
<!-- Includi l’header comune -->
<%@ include file="header.jsp" %>

<%
    // Recupero i bean dalla sessione
    UtenteBean visitedUser = (UtenteBean) session.getAttribute("visitedUser");
    UtenteBean currentUser = (UtenteBean) session.getAttribute("user");
    List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
    HashMap<Integer, FilmBean> filmMap = (HashMap<Integer, FilmBean>) session.getAttribute("films"); // Recupero la HashMap

    if (visitedUser == null) {
        // Se visitedUser non è settato, puoi gestire l'errore o reindirizzare
        response.sendRedirect(request.getContextPath() + "/home"); 
        return; // esci subito
    }

    // Calcolo del reputation score = somma (upvote - downvote) di tutte le recensioni
    int reputationScore = 0;
    if (recensioni != null) {
        for (RecensioneBean rec : recensioni) {
            reputationScore += (rec.getNLike() - rec.getNDislike());
        }
    }

    // Controllo se l'utente che visualizza è proprietario del profilo
    boolean isProfileOwner = false;
    if (currentUser != null && visitedUser.getUsername().equals(currentUser.getUsername())) {
        isProfileOwner = true;
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Profilo di <%= visitedUser.getUsername() %></title>
    <!-- FontAwesome per le icone (ad es. cestino) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="static/css/Profile.css">
</head>
<body>

<div class="profile-container">
    <!-- Informazioni utente: icona, username, biografia, reputation -->
    <div class="user-info">
        <%
            String iconaBase64 = "";
            if (visitedUser.getIcona() != null) {
                byte[] iconaBytes = visitedUser.getIcona();
                if (iconaBytes.length > 0) {
                    iconaBase64 = java.util.Base64.getEncoder().encodeToString(iconaBytes);
                }
            }
        %>
        <img src="data:image/png;base64,<%= iconaBase64 %>" alt="User Icon" />

        <div>
            <div class="username"><%= visitedUser.getUsername() %></div>
            <div class="biografia"><%= visitedUser.getBiografia() == null ? "" : visitedUser.getBiografia() %></div>
            <div class="reputation">Reputation Score: <%= reputationScore %></div>
        </div>
    </div>

    <%
        if (isProfileOwner) {
    %>
    <div class="buttons-container">
        <button onclick="openOverlay('changePasswordOverlay')">Cambia Password</button>
        <button onclick="openOverlay('changeProfileOverlay')">Modifica Profilo</button>
    </div>
    <% 
        }
    %>

    <div class="reviews-container">
        <h3>Recensioni pubblicate:</h3>
        <%
            if (recensioni != null && !recensioni.isEmpty() && filmMap != null) {
                for (RecensioneBean review : recensioni) {
                    FilmBean film = filmMap.get(review.getIdFilm());
                    String nomeFilm = (film != null) ? film.getNome() : "Film non trovato";
        %>
        <div class="review-item">
            <span class="film-name"><%= nomeFilm %></span>
            <% if (isProfileOwner) { %>
                <a href="#"
                   onclick="if(confirm('Sei sicuro di voler eliminare questa recensione?')) { 
                                document.getElementById('deleteReviewForm_<%= review.getIdFilm() %>').submit();
                            }"
                >
                    <i class="fas fa-trash-alt delete-icon"></i>
                </a>
                <form id="deleteReviewForm_<%= review.getIdFilm() %>" 
                      method="post" 
                      action="<%= request.getContextPath() %>/profile">
                    <input type="hidden" name="operationType" value="ReviewDelete"/>
                    <input type="hidden" name="filmId" value="<%= review.getIdFilm() %>" />
                </form>
            <% } %>
        </div>
        <%
                }
            } else {
        %>
        <p>Nessuna recensione pubblicata.</p>
        <%
            }
        %>
    </div>
</div>

<% if (isProfileOwner) { %>

<div class="overlay" id="changePasswordOverlay">
    <div class="modal">
        <button class="close-modal" onclick="closeOverlay('changePasswordOverlay')">&times;</button>
        <h2>Cambia Password</h2>
        <form method="post" action="<%= request.getContextPath() %>/profile">
            <input type="hidden" name="operationType" value="PasswordModify" />
            <input type="hidden" name="email" value="<%= visitedUser.getEmail() %>" />

            <label for="newPassword">Nuova Password</label>
            <input type="password" id="newPassword" name="password" required />

            <button type="submit">Conferma</button>
        </form>
    </div>
</div>

<div class="overlay" id="changeProfileOverlay">
    <div class="modal">
        <button class="close-modal" onclick="closeOverlay('changeProfileOverlay')">&times;</button>
        <h2>Modifica Profilo</h2>
        <form method="post" action="<%= request.getContextPath() %>/profile" enctype="multipart/form-data">
            <input type="hidden" name="operationType" value="ProfileModify" />

            <label for="username">Username</label>
            <input type="text" id="username" name="username" value="<%= visitedUser.getUsername() %>" required />

            <label for="email">Email</label>
            <input type="text" id="email" name="email" value="<%= visitedUser.getEmail() %>" required />

            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Nuova password..." required />

            <label for="biography">Biografia</label>
            <textarea id="biography" name="biography" rows="3"><%= visitedUser.getBiografia() %></textarea>

            <label for="icon">Icona (file immagine)</label>
            <input type="file" id="icon" name="icon" accept="image/*" />

            <button type="submit">Salva Modifiche</button>
        </form>
    </div>
</div>

<% } %>

<script>
    function openOverlay(overlayId) {
        document.getElementById(overlayId).style.display = 'flex';
    }
    function closeOverlay(overlayId) {
        document.getElementById(overlayId).style.display = 'none';
    }
</script>

</body>
</html>