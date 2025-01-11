const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const usernamePattern = /^[a-zA-Z0-9]+$/;
const passwordPattern = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

const messages = {
    email: "Inserire un indirizzo email valido nella forma: name@domain.ext",
    username: "Lo username può contenere solo lettere e numeri",
    password: "La password deve contenere almeno 8 caratteri, inclusa una cifra",
    confirmPassword: "Le password non corrispondono",
    profileIcon: "Seleziona un'icona valida (formato immagine, non un altro tipo di file)",
    bio: "La biografia non può essere vuota"
};

let showErrors = false;

function validateFormElem(formElem, pattern, message) {
    const span = document.getElementById("error" + capitalize(formElem.name));
    if (showErrors) {
        if (!formElem.value.match(pattern)) {
            setError(formElem, span, message);
            return false;
        }
        clearError(formElem, span);
    }
    return true;
}

function validate() {
    let valid = true;
    const form = document.getElementById("regForm");

    valid = validateFormElem(form.username, usernamePattern, messages.username) && valid;

    valid = validateFormElem(form.email, emailPattern, messages.email) && valid;

    valid = validateFormElem(form.password, passwordPattern, messages.password) && valid;

    const confirmPassword = form.confirm_password;
    if (showErrors && confirmPassword.value !== form.password.value) {
        setError(confirmPassword, document.getElementById("errorConfirmPassword"), messages.confirmPassword);
        valid = false;
    } else if (showErrors) {
        clearError(confirmPassword, document.getElementById("errorConfirmPassword"));
    }

    const profileIcon = form.profile_icon;
    const spanProfileIcon = document.getElementById("errorProfileIcon");
    if (showErrors && (!profileIcon.files[0] || !profileIcon.files[0].type.startsWith("image/"))) {
        setError(profileIcon, spanProfileIcon, messages.profileIcon);
        valid = false;
    } else if (showErrors) {
        clearError(profileIcon, spanProfileIcon);
    }

    const bio = form.bio;
    const spanBio = document.getElementById("errorBio");
    if (showErrors && !bio.value.trim()) {
        setError(bio, spanBio, messages.bio);
        valid = false;
    } else if (showErrors) {
        clearError(bio, spanBio);
    }

    return valid;
}

function setError(input, span, message) {
    input.classList.add("error");
    span.innerHTML = message;
    span.style.color = "red";
}

function clearError(input, span) {
    input.classList.remove("error");
    span.innerHTML = "";
}

function capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("regForm");

    // Blocco la sottomissione se ci sono errori
    form.onsubmit = function (event) {
        showErrors = true; // Attivo la visualizzazione degli errori
        if (!validate()) {
            event.preventDefault(); // Impedisco l'invio del form se non è valido
        }
    };
});
