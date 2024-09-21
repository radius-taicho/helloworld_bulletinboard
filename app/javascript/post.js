document.addEventListener("turbo:load", () => {
  const showPostFormButton = document.getElementById('show-post-form');
  const postFormModal = document.getElementById('post-form-modal');
  const closeButton = document.querySelector('.close-button');
  const postForm = document.getElementById('post-form');
  const postsList = document.getElementById('posts-list');

  if (!showPostFormButton) return;

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

  if (postForm) {
    postForm.addEventListener('submit', (event) => {
      event.preventDefault();

      const formData = new FormData(postForm);

      fetch("/posts", {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: formData
      })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          throw new Error(`HTTP Error ${response.status}: ${response.statusText}`);
        }
      })
      .then(post => {
        if (post && post.title) {
          postFormModal.style.display = 'none';
          addPostToPage(post);
          postForm.reset();
        } else {
          console.error("Error: Received invalid post data from server.");
        }
      })
      .catch(error => {
        console.error('Request failed:', error);
      });
    });
  }

  function addPostToPage(post) {
    const postHTML = `
      <div class="post" id="post-box" data-post-id="${post.id}">
        <div class="post-title-box">
          <h2><a href="/posts/${post.id}" class="post-title-link">${post.title}</a></h2>
        </div>
        <div class="post-contents-media">
          ${post.content ? `
            <div class="post-content-box">
              <p>${truncate(post.content, 300, ' (続く...)')}</p>
            </div>
          ` : ''}
          ${post.image_url ? `
            <div class="post-media-box">
              <img src="${post.image_url}" class="post-media" alt="Post Image">
            </div>
          ` : ''}
        </div>
        <div class="poster">
          <a href="/users/${post.user_id}?from=nickname" class="post-user-link">by ${post.user.nickname}</a>
          <br>
          ${new Date(post.created_at).toLocaleString()}
        </div>
      </div>
    `;

    postsList.insertAdjacentHTML('afterbegin', postHTML);
  }

  function truncate(text, length, omission) {
    return text.length > length ? text.substring(0, length) + omission : text;
  }

  function fetchLatestPosts() {
    fetch('/posts/latest')  // ここを変更
      .then(response => response.json())
      .then(posts => {
        posts.forEach(post => {
          const existingPost = document.querySelector(`[data-post-id="${post.id}"]`);
          if (!existingPost) {
            addPostToPage(post);
          }
        });
      })
      .catch(error => console.error('Error fetching latest posts:', error));
  }

  // 5秒ごとに最新の投稿をフェッチ
  setInterval(fetchLatestPosts, 3000);

});
