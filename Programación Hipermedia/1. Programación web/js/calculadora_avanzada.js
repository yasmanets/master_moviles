'use strict'

function limpiar() {
    document.getElementById('pantalla').innerHTML = "";
}

function setValue(value) {
    let html = document.getElementById('pantalla').innerHTML;

    if (!html || html === 'ERROR') {
        html = value;
    }
    else {
        html += value;
    }
    document.getElementById('pantalla').innerHTML = html;
}

function calcular() {
    const expresion = document.getElementById('pantalla').innerHTML;
    if (!expresion) {
        return 0;
    }

    let result;
    try {
        result = eval(expresion);
    }
    catch (error) {
        result = 'ERROR';
    }

    if (isFinite(result)) {
        if (!Number.isInteger(result)) {
            result = result.toFixed(2);
        }
    }
    else {
        result = 'ERROR';
    }
    document.getElementById('pantalla').innerHTML = result;
}