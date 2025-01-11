<%@ page import="java.util.List" %>
<%@ page import="model.Entity.FilmBean" %>
<%@ page import="model.Entity.UtenteBean" %>

<%
    // Recupero i film dalla sessione
    List<FilmBean> films = (List<FilmBean>) session.getAttribute("films");
    if (films == null) {
        // Evitiamo NullPointerException
        films = java.util.Collections.emptyList();
    }

    // Recupero l'utente dalla sessione (per stabilire se è gestore)
    UtenteBean user = (UtenteBean) session.getAttribute("user");

    // Gestisco eventuali parametri di sorting passati via GET (sort=asc o sort=desc)
    String sort = request.getParameter("sort");
    if (sort != null && !sort.isEmpty()) {
        if (sort.equals("asc")) {
            // ordinamento per valutazione crescente
            films.sort((f1, f2) -> Integer.compare(f1.getValutazione(), f2.getValutazione()));
        } else if (sort.equals("desc")) {
            // ordinamento per valutazione decrescente
            films.sort((f1, f2) -> Integer.compare(f2.getValutazione(), f1.getValutazione()));
        }
    }
%>

<!-- Includo l'header -->
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <title>Catalogo</title>
    <!-- Link al file CSS dedicato -->
    <link rel="stylesheet" href="static/css/Catalogo.css" />
</head>
<body>

<div class="catalog-container">
    <div class="catalog-header">
        <!-- Selettore di ordinamento rating -->
        <div class="sorting">
            <!-- Esempio di link per ordinare asc/desc: -->
            <span>Sorted by: Rating score</span>
            <a href="?sort=desc">decrescente</a>
            <a href="?sort=asc">crescente</a>
        </div>

        <!-- Mostro il pulsante di aggiunta film solo se l'utente è un gestore del catalogo -->
        <%
            if (user != null && "GestoreCatalogo".equals(user.getTipoUtente())) {
        %>
            <button class="add-film-btn" onclick="openAddFilmForm()">Aggiungi film al catalogo</button>
        <%
            }
        %>
    </div>

    <!-- Griglia dei film -->
    <div class="film-grid">
        <%
            for (FilmBean film : films) {
                // Costruiamo un url di dettaglio, ad esempio film.jsp?id=...
                String dettaglioUrl = "film.jsp?id=" + film.getIdFilm();
        %>
            <div class="film-card" onclick="window.location.href='<%=dettaglioUrl%>'">
                <!-- Se volessi mostrare la locandina come immagine, potresti voler usare un
                     Base64 encoding per i byte[] (o servire l'immagine da un'altra servlet).
                     Qui, per semplicità, assumiamo non serva. 
                     Se invece la stai già servendo via src, potresti fare:
                     
                     <img src="data:image/jpeg;base64,<%= Base64.getEncoder().encodeToString(film.getLocandina()) %>" alt="Locandina" />
                -->
                <div class="film-poster">
                    <!-- Placeholder o eventuale immagine in base64 -->
                    <img src="<%= request.getContextPath() %>/images/placeholder.jpg" alt="Locandina" />
                </div>
                <div class="film-info">
                    <h3><%= film.getNome() %></h3>
                    <p class="film-genres"><%= film.getGeneri() %></p>
                    <div class="film-rating">
                        <%
                            // Visualizziamo un tot di stelline pari alla valutazione 
                            // (oppure puoi usare una libreria di icone come FontAwesome)
                            int stars = film.getValutazione();
                            for (int i=0; i<stars; i++) {
                                out.print("* ");
                            }
                        %>
                    </div>
                </div>
            </div>
        <%
            }
        %>
    </div>
</div>

<!-- Se l'utente è un gestore, mostriamo l'overlay per aggiungere un film -->
<%
    if (user != null && "GestoreCatalogo".equals(user.getTipoUtente())) {
%>
<div id="addFilmOverlay" class="overlay">
    <div class="overlay-content">
        <span class="close-btn" onclick="closeAddFilmForm()">&times;</span>
        <h2>Aggiungi un nuovo film</h2>
        <form action="<%= request.getContextPath() %>/addFilm" method="post" enctype="multipart/form-data">
            <label for="nomeFilm">Nome:</label>
            <input type="text" name="nomeFilm" id="nomeFilm" required />

            <label for="annoFilm">Anno:</label>
            <input type="number" name="annoFilm" id="annoFilm" required />

            <label for="durataFilm">Durata (min):</label>
            <input type="number" name="durataFilm" id="durataFilm" required />

            <label for="generiFilm">Generi:</label>
            <input type="text" name="generiFilm" id="generiFilm" required />

            <label for="registaFilm">Regista:</label>
            <input type="text" name="registaFilm" id="registaFilm" required />

            <label for="attoriFilm">Attori:</label>
            <input type="text" name="attoriFilm" id="attoriFilm" required />

            <label for="locandinaFilm">Locandina (file immagine):</label>
            <input type="file" name="locandinaFilm" id="locandinaFilm" accept="image/*" />

            <button type="submit">Aggiungi</button>
        </form>
    </div>
</div>
<%
    }
%>

<script>
    function openAddFilmForm() {
        document.getElementById("addFilmOverlay").style.display = "block";
    }

    function closeAddFilmForm() {
        document.getElementById("addFilmOverlay").style.display = "none";
    }
</script>

</body>
</html>
