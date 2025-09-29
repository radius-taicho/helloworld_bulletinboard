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

  // 追加する Hello Command ボタン
  const helloCommand = document.querySelector(".hello-command");

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

      // HP更新
      updateUserHp(data.user_hp, data.user_max_hp);

      logs = Array.isArray(data.log) ? data.log : [data.log];
      currentLogIndex = 0;

      if (data.battle_over) {
        userOptionsView.style.display = "none";
        logArea.style.display = "block";
        logArea.style.pointerEvents = "none";
        currentLogIndex = 0;
        
        function showAllLogsAndRedirect() {
            if (currentLogIndex < logs.length) {
                logArea.innerHTML = `<p>${logs[currentLogIndex]}</p>`;
                currentLogIndex++;
                setTimeout(showAllLogsAndRedirect, 1000);
            } else {
                setTimeout(() => {
                    const gameId = document.getElementById('game-container').dataset.gameId;
                    window.location.href = `/games/${gameId}/result`;
                }, 1000);
            }
        }
    
        showAllLogsAndRedirect();
      } else {
        if (logs.length === 0) {
          userOptionsView.style.display = "none";
          logArea.innerHTML = "<p>ログがありません。</p>";
        } else {
          userOptionsView.style.display = "none";
          logArea.style.display = "block";
          showNextLog();
        }

        const allLogs = data.log.join(" ");
        if (command === "escape" && allLogs.includes("逃げ切った")) {
          logArea.removeEventListener("click", showNextLog);
          logArea.innerHTML = `<p>${data.log.join(" ")}</p>`;
          setTimeout(() => {
            const gameId = document.getElementById('game-container').dataset.gameId;
            window.location.href = `/games/${gameId}/result`;
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
    console.log("HPを更新します。現在のHP:", currentHp, "最大HP:", maxHp);
    userHpDisplay.innerHTML = `HP: ${currentHp}/${maxHp}`;
    console.log("HPが更新されました。");
  }

  function showNextLog() {
    if (currentLogIndex < logs.length) {
      logArea.innerHTML = `<p>${logs[currentLogIndex]}</p>`;
      currentLogIndex++;
    } else {
      logArea.style.display = "none"; 
      userOptionsView.style.display = "flex";
    }
  }

  logArea.addEventListener('click', showNextLog);

  skillCommand.addEventListener("click", () => {
    userOptionsView.style.display = "none";
    logArea.style.display = "none";
    userSkillView.style.display = "flex";
    userSkillView.style.flexDirection = "column";
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

  // Hello Command にイベントを追加
  helloCommand.addEventListener("click", function() {
    userSkillView.style.display = "none";
    logArea.style.display = "block";
    executeCommand("hello");
  });
});
