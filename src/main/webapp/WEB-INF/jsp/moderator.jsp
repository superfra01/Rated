<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="model.Entity.RecensioneBean" %>
<%@ page import="model.Entity.FilmBean" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- Includiamo l'header -->
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Area Moderatore</title>
    <!-- Link al CSS dedicato -->
    <link rel="stylesheet" href="static/css/Moderator.css">
</head>
<body>

<%
    // Recupero attributi di sessione
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
                        <!-- Se lo desideri, puoi aggiungere altre info, come # di segnalazioni -->
                        <th>Azioni</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    // Eseguiamo un ciclo per ogni RecensioneBean
                    for(RecensioneBean rec : recensioni) {
                        FilmBean film = films.get(rec.getIdFilm());
                %>
                    <tr>
                        <td>
                            <%-- Stampa il titolo del film dal FilmBean --%>
                            <%= (film != null) ? film.getNome() : "Titolo non disponibile" %>
                        </td>
                        <td>
                            <%-- Stampa email dell'utente che ha scritto la recensione --%>
                            <%= rec.getEmail() %>
                        </td>
                        <td>
                            <%-- Esempio: stampa il testo della recensione (se presente) --%>
                            <%= rec.getContenuto() %>
                        </td>
                        <td>
                            <!-- Form per Approvare la recensione (rimuove segnalazioni) -->
                            <form method="post" action="<%=request.getContextPath()%>/ApproveReview">
                                <input type="hidden" name="ReviewUserEmail" value="<%= rec.getEmail() %>" />
                                <input type="hidden" name="idFilm" value="<%= rec.getIdFilm() %>" />
                                <button type="submit" class="approve-btn">Approva</button>
                            </form>

                            <!-- Form per Rimuovere la recensione e Avvisare l'utente -->
                            <form method="post" action="<%=request.getContextPath()%>/reportedReviewAndWarn">
                                <input type="hidden" name="ReviewUserEmail" value="<%= rec.getEmail() %>" />
                                <input type="hidden" name="idFilm" value="<%= rec.getIdFilm() %>" />
                                <button type="submit" class="remove-btn">Rimuovi e avvisa</button>
                            </form>
                        </td>
                    </tr>
                <%
                    } // end for
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
