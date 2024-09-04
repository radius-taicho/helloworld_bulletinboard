document.addEventListener("turbo:load", () => {
  // すべてのカスタムファイルアップロード要素を取得
  const customFileUploads = document.querySelectorAll(".custom-file-upload");

  customFileUploads.forEach(fileUpload => {
    // 現在のファイルアップロード要素内でボタンとファイル入力を取得
    const uploadButton = fileUpload.querySelector(".custom-upload-button");
    const fileInput = fileUpload.querySelector(".media-file-post");

    if (uploadButton && fileInput) {
      // ボタンがクリックされたときに対応するファイル入力をトリガー
      uploadButton.addEventListener('click', () => {
        fileInput.click();
      });
    }
  });
});
