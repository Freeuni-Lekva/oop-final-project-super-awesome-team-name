function updateFields() {
    const announceBlock = document.getElementById("announce");
    const smallBLock = document.getElementById("notAnnounce");
    const textLabel = document.querySelector("label[for='smallText']");

    document.getElementById("smallText").value = "";
    document.getElementById("announceText").value = "";

    announceBlock.classList.add("hide");
    smallBLock.classList.remove("hide");
    document.getElementById("result").classList.add("hide");

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


window.addEventListener("load", function () {
    updateFields();
    document.getElementById("adminFunc").addEventListener("change", updateFields);

    const form = document.getElementById("adminForm");
    if (!form) return;

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        const formData = new FormData(form);
        const params = new URLSearchParams(formData);

        fetch(form.getAttribute("action") || window.location.pathname, {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: params.toString()
        })
            .then(res => res.json())
            .then(data => {

                document.getElementById("smallText").value = "";
                document.getElementById("announceText").value = "";

                const result = document.getElementById("result");
                result.textContent = data.message;
                result.className = data.status === "success" ? "success" :
                    data.status === "error" ? "error" : "info";
            })
            .catch(err => {
                const result = document.getElementById("result");
                result.textContent = "AJAX error occurred.";
                result.className = "error";
            });
    });
});