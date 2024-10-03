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

  // 要素が存在しない場合は処理を中断
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
  
      // ログの処理
      logs = Array.isArray(data.log) ? data.log : [data.log];
      currentLogIndex = 0; // ログインデックスをリセット
  
      if (data.battle_over) {
        userOptionsView.style.display = "none";
        logArea.style.display = "block";
        logArea.style.pointerEvents = "none"; // クリックを無効にする
        currentLogIndex = 0; // ログインデックスをリセット
        
        // 全てのログが表示されたらリザルトに遷移
        function showAllLogsAndRedirect() {
            if (currentLogIndex < logs.length) {
                logArea.innerHTML = `<p>${logs[currentLogIndex]}</p>`;
                currentLogIndex++;
                setTimeout(showAllLogsAndRedirect, 1000); // 1秒後に次のログを表示
            } else {
                // 最後のログが表示された後にリダイレクト
                setTimeout(() => {
                    window.location.href = '/results';
                }, 1000);
            }
        }
    
        showAllLogsAndRedirect(); // 全てのログを表示する関数を呼び出す
      } else {
        // 通常の処理
        if (logs.length === 0) {
          userOptionsView.style.display = "none";
          logArea.innerHTML = "<p>ログがありません。</p>";
        } else {
          userOptionsView.style.display = "none";
          logArea.style.display = "block";
          showNextLog(); // ログ表示を開始
        }

        // 逃走成功の場合の処理
        if (command === "escape" && data.log.includes("逃げ切った")) {
          logArea.removeEventListener("click", showNextLog); // イベントリスナーを削除
          logArea.innerHTML = `<p>${data.log.join(" ")}</p>`; // 一気に表示
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
      logArea.innerHTML = `<p>${logs[currentLogIndex]}</p>`;
      currentLogIndex++;
    } else {
      // すべてのログを表示した後の処理
      logArea.style.display = "none"; 
      userOptionsView.style.display = "flex";
    }
  }

  logArea.addEventListener('click', showNextLog); // ログエリアをクリックして次のログを表示

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
