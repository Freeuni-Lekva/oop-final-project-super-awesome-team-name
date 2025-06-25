let isLogin = true;

function toggleForm() {
    isLogin = !isLogin;

    const formSubtitle = document.getElementById("formSubtitle");
    formSubtitle.classList.remove("error");

    formSubtitle.textContent = isLogin
        ? "Welcome back! Log in to your account:"
        : "Let's get started! Create a new account:";

    document.getElementById("authMode").value = isLogin
        ? "login"
        : "signup";

    document.getElementById("introPanel").classList.toggle("reverse");

    document.getElementById("sideImage").src = isLogin
        ? "/images/gradient1.jpg"
        : "/images/gradient5.jpg";

    document.getElementById("entryForm").style.transform = isLogin
        ? 'translate(-12.5px, 0)'
        : 'translate(+12.5px, 0)';

    document.getElementById("formTitle").textContent = isLogin
        ? "Sign in to Quizzes"
        : "Register for Quizzes";

    document.getElementById("name").value = "";
    document.getElementById("password").value = "";

    const submitButton = document.getElementById("submitButton");
    submitButton.value = isLogin
        ? "Log in"
        : "Sign up";

    submitButton.classList.toggle("btn-login", isLogin);
    submitButton.classList.toggle("btn-signup", !isLogin);

    submitButton.value = isLogin
        ? "Log in"
        : "Sign up";

    document.getElementById("toggleText").innerHTML = isLogin
        ? `Don't have an account? <a href="#" onclick="toggleForm()">Sign up</a>`
        : `Already have an account? <a href="#" onclick="toggleForm()">Log in</a>`;
}