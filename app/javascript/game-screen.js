document.addEventListener("turbo:load", function() {
  const logArea = document.querySelector('.message-area');
  const fightCommand = document.querySelector(".fight-command");
  const itemCommand = document.querySelector(".item-command");
  const skillCommand = document.getElementById("user-skill-command");
  const escapeCommand = document.querySelector(".escape-command");
  const backButton = document.querySelector(".game-back-button");
  const userOptionsView = document.getElementById("user-options-view");
  const userSkillView = document.getElementById("user-skill-view");
  const userHpDisplay = document.querySelector('.user-status-information .lower-user-status p');

  let currentLogIndex = 0;
  let logs = [];
  let nextTurn = false;

  if (!fightCommand || !itemCommand || !skillCommand || !escapeCommand || !userOptionsView || !userSkillView || !logArea) return;

  function executeCommand(command) {
    const url = `/games/${document.getElementById('game-container').dataset.gameId}/execute_command`;

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: new URLSearchParams({ command: command })
    })
    .then(response => response.json())
    .then(data => {
      console.log("サーバーから受け取ったデータ:", data);
  
      // HPの更新
      updateUserHp(data.user_hp, data.user_max_hp);
  
      // ログの処理（配列の場合、結合してから判定）
      logs = Array.isArray(data.log) ? data.log : [data.log];
      const combinedLog = logs.join(" ");
  
      // nextTurnをサーバーからの応答で更新
      nextTurn = data.next_turn || false;  // ここでnextTurnを更新

      if (data.battle_over) {
        userOptionsView.style.display = "none";
        logArea.style.display = "block";
        logArea.innerHTML = `<p>${combinedLog}</p>`;
      
        setTimeout(() => {
          window.location.href = '/results';
        }, 2000);
      } else {
        currentLogIndex = 0;
        logArea.innerHTML = "";
  
        if (logs.length === 0) {
          userOptionsView.style.display = "none";
          logArea.innerHTML = "<p>ログがありません。</p>";
        } else {
          userOptionsView.style.display = "none";
          logArea.style.display = "block";
          showNextLog();
        }

        // 逃走成功の場合の処理
        if (command === "escape" && combinedLog.includes("逃げ切った")) {
          logArea.removeEventListener("click", showNextLog); // イベントリスナーを削除
          logArea.innerHTML = `<p>${combinedLog}</p>`;
          setTimeout(() => {
            window.location.href = '/results';
          }, 2000);
        }
      }
    })
    .catch(error => {
      console.error('Error:', error);
      userOptionsView.style.display = "none";
      logArea.innerText = "エラーが発生しました。";
    });
  }

  function updateUserHp(currentHp, maxHp) {
    userHpDisplay.innerHTML = `HP: ${currentHp}/${maxHp}`;
  }

  function showNextLog() {
    if (currentLogIndex < logs.length) {
      userOptionsView.style.display = "none";
      logArea.innerHTML = `<p>${logs[currentLogIndex]}</p>`;
      currentLogIndex++;
    } else if (nextTurn) { // 次のターンがある場合に表示
      logArea.style.display = "none"; 
      userOptionsView.style.display = "flex";
    }
  }

  logArea.addEventListener('click', showNextLog);

  skillCommand.addEventListener("click", () => {
    userOptionsView.style.display = "none";
    logArea.style.display = "none";
    userSkillView.style.display = "flex";
  });

  backButton.addEventListener("click", () => {
    userSkillView.style.display = "none";
    userOptionsView.style.display = "flex";
  });

  escapeCommand.addEventListener('click', function() {
    userOptionsView.style.display = "none";
    executeCommand("escape");
  });

  fightCommand.addEventListener("click", function() {
    userOptionsView.style.display = "none";
    executeCommand("attack");
  });

  itemCommand.addEventListener("click", function() {
    userOptionsView.style.display = "none";
    executeCommand("item");
  });
});
