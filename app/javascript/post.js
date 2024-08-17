document.addEventListener("turbo:load", () => {
  // DOM 要素の取得
  const showPostFormButton = document.getElementById('show-post-form');
  const postFormModal = document.getElementById('post-form-modal');
  const closeButton = document.querySelector('.close-button');
  const postForm = document.getElementById('post-form');
  const postsList = document.getElementById("posts-list");
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

  // テキストをトランケートする関数
  const truncateText = (text, length) => {
    return text.length > length ? text.substring(0, length) + "(続く...)" : text;
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
            const truncatedContent = post.content ? truncateText(post.content, 100) : '';

            const html = `
            <div class="post">
              <h2><a href="/posts/${post.id}" class="post-title-link">${post.title}</a></h2>
              ${(truncatedContent || post.image_url) ? `
            <div class="post-content-media">
              ${truncatedContent ? `<p>${truncatedContent}</p>` : ''}
              ${post.image_url ? `<img src="${post.image_url}" class="post-media" alt="Post image" />` : ''}
            </div>` : ''}
            <div class="poster">
              ${post.user ? `by ${post.user.nickname}` : ''}
            <br>
              ${new Date(post.created_at).toLocaleString()}
            </div>
            </div>
            `;


            postsList.insertAdjacentHTML("afterbegin", html);

            const images = postsList.querySelectorAll('.post-media');
            images.forEach(img => {
              img.onload = () => {
                img.style.width = '320px'; // 明示的にサイズを指定する
                img.style.height = 'auto';
              };
            });

            const postDetails = postsList.querySelectorAll(".poster");
            postDetails.forEach(postDetail => {
              postDetail.style.textAlign = "right";
            });

            const contentAndMedia = postsList.querySelectorAll(".post-content-media");
            contentAndMedia.forEach(contentMedia => {
              contentMedia.style.display = "flex";
              contentMedia.style.justifyContent = "space-between"; // ここを修正
            });

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
  };

  // カスタムアップロードボタンのイベントリスナー
  customUploadButton.addEventListener("click", function() {
    fileInput.click();
  });

  // モーダルと投稿フォームのイベントリスナーを初期化
  initializeModal();
  handlePostSubmit();
});
