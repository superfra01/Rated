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
    <!-- Inclusione del file JavaScript -->
    <script>
        function toggleReviewForm() {
            const form = document.getElementById('add-review-form');
            form.classList.toggle('hidden');
        }
    </script>
</head>
<body>

    <!-- Inclusione dell'header (non stilato qui) -->
    <jsp:include page="header.jsp" />

    <%
        // Recupero degli oggetti dalla sessione
        FilmBean film = (FilmBean) session.getAttribute("film");
        List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
        UtenteBean user = (UtenteBean) session.getAttribute("user");
        HashMap<String, ValutazioneBean> valutazioni = (HashMap<String, ValutazioneBean>) session.getAttribute("valutazioni");
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
                            String titoloRecensione = r.getTitolo();
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
                        <!-- Titolo della recensione -->
                        <div class="review-title">
                            "<%= titoloRecensione %>"
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
                        <div class="review-actions" id="review-actions-<%= r.getIdRecensione() %>">
                            <div class="likes-dislikes-count" id="counts-<%= r.getIdRecensione() %>">
                                <i class="fas fa-thumbs-up"></i> <span id="like-count-<%= r.getIdRecensione() %>"><%= r.getNLike() %></span> 
                                <span class="separator">|</span> 
                                <i class="fas fa-thumbs-down"></i> <span id="dislike-count-<%= r.getIdRecensione() %>"><%= r.getNDislike() %></span>
                            </div>

                            <!-- Pulsanti Like e Dislike con form -->
                            <%
                                String currentVote = null;
                                if (val != null) {
                                    currentVote = val.isLikeDislike() ? "like" : "dislike";
                                }
                            %>
                            <div class="vote-buttons">
                                <!-- Pulsante Like -->
                                <form action="<%= request.getContextPath() %>/VoteReview" method="post" class="vote-form">
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="true" />
                                    <button type="submit" class="btn-like <%= "like".equals(currentVote) ? "active" : "" %>">
                                        <i class="fas fa-thumbs-up"></i>
                                    </button>
                                </form>

                                <!-- Pulsante Dislike -->
                                <form action="<%= request.getContextPath() %>/VoteReview" method="post" class="vote-form">
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="false" />
                                    <button type="submit" class="btn-dislike <%= "dislike".equals(currentVote) ? "active" : "" %>">
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
            
            <!-- Colonna di destra (dettagli film) -->
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
                        <button type="button" class="btn-rate" onclick="toggleReviewForm()">RATE IT</button>
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Form per aggiungere una nuova recensione (nascosto di default) -->
                <div id="add-review-form" class="add-review-form hidden">
                    <h3>Aggiungi una Recensione</h3>
                    <form action="<%= request.getContextPath() %>/ValutaFilm" method="post">
                        <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                        <div class="form-group">
                            <label for="titolo">Titolo:</label>
                            <input type="text" id="titolo" name="titolo" required />
                        </div>
                        <div class="form-group">
                            <label for="recensione">Recensione:</label>
                            <textarea id="recensione" name="recensione" rows="4" required></textarea>
                        </div>
                        <div class="form-group">
                            <label for="valutazione">Valutazione (1-5):</label>
                            <input type="number" id="valutazione" name="valutzione" min="1" max="5" required />
                        </div>
                        <button type="submit" class="btn-submit">Invia Recensione</button>
                        <button type="button" class="btn-cancel" onclick="toggleReviewForm()">Annulla</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
