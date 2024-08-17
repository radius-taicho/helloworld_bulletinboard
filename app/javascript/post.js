document.addEventListener("turbo:load", () => {
  // DOM 要素の取得
  const showPostFormButton = document.getElementById('show-post-form');
  const postFormModal = document.getElementById('post-form-modal');
  const closeButton = document.querySelector('.close-button');
  const postForm = document.getElementById('post-form');
  const fileInput = document.querySelector('input[type="file"]');
  const customUploadButton = document.getElementById("custom-upload-button");

  // 要素がnullの場合に処理を終了
  if (!showPostFormButton) return null;

  // モーダルの表示・非表示を制御する関数
  const initializeModal = () => {
    showPostFormButton.addEventListener('click', () => {
      postFormModal.style.display = 'block';
    });

    closeButton.addEventListener('click', () => {
      postFormModal.style.display = 'none';
    });

    window.addEventListener('click', (event) => {
      if (event.target === postFormModal) {
        postFormModal.style.display = 'none';
      }
    });
  };

  // 投稿処理関数
  const handlePostSubmit = () => {
    postForm.addEventListener('submit', (event) => {
      event.preventDefault(); // フォームのデフォルトの送信を防ぐ

      const formData = new FormData(postForm); // フォームデータを取得
      const XHR = new XMLHttpRequest();
      XHR.open("POST", "/posts", true);
      XHR.responseType = "json";

      // リクエスト成功時の処理
      XHR.onload = () => {
        if (XHR.status === 201 || XHR.status === 200) {
          const post = XHR.response;

          if (post && post.title) {
            // 投稿が成功した場合、ページをリロードして最新の内容を表示
            location.reload();
          } else {
            console.error("Error: Received invalid post data from server.");
          }
        } else {
          console.error(`HTTP Error ${XHR.status}: ${XHR.statusText}`);
        }
      };

      // リクエスト失敗時の処理
      XHR.onerror = () => {
        console.error('Request failed due to network error.');
      };

      // フォームデータをサーバーに送信
      XHR.send(formData);
    });
  };

  // カスタムアップロードボタンのイベントリスナー
  customUploadButton.addEventListener("click", function() {
    fileInput.click();
  });

  // モーダルと投稿フォームのイベントリスナーを初期化
  initializeModal();
  handlePostSubmit();
});
