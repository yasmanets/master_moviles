'use strict'

function suma() {
    const operando1 = document.getElementById('operando1');
    const operando2 = document.getElementById('operando2');
    const result = document.getElementById('result');

    if (!operando1.value) {
        return showError('div', 'Tienes que rellenar el primer operando!');
    }

    if (!operando2.value) {
        return showError('div', 'Tienes que rellenar el segundo operando!');
    }
    const suma = parseFloat(operando1.value) + parseFloat(operando2.value);
    return result.innerHTML = suma.toFixed(2).toString();
}

function resta() {
    const operando1 = document.getElementById('operando1');
    const operando2 = document.getElementById('operando2');
    const result = document.getElementById('result');

    if (!operando1.value) {
        return showError('div', 'Tienes que rellenar el primer operando!');
    }

    if (!operando2.value) {
        return showError('div', 'Tienes que rellenar el segundo operando!');
    }
    const resta = parseFloat(operando1.value) - parseFloat(operando2.value);
    return result.innerHTML = resta.toFixed(2).toString();
}

function multiplicacion() {
    const operando1 = document.getElementById('operando1');
    const operando2 = document.getElementById('operando2');
    const result = document.getElementById('result');

    if (!operando1.value) {
        return showError('div', 'Tienes que rellenar el primer operando!');
    }

    if (!operando2.value) {
        return showError('div', 'Tienes que rellenar el segundo operando!');
    }

    const multiplicacion = parseFloat(operando1.value) * parseFloat(operando2.value);
    return result.innerHTML = multiplicacion.toFixed(2).toString();
}

function division() {
    const operando1 = document.getElementById('operando1');
    const operando2 = document.getElementById('operando2');
    const result = document.getElementById('result');

    if (!operando1.value) {
        return showError('div', 'Tienes que rellenar el primer operando!')
    }

    if (!operando2.value) {
        return showError('div', 'Tienes que rellenar el segundo operando!')
    }

    if (parseFloat(operando2.value) === 0) {
        return showError('div', 'El divisor no puede ser 0!');
    }
    const division = parseFloat(operando1.value) / parseFloat(operando2.value);
    return result.innerHTML = division.toFixed(2).toString();
}


function showError(elem, text) {
    const errorDiv = document.createElement(elem);
    const errorContent = document.createTextNode(text);
    errorDiv.appendChild(errorContent);

    errorDiv.classList.add('error');
    document.body.appendChild(errorDiv);
}