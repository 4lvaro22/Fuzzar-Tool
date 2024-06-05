descriptions = document.getElementsByClassName("profile-description");

for (var i = 0; i < descriptions.length; i++) {
    descriptions[i].addEventListener('click', linkClick, false);
}

function linkClick(event) {
    modalsList = document.getElementsByTagName("dialog");
    modal = undefined;
    
    for(i = 0; i < modalsList.length; i ++){
        if(event.target.id === modalsList[i].id){
            modal = modalsList[i];
        }
    }

    modal.showModal();
}