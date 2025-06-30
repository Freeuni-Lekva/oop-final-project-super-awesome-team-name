// Clamp value to [min, max] and show warning if clamped
function clampValue(input, warningElem) {
    const min = parseInt(input.min);
    const max = parseInt(input.max);
    let val = parseInt(input.value);

    if (isNaN(val)) {
        warningElem.textContent = '';
        return;
    }

    if (val < min) {
        input.value = min;
        warningElem.textContent = "The value must be between " + min + " and " + max + ".";
    } else if (val > max) {
        input.value = max;
        warningElem.textContent = "The value must be between " + min + " and " + max + ".";
    } else {
        warningElem.textContent = '';
    }
}

window.addEventListener('DOMContentLoaded', function () {
    const input = document.getElementById('NQuestions');
    const warning = document.getElementById('numWarning');

    // Clamp as user types or leaves field, show/hide warning
    input.addEventListener('input', function () {
        clampValue(input, warning);
    });

    input.addEventListener('change', function () {
        clampValue(input, warning);
    });

    // On submit, clamp once more before submitting and update warning
    document.getElementById('quizForm').addEventListener('submit', function () {
        clampValue(input, warning);
    });
});
