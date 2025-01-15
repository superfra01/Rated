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

function showReviewForm() {
    document.getElementById('reviewOverlay').style.display = 'flex';
}

function hideReviewForm() {
    document.getElementById('reviewOverlay').style.display = 'none';
}

function showModifyForm() {
    document.getElementById('modifyOverlay').style.display = 'flex';
}

function hideModifyForm() {
    document.getElementById('modifyOverlay').style.display = 'none';
}

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
                    window.location.href = "/catalogo";
                } else {
                    alert("Errore durante l'eliminazione. Riprova più tardi.");
                }
            })
            .catch(error => {
                console.error("Errore nella richiesta:", error);
                alert("Errore durante l'eliminazione. Riprova più tardi.");
            });
    }
}

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
