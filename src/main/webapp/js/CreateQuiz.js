document.addEventListener("DOMContentLoaded", function () {
    const onePageSelect = document.getElementById("onePage");
    const immediateCorrectionContainer = document.getElementById("immediateCorrectionContainer");

    function toggleImmediateCorrection() {
        if (onePageSelect.value === "Yes") {
            immediateCorrectionContainer.style.display = "none";
        } else {
            immediateCorrectionContainer.style.display = "block";
        }
    }

    toggleImmediateCorrection(); // Run once on page load
    onePageSelect.addEventListener("change", toggleImmediateCorrection);
});
