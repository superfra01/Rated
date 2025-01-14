<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rated - About Us</title>
    <link rel="stylesheet" href="static/css/HomePage.css">
    <script>
	    const urlParams = new URLSearchParams(window.location.search);
	    if (urlParams.get("loginSuccess") === "true") {
	        UtenteBean user = (UtenteBean) session.getAttribute("user");
	        int nWarning = user.getNWarning()
	        if (nWarning > 0 && nWarning < 3) {
	            alert(Attenzione: Hai ricevuto un warning da un moderatore.
	    Ci� � avvenuto a causa della rimozione di una recensione inappropriata. 
	    Ti invitiamo a essere rispettoso nelle recensioni ed evitare spoiler.

	    In totale hai ricevuto: ${user.getNWarning()} warning.
	    Ricorda: al raggiungimento di 3 warning, il tuo account sar� limitato e non potrai pi� scrivere recensioni.);
	        } else if (nWarning >= 3) {
	            alert(Il tuo account � attualmente limitato a causa di 3 o pi� warning ricevuti. 
	    Non puoi pi� scrivere recensioni.);
	        }
	    }
	</script>
</head>
<body>
    <%@ include file="header.jsp" %>
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
</body>
</html>