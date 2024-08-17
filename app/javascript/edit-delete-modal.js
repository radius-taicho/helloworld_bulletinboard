document.addEventListener("turbo:load", function() {
  // 要素の取得
  const hoverImage = document.getElementById("hover-bomb-image");
  const modalButtons = document.getElementById("modal-buttons");
  const postFormModal = document.getElementById("post-form-modal");
  const showDeleteModal = document.getElementById("delete-modal");
  const closeButton = document.querySelector('.close-button');
  const deleteCancelButton = document.getElementById("cancel-complete-button");
  const editThreadBtn = document.getElementById("edit-thread-btn");
  const deleteThreadBtn = document.getElementById("delete-thread-btn");
  const postId = editThreadBtn ? editThreadBtn.dataset.postId : null;

  // 必須要素が存在しない場合は処理を終了
  if (!hoverImage || !postId) return null;

  // モーダルを閉じる関数
  function closeModal(modal) {
    if (modal) {
      modal.style.display = 'none';
    }
  }

  // `hoverImage` が存在する場合のみ、クリックイベントを設定
  hoverImage.addEventListener("click", function() {
    modalButtons.style.display = "block";
  });

  // クリックでモーダルを閉じる処理
  window.addEventListener('click', (event) => {
    if (event.target === hoverImage || modalButtons.contains(event.target)) {
      return; // クリックが `hoverImage` または `modalButtons` の内部の場合は何もしない
    }

    if (modalButtons.style.display === 'block' && !modalButtons.contains(event.target)) {
      modalButtons.style.display = 'none'; // modalButtons以外がクリックされたら非表示にする
    }

    if (event.target === postFormModal) {
      closeModal(postFormModal);
    } else if (event.target === showDeleteModal || event.target === deleteCancelButton) {
      closeModal(showDeleteModal);
    }
  });

  // 編集ボタンが存在する場合のみ、クリックイベントを設定
  if (editThreadBtn) {
    // ページ読み込み時に投稿の作成時間をチェック
    fetch(`/posts/${postId}.json`)
      .then(response => response.json())
      .then(data => {
        const postCreatedAt = new Date(data.post.created_at);
        const currentTime = new Date();
        const timeDifference = (currentTime - postCreatedAt) / 1000 / 60; // ミリ秒を分に変換

        if (timeDifference > 10) {
          editThreadBtn.style.display = 'none';
        } else {
          editThreadBtn.addEventListener("click", function(event) {
            event.preventDefault();

            fetch(`/posts/${postId}/edit.json`)
              .then(response => response.json())
              .then(data => {
                document.querySelector('#modal-body').innerHTML = data.form;
                postFormModal.style.display = 'block';
              })
              .catch(error => console.error('Error:', error));
          });
        }
      })
      .catch(error => console.error('Error:', error));
  }

  // 削除ボタンが存在する場合のみ、クリックイベントを設定
  if (deleteThreadBtn) {
    deleteThreadBtn.addEventListener("click", function() {
      showDeleteModal.style.display = 'block';
    });
  }

  // モーダルを閉じるボタンが存在する場合のみ、クリックイベントを設定
  if (closeButton) {
    closeButton.addEventListener('click', () => {
      closeModal(postFormModal);
      closeModal(showDeleteModal);
    });
  }

  // モーダル内のフォーム送信を非同期に処理
  document.addEventListener('submit', function(event) {
    if (event.target.matches('#post-form')) {
      event.preventDefault();
      const form = event.target;
      const formData = new FormData(form);

      fetch(form.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.errors) {
          // エラーメッセージの表示（必要に応じて実装）
          console.error(data.errors);
        } else {
          // 成功した場合、モーダルを閉じてページをリロード
          closeModal(postFormModal);
          location.reload(); // ページをリロードする
        }
      })
      .catch(error => console.error('Error:', error));
    }
  });
});
