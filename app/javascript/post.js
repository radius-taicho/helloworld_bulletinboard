document.addEventListener("turbo:load", () => {
  // DOM 要素の取得
  const showPostFormButton = document.getElementById('show-post-form');
  const postFormModal = document.getElementById('post-form-modal');
  const closeButton = document.querySelector('.close-button');
  const postForm = document.getElementById('post-form');
  const postsList = document.getElementById("posts-list");

  // HTML ビルダー関数: 新しい投稿のHTMLを作成
  const buildHTML = (post) => `
    <div class="post">
      <h2>${post.title}</h2>
      <p>${post.content}</p>
    </div>`;

  // モーダルの表示・非表示を制御する関数
  const initializeModal = () => {
    if (showPostFormButton && postFormModal && closeButton && postForm) {
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
    }
  };

  // 投稿処理関数
  const handlePostSubmit = () => {
    if (postForm) {
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
        
            if (post && post.title && post.content) {
              const html = buildHTML(post);
              postsList.insertAdjacentHTML("afterbegin", html);
              postForm.reset();
              postFormModal.style.display = 'none';
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
    }
  };

  // モーダルと投稿フォームのイベントリスナーを初期化
  initializeModal();
  handlePostSubmit();
});
