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

  // 必須要素が存在しない場合は処理を終了
  if (!hoverImage) return null;

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
    editThreadBtn.addEventListener("click", function() {
      postFormModal.style.display = 'block';
    });
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
});
