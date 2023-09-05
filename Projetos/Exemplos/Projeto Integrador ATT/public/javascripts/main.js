// show menu

const showMneu = (toggleId, navId) => {
  const toggle = document.getElementById(toggleId),
    nav = document.getElementById(navId);
  /*valida se se existe as variaveis*/
  if (toggle && nav) {
    /*aqui adiciono a class show-menu na div com a class nav__menu*/
    toggle.addEventListener("click", () => {
      /*adicina a class show-menu na div que tem o id nav-menu */
      nav.classList.toggle("show-menu");
    });
  }
};
showMneu("nav-toggle", "nav-menu");
