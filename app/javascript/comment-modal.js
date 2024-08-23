document.addEventListener("turbo:load", ()=> {


const commentModalWindow = document.getElementById("comment-modal-window");
const addCommentButton = document.getElementById("add-comment-button");
const closeModalButton = document.querySelector('.close-modal-button');
const commentForm = document.getElementById("comment-form");



if (!commentModalWindow || !addCommentButton || !commentForm) return null;

  // モーダルを閉じる関数
  function closeModal(modal) {
    if (modal) {
      modal.style.display = 'none';
    }
  }

addCommentButton.addEventListener("click", function() {
  commentModalWindow.style.display = "block";
});

if (closeModalButton) {
  closeModalButton.addEventListener('click', () => {
    closeModal(commentModalWindow);
  });
}

window.addEventListener("click", function(event) {
  if (event.target === commentModalWindow) {
    commentModalWindow.style.display = "none";
  }
});

commentForm.addEventListener("submit", function(event) {
  event.preventDefault(); // デフォルトのフォーム送信を無効化

  const formData = new FormData(commentForm);
  const url = commentForm.action;

  fetch(url, {
    method: "POST",
    body: formData,
    headers: {
      "Accept": "application/json" // JSON形式でレスポンスを受け取る
    }
  })
  .then(response => response.json())
  .then(data => {
    if (data.errors) {
      // エラー処理
      console.error("エラー:", data.errors);
      // ここでエラーを表示する処理を追加
    } else {
      // コメント追加処理をここで呼び出す
      // 例えば、`addComment(data)` のような関数で処理する
      // addComment(data);


      closeModal(commentModalWindow); // モーダルを閉じる
      location.reload();
    }
  })
  .catch(error => console.error("Error:", error));
});


});