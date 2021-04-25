'use strict'

function validar() {
    const username = document.getElementById('user').value;
    const password = document.getElementById('password').value;
    const usernameError = document.getElementById('usernameError');
    const passwordError = document.getElementById('passwordError');
    const success = document.getElementById('success');
    let error = false;

    if (!username) {
        showMessage(usernameError, 'El campo usuario es requerido', 'error');
        error = true;
    }
    else if (username.length < 3) {
        showMessage(usernameError, 'El usuario debe tener al menor 3 caracteres', 'error');
        error = true;
    }

    if (!password) {
        showMessage(passwordError, 'El campo password es requerido', 'error');
        error = true;
    }
    else if (password.length < 3) {
        showMessage(passwordError, 'El password debe tener al menor 3 caracteres', 'error');
        error = true;
    }

    if (!error) {
        showMessage(success, '¡Validación correcta!', 'success');
        usernameError.innerHTML = "";
        passwordError.innerHTML = "";
    }
    else {
        success.innerHTML = "";
    }
}

function showMessage(elem, text, type) {
    elem.innerHTML = text
    elem.classList.add(type);

}