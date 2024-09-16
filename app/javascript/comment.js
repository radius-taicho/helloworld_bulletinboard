document.addEventListener("turbo:load", () => {
  // モーダルウィンドウの要素を取得
  const commentModalWindow = document.getElementById("comment-modal-window");
  const addCommentButton = document.getElementById("add-comment-button");
  const closeModalButton = document.querySelector('.close-modal-button');
  const commentForm = document.getElementById("comment-form");
  const commentsContainer = document.getElementById('comments-container');

  if (!commentModalWindow || !addCommentButton || !commentForm || !commentsContainer) return;

  // 日時文字列をDateオブジェクトに変換
  const formatDate = (isoDateString) => {
    const date = new Date(isoDateString);
    return date.toLocaleString('ja-JP'); // 'ja-JP'は日本語のローカライズ
  };

  // モーダルウィンドウを閉じる関数
  function closeModal(modal) {
    if (modal) {
      modal.style.display = 'none';
    }
  }

  // コメント追加ボタンがクリックされたらモーダルを開く
  addCommentButton.addEventListener("click", function() {
    commentModalWindow.style.display = "block";
  });

  // モーダルウィンドウの「閉じる」ボタンで閉じる
  if (closeModalButton) {
    closeModalButton.addEventListener('click', () => {
      closeModal(commentModalWindow);
    });
  }

  // ウィンドウ外をクリックした場合にモーダルを閉じる
  window.addEventListener("click", function(event) {
    if (event.target === commentModalWindow) {
      commentModalWindow.style.display = "none";
    }
  });

  // 非同期でコメントを追加する処理
  if (commentForm) {
    commentForm.addEventListener('submit', function(event) {
      event.preventDefault();
      
      const formData = new FormData(commentForm);
      const postId = formData.get('post_id');

      console.log(`Submitting comment for post ID: ${postId}`); // デバッグ用ログ

      fetch(`/posts/${postId}/comments`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json',
        },
        body: formData,
      })
      .then(response => {
        console.log(`Response status: ${response.status}`); // レスポンスのステータスコードをログ
        return response.json();
      })
      .then(data => {
        console.log('Response data:', data); // レスポンスデータをログ
        if (data.success) {
          addCommentToList(data.comment);
          commentForm.reset(); // フォームをリセット
          closeModal(commentModalWindow); // コメント送信後にモーダルを閉じる
        } else {
          console.error('Error:', data.error);
        }
      })
      .catch(error => console.error('Error:', error));
    });
  }

  // 新しいコメントをHTMLに追加する関数
  function addCommentToList(comment) {
    if (!commentsContainer) {
      console.error("コメント容器が見つかりません。");
      return;
    }

    const commentHTML = `
      <div class="comment" data-comment-id="${comment.id}">
        <div class="comment-content-box">
          <p>${comment.content}</p>
        </div>

        <div class="commenter">
          <a href="/users/${comment.user.id}?from=nickname" class="post-user-link">by ${comment.user.nickname}</a>
          <br>
          ${formatDate(comment.created_at)}
        </div>
        
        ${comment.user.id === comment.current_user_id ? `
          <img src="/assets/meat-bomb1.png" alt="meatballmenu image" class="meatball-menu-image hover-bomb-image" data-comment-id="${comment.id}">
          <div class="comment-edit-delete-modal-buttons" data-comment-id="${comment.id}">
            <button class="edit-comment-button" data-comment-id="${comment.id}" data-post-id="${comment.post_id}">Edit</button>
            <button class="delete-comment-button" data-comment-id="${comment.id}" data-post-id="${comment.post_id}">Delete</button>
          </div>` : ''
        }
      </div>
    `;

    commentsContainer.insertAdjacentHTML('beforeend', commentHTML);
    
    // デバッグ: HTMLの確認
    console.log("New comment added:", commentHTML);
    console.log("Current comments container HTML:", commentsContainer.innerHTML);
  }
});
