document.addEventListener("turbo:load", () => {
  const notificationCheckButton = document.querySelector(".notification-image");
  const notificationModal = document.querySelector(".notification-modal");

  if (!notificationCheckButton || !notificationModal) return;

  notificationCheckButton.addEventListener("click", () => {
    notificationModal.style.display = "block";
  });

  window.addEventListener("click", function(event) {
    // モーダル外をクリックしたら閉じる
    if (event.target === notificationModal) {
      notificationModal.style.display = "none";
    }
  });
});
