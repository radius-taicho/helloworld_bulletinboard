document.addEventListener("turbo:load", () => {

  const skillCommand = document.getElementById("user-skill-command");
  const userOptionsView = document.getElementById("user-options-view");
  const userSkillView = document.getElementById("user-skill-view");
  const backButton = document.querySelector(".game-back-button");
  const escapeButton = document.querySelector(".escape-command"); // 修正
  const messageArea = document.querySelector(".message-area"); // 修正

  if (!skillCommand || !userOptionsView || !userSkillView || !escapeButton || !messageArea) return;

  skillCommand.addEventListener("click", () => {
    userOptionsView.style.display = "none";
    userSkillView.style.display = "flex";
  });

  backButton.addEventListener("click", () => {
    userSkillView.style.display = "none";
    userOptionsView.style.display = "flex";
  });

  escapeButton.addEventListener('click', function() { // 修正
    fetch('/escape', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      }
    })
    .then(response => response.json())
    .then(data => {
      // text-messageボックスに結果を表示
      userOptionsView.style.display = "none";
      messageArea.innerText = data.message; // 修正

      // 逃げ切った場合は2秒後にresults#indexに遷移
      if (data.message.includes("逃げ切った")) {
        setTimeout(() => {
          window.location.href = '/results'; // 遷移先のURL
        }, 2000); // 2000ミリ秒（2秒）
      }
    })
    .catch(error => {
      console.error('Error:', error);
      userOptionsView.style.display = "none";
      messageArea.innerText = "エラーが発生しました。"; // 修正
    });
  });

});
