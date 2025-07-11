var startTime = new Date().getTime();

function updateTimer() {
    var currentTime = new Date().getTime();
    var elapsed = Math.floor((currentTime - startTime) / 1000);
    var minutes = Math.floor(elapsed / 60);
    var seconds = elapsed % 60;
    document.getElementById('timer').innerHTML =
        minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
}

setInterval(updateTimer, 1000);

function validateForm() {
    console.log("Form validation started");

    var form = document.getElementById('quizForm');
    var questions = document.querySelectorAll('.question-container');
    var allAnswered = true;
    var unansweredQuestions = [];

    questions.forEach(function(question, index) {
        var questionId = question.dataset.questionId;
        var questionType = question.dataset.questionType;
        var answered = false;

        console.log("Checking question " + questionId + " of type " + questionType);

        if (questionType === 'Multiple Choice') {
            var radios = question.querySelectorAll('input[type="radio"]');
            radios.forEach(function(radio) {
                if (radio.checked) {
                    answered = true;
                    console.log("Found checked radio with value: " + radio.value);
                }
            });
        } else if (questionType === 'Multiple Choice with Multiple Answers') {
            var checkboxes = question.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(function(checkbox) {
                if (checkbox.checked) {
                    answered = true;
                    console.log("Found checked checkbox with value: " + checkbox.value);
                }
            });
        } else if (questionType === 'Matching') {
            var hiddenInput = question.querySelector('input[type="hidden"][name^="question_"]');
            if (hiddenInput && hiddenInput.value && hiddenInput.value.trim() !== '') {
                answered = true;
                console.log("Matching question answered with order: " + hiddenInput.value);
            } else {
                console.log("Matching question not answered - no order set");
            }
        } else {
            var textInput = question.querySelector('input[type="text"], textarea');
            if (textInput && textInput.value.trim() !== '') {
                answered = true;
                console.log("Found text input with value: " + textInput.value);
            }
        }

        if (!answered) {
            allAnswered = false;
            unansweredQuestions.push(index + 1);
            question.style.border = '2px solid #F44336';
        } else {
            question.style.border = '1px solid rgba(255, 255, 255, 0.2)';
        }
    });

    if (!allAnswered) {
        alert('Please answer all questions before submitting. Unanswered questions: ' + unansweredQuestions.join(', '));
        return false;
    }

    var formData = new FormData(form);
    for (var entry of formData.entries()) {
        console.log(entry[0] + ': ' + entry[1]);
    }

    return confirm('Are you sure you want to submit your quiz?');
}

function debugFormInputs() {
    console.log("=== All Form Inputs Debug ===");
    var form = document.getElementById('quizForm');
    var inputs = form.querySelectorAll('input, textarea, select');
    inputs.forEach(function(input) {
        console.log("Input name: " + input.name + ", value: " + input.value + ", type: " + input.type);
    });
}

window.onload = function () {
    setTimeout(debugFormInputs, 1000);
};

function initMatchingDragAndDrop(containerId, hiddenInputId, leftItemsCSV) {
    var container = document.getElementById(containerId);
    var hiddenInput = document.getElementById(hiddenInputId);
    var draggedElement = null;
    var leftItemsArray = leftItemsCSV.split('|');

    function updateOrder() {
        var items = container.querySelectorAll('.draggable-item');
        var order = [];
        for (var i = 0; i < items.length; i++) {
            var value = items[i].getAttribute('data-value');
            var leftItem = leftItemsArray[i] || leftItemsArray[0];
            order.push(leftItem + '=' + value);
        }
        hiddenInput.value = order.join(', ');
    }

    container.addEventListener('dragstart', function (e) {
        if (e.target.classList.contains('draggable-item')) {
            draggedElement = e.target;
            e.target.style.opacity = '0.5';
        }
    });

    container.addEventListener('dragend', function (e) {
        if (e.target.classList.contains('draggable-item')) {
            e.target.style.opacity = '1';
            updateOrder();
        }
    });

    container.addEventListener('dragover', function (e) {
        e.preventDefault();
    });

    container.addEventListener('drop', function (e) {
        e.preventDefault();
        if (draggedElement && e.target.classList.contains('draggable-item')) {
            var rect = e.target.getBoundingClientRect();
            if (e.clientY > rect.top + rect.height / 2) {
                container.insertBefore(draggedElement, e.target.nextSibling);
            } else {
                container.insertBefore(draggedElement, e.target);
            }
            updateOrder();
        }
    });

    updateOrder();
}
