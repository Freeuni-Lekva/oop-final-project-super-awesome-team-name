function updateFields() {
    const announceBlock = document.getElementById("announce");
    const smallBLock = document.getElementById("notAnnounce");
    const textLabel = document.querySelector("label[for='smallText']");
    const result = document.getElementById("result");

    announceBlock.classList.add("hide");
    smallBLock.classList.remove("hide");

    if (result.classList.contains("error") || result.classList.contains("success")) {
        result.textContent = "";
        result.classList.remove("error");
        result.classList.remove("success");
    }

    switch (document.getElementById("adminFunc").value) {
        case "announce":
            textLabel.textContent = "Enter a title: ";
            announceBlock.classList.remove("hide");
            document.querySelector("label[for='announceText']").textContent = "Enter announcement text:";
            break;
        case "removeUser":
            textLabel.textContent = "Enter a username:";
            break;
        case "removeQuiz":
            textLabel.textContent = "Enter a quiz:";
            break;
        case "clearHistory":
            textLabel.textContent = "Enter a quiz:";
            break;
        case "promoteUser":
            textLabel.textContent = "Enter a username:";
            break;
        case "seeStatistics":
            smallBLock.classList.add("hide");
            break;
    }
}

window.addEventListener("DOMContentLoaded", function () {
    document.getElementById("adminFunc").addEventListener("change", updateFields);
    updateFields();
});