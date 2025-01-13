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
        <!-- Barra superiore (titolo "RATED" e barra di ricerca) -->
        <div class="top-bar">
            <h1>RATED</h1>
            <input type="text" class="search-bar" placeholder="Search on RATED" />
        </div>

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
                        <!-- Stelline di valutazione (o numero stelle) -->
                        <div class="review-stars">
                            <!-- Qui puoi sostituire con vere icone stella se vuoi -->
                            Voto: <%= stelle %>/5
                        </div>
                        <!-- Sezione like/dislike, contatori, ecc. -->
                        <div class="review-actions">
                            <div class="likes-dislikes-count">
                                <span><%= r.getNLike() %></span> 
                                <span class="separator">|</span> 
                                <span><%= r.getNDislike() %></span>
                            </div>

                            <!-- Se l'utente è recensore, può esprimere like/dislike -->
                            <%
                                if (user != null && "Recensore".equals(user.getTipoUtente())) {
                            %>
                            <div class="vote-buttons">
                                <!-- Pulsante Like -->
                                <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="true" />
                                    <button type="submit" class="btn-like">Like</button>
                                </form>

                                <!-- Pulsante Dislike -->
                                <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="false" />
                                    <button type="submit" class="btn-dislike">Dislike</button>
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
