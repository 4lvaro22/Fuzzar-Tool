
const socket = io();

socket.on("dataChanged", () => {
    localStorage.setItem("reload", true);
    location.reload();
});

window.onload = function () {
    if (localStorage.getItem("reload")) {
        const alert = document.getElementById("toast-default");
        const closeAlert = document.getElementById("close-alert");
        alert.style.display = "flex"
        closeAlert.onclick = function () {
            alert.style.display = "none";
        };

        setInterval(() => {
            alert.style.display = "none";
        }, 5000);
        localStorage.removeItem("reload");
    }
};
