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
    <!-- Inclusione del file CSS dedicato a questa pagina -->
    <link rel="stylesheet" href="static/css/Film.css" />
    <!-- Inclusione di Font Awesome per le icone -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
</head>
<body>

    <!-- Inclusione dell'header (non stilato qui) -->
    <jsp:include page="header.jsp" />

    <%
        // Recupero degli oggetti dalla sessione
        FilmBean film = (FilmBean) session.getAttribute("film");
        List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
        UtenteBean user = (UtenteBean) session.getAttribute("user");
        HashMap<String, ValutazioneBean> valutazioni = 
            (HashMap<String, ValutazioneBean>) session.getAttribute("valutazioni");
    %>

    <!-- Contenitore principale della pagina -->
    <div class="page-container">

        <!-- Sezione centrale che contiene le recensioni a sinistra e i dettagli film a destra -->
        <div class="content-section">
            <!-- Colonna di sinistra (lista recensioni) -->
            <div class="left-column">
                <!-- Barra per la selezione dell’ordinamento -->
                <div class="sort-bar">
                    <p>Sorted by: <span>MostLike</span></p>
                </div>

                <!-- Elenco delle recensioni -->
                <%
                    if (recensioni != null && !recensioni.isEmpty()) {
                        for (RecensioneBean r : recensioni) {
                            String emailRecensore = r.getEmail();
                            String testoRecensione = r.getContenuto();
                            int stelle = r.getValutazione();

                            ValutazioneBean val = (valutazioni != null) 
                                                 ? valutazioni.get(emailRecensore) 
                                                 : null;
                %>
                    <!-- Card di una singola recensione -->
                    <div class="review-card">
                        <!-- Nome utente in alto -->
                        <div class="review-username">
                            <%= emailRecensore %>
                        </div>
                        <!-- Contenuto della recensione -->
                        <div class="review-text">
                            "<%= testoRecensione %>"
                        </div>
                        <!-- Stelline di valutazione -->
                        <div class="review-stars">
                            <%
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= stelle) {
                            %>
                                        <i class="fas fa-star"></i>
                            <%
                                    } else {
                            %>
                                        <i class="far fa-star"></i>
                            <%
                                    }
                                }
                            %>
                        </div>
                        <!-- Sezione like/dislike, contatori, ecc. -->
						<div class="review-actions">
						    <div class="likes-dislikes-count">
						        <i class="fas fa-thumbs-up"></i> <span><%= r.getNLike() %></span> 
						        <span class="separator">|</span> 
						        <i class="fas fa-thumbs-down"></i> <span><%= r.getNDislike() %></span>
						    </div>
						
						    <!-- Se l'utente è recensore, può esprimere like/dislike -->
						    <%
						        if (user != null && "Recensore".equals(user.getTipoUtente())) {
						    %>
						    <div class="vote-buttons">
						        <!-- Pulsante Like -->
						        <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post" style="display: inline;">
						            <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
						            <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
						            <input type="hidden" name="valutazione" value="true" />
						            <button type="submit" class="btn-like" style="background: none; border: none; cursor: pointer;">
						                <i class="fas fa-thumbs-up"></i>
						            </button>
						        </form>
						
						        <!-- Pulsante Dislike -->
						        <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post" style="display: inline;">
						            <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
						            <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
						            <input type="hidden" name="valutazione" value="false" />
						            <button type="submit" class="btn-dislike" style="background: none; border: none; cursor: pointer;">
						                <i class="fas fa-thumbs-down"></i>
						            </button>
						        </form>
						    </div>
						    <%
						            if (val != null) {
						    %>
						        <div class="user-vote">
						            Hai espresso: 
						            <strong><%= val.isLikeDislike() ? "Like" : "Dislike" %></strong>
						        </div>
						    <%
						            }
						        }
						    %>
						</div> <!-- fine .review-actions -->
                    </div> <!-- fine .review-card -->
                <%
                        } // fine for
                    } else {
                %>
                    <p class="no-reviews-msg">Nessuna recensione presente per questo film.</p>
                <%
                    }
                %>
            </div>
            
            <!-- Colonna di destra (dettagli del film) -->
            <div class="right-column">
                <div class="film-details">
                    <img class="film-poster" 
                         src="<%= film.getLocandina() != null ? film.getLocandina() : "img/default.jpg" %>"
                         alt="Locandina di <%= film.getNome() %>" />
                    <h2 class="film-title"><%= film.getNome() %></h2>
                    <p class="film-year-genre">
                        <%= film.getAnno() %> - <%= film.getGeneri() %>
                    </p>
                    <!-- Qui potresti creare delle icone/stelle per la valutazione media generale, se vuoi -->
                    <p class="film-description"><%= film.getTrama() %></p>

                    <!-- Pulsante "Rate it" visibile solo agli utenti con ruolo Recensore -->
                    <%
                        if (user != null && "Recensore".equals(user.getTipoUtente())) {
                    %>
                    <div class="rate-film">
                        <form action="<%= request.getContextPath() %>/aggiungiRecensione" method="get">
                            <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>"/>
                            <button type="submit" class="btn-rate">RATE IT</button>
                        </form>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
