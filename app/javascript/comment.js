document.addEventListener("turbo:load", () => {
  const commentModalWindow = document.getElementById("comment-modal-window");
  const addCommentButton = document.getElementById("add-comment-button");
  const closeModalButton = document.querySelector('.close-modal-button');
  const commentForm = document.getElementById("comment-form");
  const commentsContainer = document.getElementById('comments-container');

  if (!commentModalWindow || !addCommentButton || !commentForm || !commentsContainer) return;

  const formatDate = (isoDateString) => {
    const date = new Date(isoDateString);
    return date.toLocaleString('ja-JP');
  };

  let isModalOpen = false;

  function closeModal(modal) {
    if (modal) {
      modal.style.display = 'none';
      isModalOpen = false; // モーダルを閉じると状態を更新
    }
  }

  addCommentButton.addEventListener("click", () => {
    commentModalWindow.style.display = "block";
    isModalOpen = true; // モーダルを開くと状態を更新
  });

  if (closeModalButton) {
    closeModalButton.addEventListener('click', () => {
      closeModal(commentModalWindow);
    });
  }

  window.addEventListener("click", (event) => {
    if (event.target === commentModalWindow) {
      closeModal(commentModalWindow);
    }
  });

  if (commentForm) {
    commentForm.addEventListener('submit', (event) => {
      event.preventDefault();
      
      const formData = new FormData(commentForm);
      const postId = formData.get('post_id');
      
      fetch(`/posts/${postId}/comments`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Accept': 'application/json',
        },
        body: formData,
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          const currentUserId = data.current_user_id;
          addCommentToList(data.comment, currentUserId);
          commentForm.reset();
          closeModal(commentModalWindow);
          refreshComments(); // 新しく追加されたコメントを再取得
        } else {
          console.error('Error:', data.error);
        }
      })
      .catch(error => console.error('Error:', error));
    });
  }

  function addCommentToList(comment, currentUserId) {
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
        ${parseInt(comment.user.id) === parseInt(currentUserId) ? `
          <img src="/assets/meat-bomb1.png" alt="meatballmenu image" class="meatball-menu-image hover-bomb-image" data-comment-id="${comment.id}">
          <div class="comment-edit-delete-modal-buttons" data-comment-id="${comment.id}">
            <button class="edit-comment-button" data-comment-id="${comment.id}" data-post-id="${comment.post_id}">Edit</button>
            <button class="delete-comment-button" data-comment-id="${comment.id}" data-post-id="${comment.post_id}">Delete</button>
          </div>
          <div class="edit-comment-modal" data-comment-id="${comment.id}">
            <div class="comment-content">
              <span class="close-modal-button">&times;</span>
              <div class="edit-comment-body" data-comment-id="${comment.id}">
              </div>
            </div>
          </div>
          <div class="delete-comment-modal" data-comment-id="${comment.id}">
            <div class="comment-delete-box">
              <div class="delete-details">
                ※コメント内容を編集できるのは10分以内の一回のみ。削除できるのは投稿から30分以内までです。
              </div>
              <a href="/posts/${comment.post_id}/comments/${comment.id}" data-turbo-method="delete" class="delete-comment-link">削除</a>
              <button class="cancel-complete-button delete-cancel">キャンセル</button>
            </div>
          </div>
        ` : ''}
      </div>
    `;
    
    commentsContainer.insertAdjacentHTML('beforeend', commentHTML);
    attachHoverBombListeners(comment.id);
  }

  function refreshComments() {
    if (isModalOpen) return; // モーダルが開いている場合は更新しない

    const postIdElement = document.querySelector('[name="post_id"]');
    if (!postIdElement) {
      return;
    }
  
    const postId = postIdElement.value;
  
    fetch(`/posts/${postId}/comments/latest`, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
      },
    })
    .then(response => response.json())
    .then(data => {
      commentsContainer.innerHTML = ''; // 既存のコメントをクリア
      data.comments.forEach(comment => {
        addCommentToList(comment, data.current_user_id);
      });
    })
    .catch(error => console.error('Error fetching comments:', error));
  }

  function attachHoverBombListeners(commentId) {
    const hoverBombImage = document.querySelector(`.hover-bomb-image[data-comment-id="${commentId}"]`);
    const editAndDeleteCommentButtons = document.querySelector(`.comment-edit-delete-modal-buttons[data-comment-id="${commentId}"]`);
    const editCommentButton = document.querySelector(`.edit-comment-button[data-comment-id="${commentId}"]`);
    const editCommentModal = document.querySelector(`.edit-comment-modal[data-comment-id="${commentId}"]`);
    const deleteCommentButton = document.querySelector(`.delete-comment-button[data-comment-id="${commentId}"]`);
    const deleteCommentModal = document.querySelector(`.delete-comment-modal[data-comment-id="${commentId}"]`);
    const cancelDeleteCommentButton = deleteCommentModal?.querySelector('.cancel-complete-button');
  
    if (hoverBombImage) {
      hoverBombImage.addEventListener("click", () => {
        if (editAndDeleteCommentButtons) {
          editAndDeleteCommentButtons.style.display = editAndDeleteCommentButtons.style.display === "block" ? "none" : "block";
          if (editAndDeleteCommentButtons.style.display === "block") 
            isModalOpen = true;
        }
      });
    }
  
    window.addEventListener("click", (event) => {
      if (!hoverBombImage?.contains(event.target) && !editAndDeleteCommentButtons?.contains(event.target)) {
        if (editAndDeleteCommentButtons) {
          editAndDeleteCommentButtons.style.display = "none";
        }
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
        if (deleteCommentModal) {
          deleteCommentModal.style.display = "block";
          isModalOpen = true; // モーダルを開くと状態を更新
        }
      });
    }
  
    if (editCommentButton) {
      editCommentButton.addEventListener("click", () => {
        const postId = editCommentButton.dataset.postId;
        const commentId = editCommentButton.dataset.commentId;
  
        fetch(`/posts/${postId}/comments/${commentId}.json`)
          .then(response => response.json())
          .then(data => {
            if (data.form) {
              if (editCommentModal) {
                const commentBody = editCommentModal.querySelector('.edit-comment-body');
                if (commentBody) {
                  commentBody.innerHTML = data.form;
                  editCommentModal.style.display = 'block';
                  isModalOpen = true; // モーダルを開くと状態を更新
                } else {
                  console.warn('Warning: editCommentModal does not contain .edit-comment-body');
                }
              } else {
                console.warn('Warning: editCommentModal is not available');
              }
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
      cancelDeleteCommentButton.addEventListener("click", () => {
        if (deleteCommentModal) {
          deleteCommentModal.style.display = "none";
        }
      });
    }
  }
  
  // 5秒ごとに最新のコメントを取得
  setInterval(refreshComments, 8000);
});
