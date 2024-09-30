document.addEventListener("turbo:load", () => {
  // スクロールボタンの処理
  const container = document.querySelector('.edit-profile-image-box');
  const imageWidth = container?.querySelector('img')?.offsetWidth;
  const rightScrollButton = document.querySelector(".scroll-button.right");
  const leftScrollButton = document.querySelector(".scroll-button.left");

  if (container && imageWidth && rightScrollButton && leftScrollButton) {
    leftScrollButton.addEventListener("click", () => {
      container.scrollBy({ left: -imageWidth * 3, behavior: 'smooth' });
    });
  
    rightScrollButton.addEventListener("click", () => {
      container.scrollBy({ left: imageWidth * 3, behavior: 'smooth' });
    });
  }

  // クリックされた画像をプロフィール画像に反映し、隠しフィールドにセットする処理
  const profileImages = document.querySelectorAll('.edit-profile-image-box img');
  const userImageBox = document.querySelector('.edit-profile-user-image');
  const hiddenProfileImageInput = document.getElementById('selected-profile-image'); // 隠しフィールド

  profileImages.forEach(image => {
    image.addEventListener('click', () => {
      const selectedImageSrc = image.getAttribute('src');
      // プロフィール画像ボックスに選択された画像を表示
      userImageBox.innerHTML = `<img src="${selectedImageSrc}" alt="Selected profile image" width="256px" height="256px">`;

      // 選択された画像のURLを隠しフィールドにセット
      hiddenProfileImageInput.value = selectedImageSrc;
    });
  });
});
