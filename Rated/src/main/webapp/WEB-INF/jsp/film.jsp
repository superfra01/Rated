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

        // Funzioni per gestire l'overlay del form di modifica film
        function showModifyForm() {
            document.getElementById('modifyOverlay').style.display = 'flex';
        }

        function hideModifyForm() {
            document.getElementById('modifyOverlay').style.display = 'none';
        }

        // Funzione per validare il form di recensione prima dell'invio
        function validateReviewForm() {
            const titolo = document.getElementById('titolo').value.trim();
            const recensione = document.getElementById('recensione').value.trim();
            const valutazione = document.querySelector('input[name="valutazione"]:checked');

            if (titolo === "" || recensione === "" || !valutazione) {
                alert("Per favore, completa tutti i campi.");
                return false;
            }
            return true;
        }

        // Funzione per validare il form di modifica film prima dell'invio
        function validateModifyForm() {
            const nome = document.getElementById('nomeFilm').value.trim();
            const regista = document.getElementById('registaFilm').value.trim();
            const anno = document.getElementById('annoFilm').value.trim();
            const generi = document.getElementById('generiFilm').value.trim();
            const trama = document.getElementById('tramaFilm').value.trim();
            const durata = document.getElementById('durataFilm').value.trim();
            const attori = document.getElementById('attoriFilm').value.trim();
            // La locandina è opzionale, quindi non è necessario verificarla

            if (nome === "" || regista === "" || anno === "" || generi === "" || trama === "" || durata === "" || attori === "") {
                alert("Per favore, completa tutti i campi obbligatori.");
                return false;
            }

            if (isNaN(anno) || isNaN(durata)) {
                alert("Anno e durata devono essere valori numerici.");
                return false;
            }

            return true;
        }

        // Funzione per eliminare un film con conferma
        function deleteFilm(idFilm) {
            if (confirm("Sei sicuro di voler eliminare questo film? Questa azione non può essere annullata.")) {
                const formData = new URLSearchParams();
                formData.append("idFilm", idFilm);

                fetch("deleteFilm", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData.toString()
                })
                .then(response => {
                    if (response.ok) {
                        window.location.href = "<%= request.getContextPath() %>/catalogo";
                    } else {
                        response.text().then(text => alert(text));
                    }
                })
                .catch(error => {
                    console.error("Errore nella richiesta:", error);
                    alert("Errore durante l'eliminazione. Riprova più tardi.");
                });
            }
        }
        // Funzione per reportare una recensione
        function reportReview(idFilm, emailRecensore) {
            if (confirm("Sei sicuro di voler segnalare questa recensione?")) {
                const formData = new URLSearchParams();
                formData.append("idFilm", idFilm);
                formData.append("reviewerEmail", emailRecensore);

                fetch("ReportReview", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: formData.toString()
                })
                .then(response => {
                    if (response.ok) {
                        alert("Recensione segnalata con successo.");
                    } else {
                        alert("Errore durante la segnalazione. Riprova più tardi.");
                    }
                })
                .catch(error => {
                    console.error("Errore nella richiesta:", error);
                    alert("Errore durante la segnalazione. Riprova più tardi.");
                });
            }
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
				   HashMap<String, String> users = (HashMap<String, String>) session.getAttribute("users");
				
				   for (RecensioneBean r : recensioni) {
				       String emailRecensore = r.getEmail();
				       String titoloRecensione = r.getTitolo();
				       String testoRecensione = r.getContenuto();
				       int stelle = r.getValutazione();
				       ValutazioneBean val = (valutazioni != null) ? valutazioni.get(emailRecensore) : null;
				
				       // Ricavo lo username da visualizzare
				       String usernameRecensore = (users != null && users.containsKey(emailRecensore))
				                                    ? users.get(emailRecensore)
				                                    : emailRecensore; // fallback all'email se non trovato
				%>
				
				<div class="review-card">
				    <div class="review-username">
				        <!-- Modificato: ora usa lo username invece della mail -->
				        <a href="<%= request.getContextPath() %>/profile?visitedUser=<%= usernameRecensore %>" class="profile-link">
				            <%= usernameRecensore %>
				        </a>
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
				        <% } } %>
				    </div>
				    <div class="review-actions">
				        <div class="likes-dislikes">
				            <button class="btn-like <%= (val != null && val.isLikeDislike()) ? "active" : "" %>" 
				                    <%= (user != null && "RECENSORE".equals(user.getTipoUtente())) 
				                         ? "onclick=\"voteReview('" + film.getIdFilm() + "', '" + emailRecensore + "', true)\"" 
				                         : "disabled" %>>
				                <i class="fas fa-thumbs-up"></i> <span><%= r.getNLike() %></span>
				            </button>
				            <button class="btn-dislike <%= (val != null && !val.isLikeDislike()) ? "active" : "" %>" 
				                    <%= (user != null && "RECENSORE".equals(user.getTipoUtente())) 
				                         ? "onclick=\"voteReview('" + film.getIdFilm() + "', '" + emailRecensore + "', false)\"" 
				                         : "disabled" %>>
				                <i class="fas fa-thumbs-down"></i> <span><%= r.getNDislike() %></span>
				            </button>
				        </div>
				        <% if (user != null && "RECENSORE".equals(user.getTipoUtente())) { %>
				            <button class="btn-report" 
				                    onclick="reportReview('<%= film.getIdFilm() %>', '<%= emailRecensore %>')">
				                <i class="fas fa-flag"></i> Segnala
				            </button>
				        <% } %>
				    </div>
				</div>
				
				<% 
				   } 
				} else { 
				%>
				<p class="no-reviews-msg">Nessuna recensione presente per questo film.</p>
				<% } %>

            </div>

            <div class="right-column">
                <div class="film-details">
                    <%
			            String LocandinaBase64 = "";
			            if (film.getLocandina() != null) {
			                byte[] iconaBytes = film.getLocandina() ;
			                if (iconaBytes.length > 0) {
			                	LocandinaBase64 = java.util.Base64.getEncoder().encodeToString(iconaBytes);
			                }
			            }
			        %>
					<img class="film-poster" 
					     src="data:image/png;base64,<%= LocandinaBase64 %>" 
					   alt="Locandina di <%= film.getNome() %>" />

                    <h2 class="film-title"><%= film.getNome() %></h2>
                    <div class="review-stars">
                        <%
                        int stelleFilm = film.getValutazione();
                        for (int i = 1; i <= 5; i++) {
                            if (i <= stelleFilm) { %>
                                <i class="fas fa-star"></i>
                        <% } else { %>
                                <i class="far fa-star"></i>
                        <% }} %>
                    </div>
                    <p class="film-year-genre">
                        <%= film.getAnno() %> - <%= film.getGeneri() %>
                    </p>
                    <p class="film-description"><%= film.getTrama() %></p>

                    <div class="rate-film">
                        <% if (user != null && "RECENSORE".equals(user.getTipoUtente())) { %>
                            <button type="button" class="btn-rate" onclick="showReviewForm()">RATE IT</button>
                        <% } else { %>
                            <button type="button" class="btn-rate" disabled>RATE IT</button>
                        <% } %>
                    </div>

                    <% if (user != null && "GESTORE".equals(user.getTipoUtente())) { %>
                        <div class="manage-film">
                            <button type="button" class="btn-delete" onclick="deleteFilm('<%= film.getIdFilm() %>')">Elimina Film</button>
                            <button type="button" class="btn-modify" onclick="showModifyForm()">Modifica Informazioni Film</button>
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

                <label>Valutazione:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="valutazione" value="5" />
                    <label for="star5" title="5 stelle"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star4" name="valutazione" value="4" />
                    <label for="star4" title="4 stelle"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star3" name="valutazione" value="3" />
                    <label for="star3" title="3 stelle"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star2" name="valutazione" value="2" />
                    <label for="star2" title="2 stelle"><i class="fas fa-star"></i></label>
                    <input type="radio" id="star1" name="valutazione" value="1" />
                    <label for="star1" title="1 stella"><i class="fas fa-star"></i></label>
                </div>

                <button type="submit" class="btn-submit">Pubblica</button>
            </form>
        </div>
    </div>

    <!-- Overlay Form per la Modifica delle Informazioni del Film -->
    <div id="modifyOverlay" class="overlay">
        <div class="overlay-content">
            <span class="close-btn" onclick="hideModifyForm()">&times;</span>
            <h2>Modifica Informazioni Film</h2>
            <form action="<%= request.getContextPath() %>/filmModify" method="post">
                <input type="hidden" name="idFilm" value="<%= film.getIdFilm() %>" />

                <label for="nomeFilm">Nome Film:</label>
                <input type="text" id="nomeFilm" name="nomeFilm" value="<%= film.getNome() %>" required />

                <label for="registaFilm">Regista:</label>
                <input type="text" id="registaFilm" name="registaFilm" value="<%= film.getRegista() %>" required />

                <label for="annoFilm">Anno:</label>
                <input type="number" id="annoFilm" name="annoFilm" value="<%= film.getAnno() %>" required />

                <label for="generiFilm">Generi:</label>
                <input type="text" id="generiFilm" name="generiFilm" value="<%= film.getGeneri() %>" required />

                <label for="tramaFilm">Trama:</label>
                <textarea id="tramaFilm" name="tramaFilm" rows="4" required><%= film.getTrama() %></textarea>

                <label for="durataFilm">Durata (minuti):</label>
                <input type="number" id="durataFilm" name="durataFilm" value="<%= film.getDurata() %>" required />

                <label for="attoriFilm">Attori:</label>
                <input type="text" id="attoriFilm" name="attoriFilm" value="<%= film.getAttori() %>" required />

                <label for="locandinaFilm">Nuova Locandina (opzionale):</label>
                <input type="file" id="locandinaFilm" name="locandinaFilm" accept="image/*" />

                <button type="submit" class="btn-submit">Salva Modifiche</button>
            </form>
        </div>
    </div>

</body>
</html>
