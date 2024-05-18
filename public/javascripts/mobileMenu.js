mobileMenu = document.getElementById('mobile-menu')
mobileMenubtn = document.getElementById('button-mobile-menu')
svgMobileMenuOpen = document.getElementById('button-mobile-menu-open')
svgMobileMenuClose = document.getElementById('button-mobile-menu-close')

mobileMenubtn.addEventListener('click', mobileMenuClick, false);
console.log(svgMobileMenuOpen)
function mobileMenuClick(event){
    mobileMenu.classList.toggle("hidden");
    svgMobileMenuClose.classList.toggle("hidden");
    svgMobileMenuClose.classList.contains("hidden") ? svgMobileMenuOpen.classList.replace("hidden", "block") : svgMobileMenuOpen.classList.replace("block", "hidden");
    
}