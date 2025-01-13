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
    <meta charset="UTF-8">
    <title>Film</title>
    <link rel="stylesheet" href="static/css/Film.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />
    <script>
        // Funzione per votare una recensione
        function voteReview(idFilm, emailRecensore, valutazione) {
            const formData = new URLSearchParams();
            formData.append("idFilm", idFilm);
            formData.append("emailRecensore", emailRecensore);
            formData.append("valutazione", valutazione);

            fetch("VoteReview", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: formData.toString()
            })
            .then(response => {
                if (response.ok) {
                    window.location.reload();
                } else {
                    alert("Errore durante la votazione. Riprova più tardi.");
                }
            })
            .catch(error => {
                console.error("Errore nella richiesta:", error);
                alert("Errore durante la votazione. Riprova più tardi.");
            });
        }

        // Funzioni per gestire l'overlay del form di recensione
        function showReviewForm() {
            document.getElementById('reviewOverlay').style.display = 'flex';
        }

        function hideReviewForm() {
            document.getElementById('reviewOverlay').style.display = 'none';
        }

        // Funzione per validare il form prima dell'invio
        function validateReviewForm() {
            const titolo = document.getElementById('titolo').value.trim();
            const recensione = document.getElementById('recensione').value.trim();
            const valutazione = document.getElementById('valutazione').value;

            if (titolo === "" || recensione === "" || valutazione === "") {
                alert("Per favore, completa tutti i campi.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

    <jsp:include page="header.jsp" />

    <%
        FilmBean film = (FilmBean) session.getAttribute("film");
        List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
        UtenteBean user = (UtenteBean) session.getAttribute("user");
        HashMap<String, ValutazioneBean> valutazioni = (HashMap<String, ValutazioneBean>) session.getAttribute("valutazioni");
    %>

    <div class="page-container">
        <div class="content-section">
            <div class="left-column">
                <div class="sort-bar">
                    <!-- Eventuale barra di ordinamento -->
                </div>

                <% if (recensioni != null && !recensioni.isEmpty()) {
                    for (RecensioneBean r : recensioni) {
                        String emailRecensore = r.getEmail();
                        String titoloRecensione = r.getTitolo();
                        String testoRecensione = r.getContenuto();
                        int stelle = r.getValutazione();
                        ValutazioneBean val = (valutazioni != null) ? valutazioni.get(emailRecensore) : null;
                %>

                <div class="review-card">
                    <div class="review-username">
                        <%= emailRecensore %>
                    </div>
                    <div class="review-title">
                        <%= titoloRecensione %>
                    </div>
                    <div class="review-text">
                        "<%= testoRecensione %>"
                    </div>
                    <div class="review-stars">
                        <% for (int i = 1; i <= 5; i++) {
                            if (i <= stelle) { %>
                                <i class="fas fa-star"></i>
                        <% } else { %>
                                <i class="far fa-star"></i>
                        <% }} %>
                    </div>
                    <div class="review-actions">
                        <div class="likes-dislikes">
                            <button class="btn-like <%= (val != null && val.isLikeDislike()) ? "active" : "" %>" 
                                    <%= (user != null && "RECENSORE".equals(user.getTipoUtente())) ? "onclick=\"voteReview('" + film.getIdFilm() + "', '" + emailRecensore + "', true)\"" : "disabled" %>>
                                <i class="fas fa-thumbs-up"></i> <span><%= r.getNLike() %></span>
                            </button>
                            <button class="btn-dislike <%= (val != null && !val.isLikeDislike()) ? "active" : "" %>" 
                                    <%= (user != null && "RECENSORE".equals(user.getTipoUtente())) ? "onclick=\"voteReview('" + film.getIdFilm() + "', '" + emailRecensore + "', false)\"" : "disabled" %>>
                                <i class="fas fa-thumbs-down"></i> <span><%= r.getNDislike() %></span>
                            </button>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <p class="no-reviews-msg">Nessuna recensione presente per questo film.</p>
                <% } %>
            </div>

            <div class="right-column">
                <div class="film-details">
                    <img class="film-poster" 
                         src="<%= film.getLocandina() != null ? film.getLocandina() : "img/default.jpg" %>"
                         alt="Locandina di <%= film.getNome() %>" />
                    <h2 class="film-title"><%= film.getNome() %></h2>
                    <p class="film-year-genre">
                        <%= film.getAnno() %> - <%= film.getGeneri() %>
                    </p>
                    <p class="film-description"><%= film.getTrama() %></p>

                    <% if (user != null && "RECENSORE".equals(user.getTipoUtente())) { %>
                    <div class="rate-film">
                        <button type="button" class="btn-rate" onclick="showReviewForm()">RATE IT</button>
                    </div>
                    <% } else { %>
                    <div class="rate-film">
                        <button type="button" class="btn-rate" disabled>RATE IT</button>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Overlay Form per la Pubblicazione della Recensione -->
    <div id="reviewOverlay" class="overlay">
        <div class="overlay-content">
            <span class="close-btn" onclick="hideReviewForm()">&times;</span>
            <h2>Pubblica una Recensione</h2>
            <form action="<%= request.getContextPath() %>/ValutaFilm" method="post" onsubmit="return validateReviewForm()">
                <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                
                <label for="titolo">Titolo:</label>
                <input type="text" id="titolo" name="titolo" required />

                <label for="recensione">Recensione:</label>
                <textarea id="recensione" name="recensione" rows="5" required></textarea>

                <label for="valutazione">Valutazione:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="valutzione" value="5" /><label for="star5" title="5 stelle"></label>
                    <input type="radio" id="star4" name="valutzione" value="4" /><label for="star4" title="4 stelle"></label>
                    <input type="radio" id="star3" name="valutzione" value="3" /><label for="star3" title="3 stelle"></label>
                    <input type="radio" id="star2" name="valutzione" value="2" /><label for="star2" title="2 stelle"></label>
                    <input type="radio" id="star1" name="valutzione" value="1" /><label for="star1" title="1 stella"></label>
                </div>

                <button type="submit" class="btn-submit">Pubblica</button>
            </form>
        </div>
    </div>

</body>
</html>
