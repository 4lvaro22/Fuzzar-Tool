descriptions = document.getElementsByClassName("profile-description");

for (var i = 0; i < descriptions.length; i++) {
    descriptions[i].addEventListener('click', linkClick, false);
}

function linkClick(event) {
    document.get
    modal = document.getElementsByTagName("dialog")[0];
    console.log(modal)
    modal.showModal();
}