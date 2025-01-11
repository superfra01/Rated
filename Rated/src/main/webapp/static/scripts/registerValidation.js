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

function validateFormElem(formElem, pattern, message) {
    const span = document.getElementById("error" + capitalize(formElem.name));
    if (!formElem.value.match(pattern)) {
        setError(formElem, span, message);
        return false;
    }
    clearError(formElem, span);
    return true;
}

function validate() {
    let valid = true;
    const form = document.getElementById("regForm");

    // Validazione username
    valid = validateFormElem(form.username, usernamePattern, messages.username) && valid;

    // Validazione email
    valid = validateFormElem(form.email, emailPattern, messages.email) && valid;

    // Validazione password
    valid = validateFormElem(form.password, passwordPattern, messages.password) && valid;

    // Validazione conferma password
    const confirmPassword = form.confirm_password;
    if (confirmPassword.value !== form.password.value) {
        setError(confirmPassword, document.getElementById("errorConfirmPassword"), messages.confirmPassword);
        valid = false;
    } else {
        clearError(confirmPassword, document.getElementById("errorConfirmPassword"));
    }

    // Validazione immagine
    const profileIcon = form.profile_icon;
    const spanProfileIcon = document.getElementById("errorProfileIcon");
    if (!profileIcon.files[0] || !profileIcon.files[0].type.startsWith("image/")) {
        setError(profileIcon, spanProfileIcon, messages.profileIcon);
        valid = false;
    } else {
        clearError(profileIcon, spanProfileIcon);
    }

    // Validazione biografia
    const bio = form.bio;
    const spanBio = document.getElementById("errorBio");
    if (!bio.value.trim()) {
        setError(bio, spanBio, messages.bio);
        valid = false;
    } else {
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

// Eventi
document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("regForm");

    // Blocco la sottomissione se ci sono errori
    form.onsubmit = function (event) {
        if (!validate()) {
            event.preventDefault();
        }
    };

    // Ascoltatore sugli input per validare in tempo reale
    form.addEventListener("input", function (event) {
        const input = event.target;

        // Se l'elemento non ha un 'name', esci
        if (!input.name) return;

        const spanId = "error" + capitalize(input.name);
        const span = document.getElementById(spanId);

        switch (input.name) {
            case "username":
                validateFormElem(input, usernamePattern, messages.username);
                break;
            case "email":
                validateFormElem(input, emailPattern, messages.email);
                break;
            case "password":
                validateFormElem(input, passwordPattern, messages.password);
                // Se cambiamo la password, ricontrolliamo anche la conferma
                const confirmPassword = form.confirm_password;
                const confirmSpan = document.getElementById("errorConfirmPassword");
                if (confirmPassword.value !== input.value) {
                    setError(confirmPassword, confirmSpan, messages.confirmPassword);
                } else {
                    clearError(confirmPassword, confirmSpan);
                }
                break;
            case "confirm_password":
                if (input.value !== form.password.value) {
                    setError(input, span, messages.confirmPassword);
                } else {
                    clearError(input, span);
                }
                break;
            case "bio":
                if (!input.value.trim()) {
                    setError(input, span, messages.bio);
                } else {
                    clearError(input, span);
                }
                break;
        }
    });

    // Ascoltatore specifico per il campo 'profile_icon'
    const profileIcon = form.profile_icon;
    profileIcon.addEventListener("change", function () {
        const span = document.getElementById("errorProfileIcon");
        if (!profileIcon.files[0] || !profileIcon.files[0].type.startsWith("image/")) {
            setError(profileIcon, span, messages.profileIcon);
        } else {
            clearError(profileIcon, span);
        }
    });
});
