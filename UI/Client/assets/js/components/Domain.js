const Domain = {
  init(el) {
    var popup = new Vue({
      delimiters: ["[[", "]]"],

      el: el,

      data: {},

      computed: {},

      mounted() {
        document.onkeydown = function (evt) {
          evt = evt || window.event;
          var isEscape = false;
          if ("key" in evt) {
            isEscape = evt.key === "Escape" || evt.key === "Esc";
          } else {
            isEscape = evt.isEscape;
          }
          this.hideAllModal(isEscape);
        }
      },

      watch: {},

      methods: {
        hideAllModal(isEscape) {
          let modalAddDomain = document.querySelector("#modalVfAddDomain");
          if (isEscape && !modalAddDomain.classList.contains("vf-opacity-0")) {
            this.toggleModal('modalVfAddDomain');
          }
          let modalEditDomain = document.querySelector("#modalVfEditDomain");
          if (isEscape && !modalEditDomain.classList.contains("vf-opacity-0")) {
            this.toggleModal('modalVfEditDomain');
          }
          let modalUpdateSSL = document.querySelector("#modalVfUpdateSSL");
          if (isEscape && !modalUpdateSSL.classList.contains("vf-opacity-0")) {
            this.toggleModal('modalVfUpdateSSL');
          }
        },
        toggleModal(modalID) {
          console.log("🚀 ~ file: Domain.js:40 ~ toggleModal ~ modalID:", modalID)
          const modal = document.querySelector("#" + modalID);
          modal.classList.toggle("opacity-0");
          modal.classList.toggle("pointer-events-none");
          modal.classList.toggle("vf-opacity-0");

          if (!modal.classList.contains("vf-opacity-0")) {
            modal.style.display = "flex";
          } else {
            modal.style.display = "none";
          }

          const body = document.querySelector(".vnx-main");

          if (!modal.classList.contains("vf-opacity-0")) {
            body.style.overflow = "hidden";
          } else {
            body.style.overflow = "auto";
          }
        }
      }

    });
  }
};

export default Domain;

function copyToClipboard(element) {
  var copyText = document.getElementById(element);
  copyText.select();
  copyText.setSelectionRange(0, 99999);
  document.execCommand("copy");
  alert("Copied the text to clipboard.");
}