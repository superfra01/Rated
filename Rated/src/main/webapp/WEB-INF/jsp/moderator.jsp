<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Entity.RecensioneBean" %>
<%@ page import="model.Entity.FilmBean" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Includi eventualmente l'header comune se ce l'hai -->
<!-- <jsp:include page="header.jsp" /> -->

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Area Moderatore</title>
    <!-- Link al CSS dedicato (aggiorna il path in base alla tua struttura di progetto) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/moderator.css">
</head>
<body>

<%
    // Recupero dalla sessione la lista delle recensioni segnalate e la mappa dei film
    List<RecensioneBean> recensioni = (List<RecensioneBean>) session.getAttribute("recensioni");
    HashMap<Integer, FilmBean> films = (HashMap<Integer, FilmBean>) session.getAttribute("films");
%>

<div class="moderator-container">
    <h1>Benvenuto nell'Area Moderatore</h1>

    <!-- Sezione che contiene tutte le recensioni segnalate -->
    <div class="scrollable-reviews">
        <%
            if (recensioni != null && !recensioni.isEmpty()) {
        %>
            <table class="reviews-table">
                <thead>
                    <tr>
                        <th>Film</th>
                        <th>Recensore</th>
                        <th>Testo recensione</th>
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    // Ciclo per ogni RecensioneBean
                    for (RecensioneBean rec : recensioni) {
                        FilmBean film = films != null ? films.get(rec.getIdFilm()) : null;
                %>
                    <tr>
                        <td>
                            <%= (film != null) ? film.getNome() : "Titolo non disponibile" %>
                        </td>
                        <td>
                            <%= rec.getEmail() %>
                        </td>
                        <td>
                            <%= rec.getContenuto() %>
                        </td>
                        <td class="actions">
                            <!-- Form per Approvare la recensione (rimuove segnalazioni) -->
                            <form method="post" action="<%= request.getContextPath() %>/ApproveReview">
                                <input type="hidden" name="ReviewUserEmail" value="<%= rec.getEmail() %>" />
                                <input type="hidden" name="idFilm" value="<%= rec.getIdFilm() %>" />
                                <button type="submit" class="btn approve-btn">Approva</button>
                            </form>

                            <!-- Form per Rimuovere la recensione e Avvisare l'utente -->
                            <form method="post" action="<%= request.getContextPath() %>/reportedReviewAndWarn">
                                <input type="hidden" name="ReviewUserEmail" value="<%= rec.getEmail() %>" />
                                <input type="hidden" name="idFilm" value="<%= rec.getIdFilm() %>" />
                                <button type="submit" class="btn remove-btn">Rimuovi e avvisa</button>
                            </form>
                        </td>
                    </tr>
                <%
                    } // fine for
                %>
                </tbody>
            </table>
        <%
            } else {
        %>
            <p class="no-reviews">Non ci sono recensioni segnalate.</p>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
