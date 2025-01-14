<%@ page import="model.Entity.UtenteBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rated - About Us</title>
    <link rel="stylesheet" href="static/css/HomePage.css">
</head>
<body>
    <%@ include file="header.jsp" %>

    <%
        // Recupero l'utente dalla sessione
        UtenteBean utente = (UtenteBean) session.getAttribute("user");
        int nWarning = 0;
        if (utente != null) {
            nWarning = utente.getNWarning();
        }

        // Controllo se c'� il parametro loginSuccess (true) nella query string
        String loginSuccessParam = request.getParameter("loginSuccess");
        boolean loginSuccess = "true".equals(loginSuccessParam);
    %>

    <main>
        <div class="about-container">
            <img src="static/images/RATED_icon.png" alt="Rated Logo" class="logo-large">
            <p class="description">
                Rated � una piattaforma pensata per chi ama il cinema e vuole condividere opinioni sui film, 
                scoprire nuove recensioni e interagire con altri appassionati.
                Il nostro obiettivo � promuovere discussioni di qualit� e valorizzare i contenuti pi� apprezzati 
                dalla community. Unisciti a noi, pubblica le tue recensioni e diventa parte della nostra famiglia di cinefili!
            </p>
            <a href="catalogo">
                <button class="catalogue-button">Scopri il catalogo di film</button>
            </a>
        </div>
    </main>

    <script>
        // Passiamo dal server a JavaScript i valori necessari:
        const loginSuccess = <%= loginSuccess ? "true" : "false" %>;
        const nWarning = <%= nWarning %>;

        // Mostra l'alert solo se la pagina � stata aperta dopo un login (loginSuccess == true)
        if (loginSuccess) {
            if (nWarning > 0 && nWarning < 3) {
                alert("Attenzione: Hai ricevuto un warning da un moderatore.\n" +
                      "Ci� � avvenuto a causa della rimozione di una recensione inappropriata.\n" +
                      "Ti invitiamo a essere rispettoso nelle recensioni ed evitare spoiler.\n\n" +
                      "In totale hai ricevuto: " + nWarning + " warning.\n" +
                      "Ricorda: al raggiungimento di 3 warning, il tuo account sar� limitato e non potrai pi� scrivere recensioni.");
            } else if (nWarning >= 3) {
                alert("Il tuo account � attualmente limitato a causa di 3 o pi� warning ricevuti.\n" +
                      "Non puoi pi� scrivere recensioni.");
            }

            // Rimuove il parametro "loginSuccess" dalla URL, cos� non rispunta l'alert se l'utente ricarica la pagina
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    </script>
</body>
</html>
