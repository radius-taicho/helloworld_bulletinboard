// app/javascript/packs/edit-delete-modal.js
document.addEventListener("turbo:load", function() {
  const hoverImage = document.getElementById("hover-bomb-image");
  const modalButtons = document.getElementById("modal-buttons");

  hoverImage.addEventListener("click", function() {
    modalButtons.style.display = "block";
  });

  document.getElementById("edit-thread-btn").addEventListener("click", function() {
    alert("スレッド編集モーダルを表示");
  });

  document.getElementById("delete-thread-btn").addEventListener("click", function() {
    alert("スレッド削除モーダルを表示");
  });
});
