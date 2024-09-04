document.addEventListener("turbo:load", () => {
  // コメントのホバー機能とボタン表示
  const hoverBombImages = document.querySelectorAll(".hover-bomb-image");
  
  hoverBombImages.forEach((hoverBombImage) => {
    const commentId = hoverBombImage.dataset.commentId;
    const editAndDeleteCommentButtons = document.querySelector(`.comment-edit-delete-modal-buttons[data-comment-id='${commentId}']`);
    const editCommentButton = document.querySelector(`.edit-comment-button[data-comment-id='${commentId}']`);
    const editCommentModal = document.querySelector(`.edit-comment-modal[data-comment-id='${commentId}']`);
    const deleteCommentButton = document.querySelector(`.delete-comment-button[data-comment-id='${commentId}']`);
    const deleteCommentModal = document.querySelector(`.delete-comment-modal[data-comment-id='${commentId}']`);
    const cancelDeleteCommentButton = deleteCommentModal?.querySelector('.cancel-complete-button');
  
    if (!hoverBombImage || !editAndDeleteCommentButtons) {
      return;
    }

    hoverBombImage.addEventListener("click", () => {
      editAndDeleteCommentButtons.style.display = editAndDeleteCommentButtons.style.display === "block" ? "none" : "block";
    });

    window.addEventListener("click", (event) => {
      if (!hoverBombImage.contains(event.target) && !editAndDeleteCommentButtons.contains(event.target)) {
        editAndDeleteCommentButtons.style.display = "none";
      }
      if (event.target === deleteCommentModal) {
        deleteCommentModal.style.display = "none";
      }
      if (event.target === editCommentModal) {
        editCommentModal.style.display = "none";
      }
    });

    if (deleteCommentButton) {
      deleteCommentButton.addEventListener("click", () => {
        deleteCommentModal.style.display = "block";
      });
    }

    if (editCommentButton) {
      editCommentButton.addEventListener("click", () => {
        const postId = editCommentButton.dataset.postId;
        
        fetch(`/posts/${postId}/comments/${commentId}.json`)
          .then(response => response.json())
          .then(data => {
            if (data.form) {
              const commentBody = editCommentModal.querySelector('.edit-comment-body');
              commentBody.innerHTML = data.form;
              editCommentModal.style.display = 'block';
            } else {
              console.warn('Warning: data.form is not available');
            }
          })
          .catch(error => {
            console.error('Error during comment fetch:', error);
            alert('コメントの取得中にエラーが発生しました。');
          });
      });
    }

    if (cancelDeleteCommentButton) {
      cancelDeleteCommentButton.addEventListener('click', () => {
        deleteCommentModal.style.display = 'none';
      });
    }
  });

  // フォームの送信処理
  document.addEventListener('submit', (event) => {
    if (event.target.matches('.edit-comment-form')) {
      event.preventDefault();
      const form = event.target;
      const formData = new FormData(form);
      const commentId = form.dataset.commentId;
      const postId = form.dataset.postId;
      const url = `/posts/${postId}/comments/${commentId}`;
      
      if (commentId && postId) {
        fetch(url, {
          method: 'PATCH',
          body: formData,
          headers: {
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            'Accept': 'application/json'
          }
        })
        .then(response => {
          if (!response.ok) {
            return response.json().then(data => { throw new Error(data.errors.join(', ')) });
          }
          return response.json();
        })
        .then(data => {
          const commentElement = document.querySelector(`.comment[data-comment-id='${commentId}'] .comment-content-box p`);
          if (commentElement) {
            commentElement.textContent = data.comment.content;
          }
          document.querySelector(`.edit-comment-modal[data-comment-id='${commentId}']`).style.display = 'none';
          location.reload(); // ページをリロードする
        })
        .catch(error => {
          console.error('Error during comment update:', error);
          alert('コメントの更新中にエラーが発生しました: ' + error.message);
        });
      } else {
        console.error("Form data is missing comment ID or post ID.");
      }
    }
  });
});
