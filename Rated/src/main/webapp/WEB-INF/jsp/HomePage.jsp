<%@ page import="model.Entity.UtenteBean" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rated - About Us</title>
    <link rel="stylesheet" href="static/css/HomePage.css">
    <script src="static/scripts/homePageWarn.js" defer></script>
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
        // Passaggio dei dati al file JavaScript
        const data = {
            loginSuccess: <%= loginSuccess ? "true" : "false" %>,
            nWarning: <%= nWarning %>
        };
    </script>
</body>
</html>
