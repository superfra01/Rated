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

    <!-- Inclusione dell'header -->
    <jsp:include page="header.jsp" />

    <%
        // Recupero degli oggetti dalla sessione
        FilmBean film = (FilmBean) session.getAttribute("film");
        List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
        UtenteBean user = (UtenteBean) session.getAttribute("user");
        HashMap<String, ValutazioneBean> valutazioni = 
            (HashMap<String, ValutazioneBean>) session.getAttribute("valutazioni");
    %>

    <!-- Se il bean FilmBean è presente, mostriamo i dettagli del film -->
    <div class="film-container">
        <div class="film-poster">
            <!-- Esempio: se hai una locandina salvata come URL nel tuo FilmBean -->
            <img src="<%= film.getLocandina() != null ? film.getLocandina() : "img/default.jpg" %>"
                 alt="Locandina di <%= film.getNome() %>"/>
        </div>
        <div class="film-info">
            <h2><%= film.getNome() %></h2>
            <p><strong>Anno:</strong> <%= film.getAnno() %></p>
            <p><strong>Generi:</strong> <%= film.getGeneri() %></p>
            <p><strong>Descrizione:</strong> <%= film.getTrama() %></p>
        </div>
    </div>

    <!-- Pulsante "Rate it" visibile solo agli utenti con ruolo Recensore -->
    <%
        if (user != null && "Recensore".equals(user.getTipoUtente())) {
    %>
        <div class="rate-film">
            <form action="<%= request.getContextPath() %>/aggiungiRecensione" method="get">
                <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>"/>
                <button type="submit" class="btn-rate">Rate it</button>
            </form>
        </div>
    <%
        }
    %>

    <!-- Elenco delle recensioni relative al film -->
    <div class="reviews-section">
        <h3>Recensioni</h3>
        <%
            if (recensioni != null && !recensioni.isEmpty()) {
                for (RecensioneBean r : recensioni) {
                    // Per comodità, ricaviamo le info principali della recensione
                    String emailRecensore = r.getEmail();
                    String testoRecensione = r.getContenuto();
                    int stelle = r.getValutazione();
                    
                    // Se abbiamo la mappa delle valutazioni, vediamo se ci sono info 
                    // su quante volte è stata valutata 'like' o 'dislike'.
                    // Qui ipotizziamo che tu abbia un modo di calcolare i totali 
                    // (ad es. r.getNumeroLike(), r.getNumeroDislike(), ecc.)
                    // Se non li hai, puoi omettere o gestire diversamente.
                    
                    // Controlliamo se l'utente loggato ha già espresso una valutazione su questa recensione
                    ValutazioneBean val = (valutazioni != null) 
                                         ? valutazioni.get(emailRecensore) 
                                         : null;
        %>
                    <div class="review">
                        <div class="review-text">
                            <p class="review-author">
                                Recensore: <strong><%= emailRecensore %></strong>
                            </p>
                            <p class="review-stars">
                                Voto in stelle: <%= stelle %> / 5
                            </p>
                            <p class="review-body"><%= testoRecensione %></p>
                        </div>

                        <!-- Se l'utente è Recensore, può esprimere like/dislike -->
                        <div class="review-likes-dislikes">
                            <%
                                if (user != null && "Recensore".equals(user.getTipoUtente())) {
                            %>
                                <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                                    <!-- Like -->
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="true" />
                                    <button type="submit" class="btn-like">Like</button>
                                </form>

                                <form action="<%= request.getContextPath() %>/aggiungiValutazione" method="post">
                                    <!-- Dislike -->
                                    <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />
                                    <input type="hidden" name="emailRecensore" value="<%= emailRecensore %>" />
                                    <input type="hidden" name="valutazione" value="false" />
                                    <button type="submit" class="btn-dislike">Dislike</button>
                                </form>

                                <!-- Esempio di come potresti mostrare se l’utente ha già messo like/dislike -->
                                <%
                                    if (val != null) {
                                        if (val.isLikeDislike()) {
                                %>
                                            <p class="user-vote">Hai espresso: Like</p>
                                <%
                                        } else {
                                %>
                                            <p class="user-vote">Hai espresso: Dislike</p>
                                <%
                                        }
                                    }
                                %>
                            <%
                                }
                            %>

                            <!-- Esempio di contatori di like e dislike, se presenti nel RecensioneBean -->
                            <p class="likes-count">Like: <%= r.getNLike() %></p>
                            <p class="dislikes-count">Dislike: <%= r.getNDislike() %></p>
                        </div>
                    </div>
        <%
                } // fine for
            } else {
        %>
                <p>Nessuna recensione presente per questo film.</p>
        <%
            }
        %>
    </div>

</body>
</html>
