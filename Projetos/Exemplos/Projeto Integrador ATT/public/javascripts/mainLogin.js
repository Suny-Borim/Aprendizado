// show menu

// Função para abrir pop-up de cadastro

function iniciaModal(modalID) {
  const modal = document.getElementById(modalID);
  if (modal) {
    modal.classList.add("mostrar");
    modal.addEventListener("click", (e) => {
      if (e.target.id == modalID || e.target.className == "close") {
        modal.classList.remove("mostrar");
      }
    });
  }
}

const signUpModal = document.querySelector(".signUp");
signUpModal.addEventListener("click", function () {
  iniciaModal("modal-signUp");
});

// Função para abrir pop-up para recuperar senha

function iniciaModal(modalID) {
  const modal = document.getElementById(modalID);
  if (modal) {
    modal.classList.add("mostrar");
    modal.addEventListener("click", (e) => {
      if (e.target.id == modalID || e.target.className == "close") {
        modal.classList.remove("mostrar");
      }
    });
  }
}

const forgotPassword = document.querySelector(".forgot-password");
forgotPassword.addEventListener("click", function () {
  iniciaModal("modal-forgot");
});
