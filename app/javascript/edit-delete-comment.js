document.addEventListener("turbo:load", ()=> {

const hoverBombImage = document.getElementById("hover-bomb-image2");
const editAndDeleteCommentButtons= document.getElementById("comment-edit-delete-modal-buttons");


if (hoverBombImage && editAndDeleteCommentButtons) {
  hoverBombImage.addEventListener("click", function () {
    // 表示状態をトグルする
    editAndDeleteCommentButtons.style.display = editAndDeleteCommentButtons.style.display === "block" ? "none" : "block";
  });

  // クリック以外の場所でボタンを非表示にする処理（例: ウィンドウクリックで非表示）
  window.addEventListener("click", function(event) {
    if (!hoverBombImage.contains(event.target) && !editAndDeleteCommentButtons.contains(event.target)) {
      editAndDeleteCommentButtons.style.display = "none";
    }
  });
}

});