document.addEventListener("turbo:load", () => {
  // すべての dm-start-box 要素を取得
  const dmStartBoxes = document.querySelectorAll(".dm-start-box");

  dmStartBoxes.forEach((dmStartBox) => {
    // dm-start-box 内の start-dm-button 要素を取得
    const startDmButton = dmStartBox.querySelector(".start-dm-button");

    if (startDmButton) {
      dmStartBox.addEventListener("click", () => {
        startDmButton.click();
      });
    }
  });
});
