<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Entity.FilmBean" %>
<%@ page import="model.Entity.RecensioneBean" %>
<%@ page import="model.Entity.UtenteBean" %>
<%@ page import="model.Entity.ValutazioneBean" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <title>Film</title>
    <link rel="stylesheet" href="static/css/Film.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <jsp:include page="header.jsp" />

    <%
        FilmBean film = (FilmBean) session.getAttribute("film");
        List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
        UtenteBean user = (UtenteBean) session.getAttribute("user");
        HashMap<String, ValutazioneBean> valutazioni = (HashMap<String, ValutazioneBean>) session.getAttribute("valutazioni");
    %>

    <div class="film-container">
        <div class="film-poster">
            <img src="<%= film.getLocandina() != null ? film.getLocandina() : "img/default.jpg" %>" alt="Locandina di <%= film.getNome() %>">
        </div>
        <div class="film-info">
            <h2><%= film.getNome() %></h2>
            <p><strong>Anno:</strong> <%= film.getAnno() %></p>
            <p><strong>Generi:</strong> <%= film.getGeneri() %></p>
            <p><%= film.getTrama() %></p>
        </div>
    </div>

    <% if (user != null && "Recensore".equals(user.getTipoUtente())) { %>
        <div class="rate-film">
            <form action="<%= request.getContextPath() %>/aggiungiRecensione" method="get">
                <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>">
                <button type="submit" class="btn-rate">Rate it</button>
            </form>
        </div>
    <% } %>

    <div class="reviews-section">
        <h3>Recensioni</h3>
        <% if (recensioni != null && !recensioni.isEmpty()) {
            for (RecensioneBean r : recensioni) {
                String emailRecensore = r.getEmail();
                String testoRecensione = r.getContenuto();
                int stelle = r.getValutazione();
                ValutazioneBean val = (valutazioni != null) ? valutazioni.get(emailRecensore) : null;
        %>
        <div class="review">
            <div class="review-text">
                <p><strong><%= emailRecensore %></strong></p>
                <div class="review-stars">
                    <% for (int i = 0; i < stelle; i++) { %>
                        <i class="fas fa-star"></i>
                    <% } %>
                    <% for (int i = stelle; i < 5; i++) { %>
                        <i class="far fa-star"></i>
                    <% } %>
                </div>
                <p><%= testoRecensione %></p>
            </div>
            <div class="review-likes-dislikes">
                <% if (user != null && "Recensore".equals(user.getTipoUtente())) { %>
                    <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                        <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>">
                        <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>">
                        <input type="hidden" name="valutazione" value="true">
                        <button type="submit" class="btn-like"><i class="fas fa-thumbs-up"></i></button>
                    </form>
                    <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                        <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>">
                        <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>">
                        <input type="hidden" name="valutazione" value="false">
                        <button type="submit" class="btn-dislike"><i class="fas fa-thumbs-down"></i></button>
                    </form>
                <% } %>
                <p><i class="fas fa-thumbs-up"></i> <%= r.getNLike() %></p>
                <p><i class="fas fa-thumbs-down"></i> <%= r.getNDislike() %></p>
            </div>
        </div>
        <% } } else { %>
        <p>Nessuna recensione presente per questo film.</p>
        <% } %>
    </div>

</body>
</html>
