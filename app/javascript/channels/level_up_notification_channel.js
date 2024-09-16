import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const levelUpModal = document.querySelector('.level-up-modal');

  if (!levelUpModal) return;

  if (sessionStorage.getItem('levelUpMessageDisplayed') !== 'true') {
    consumer.subscriptions.create("LevelUpNotificationChannel", {
      received(data) {
        console.log("Received data:", data); // 受信データをログに出力
        showLevelUpModal(levelUpModal, data);
        sessionStorage.setItem('levelUpMessageDisplayed', 'true');
      }
    });
  }

  function showLevelUpModal(modal, messages) {
    const levelUpMessageElement = modal.querySelector('.level-up-message');
    const skillGetMessageElement = modal.querySelector('.skill-get-message');
    const itemGetMessageElement = modal.querySelector('.item-get-message');
    const nextExperiencePointMessageElement = modal.querySelector('.next-experience-point-message');
    const requiredCommentCountMessageElement = modal.querySelector('.required-comment-count-message');

    if (messages.level_up_message) {
      levelUpMessageElement.innerText = messages.level_up_message;
    }
    if (messages.skill_get_message) {
      skillGetMessageElement.innerText = messages.skill_get_message;
    }
    if (messages.item_get_message) {
      itemGetMessageElement.innerText = messages.item_get_message;
    }
    if (messages.next_experience_point) {
      nextExperiencePointMessageElement.innerText = messages.next_experience_point;
    }
    if (messages.required_comment_count) {
      requiredCommentCountMessageElement.innerText = messages.required_comment_count;
    }

    modal.style.display = "flex";
    console.log(`Modal displayed: ${modal.style.display}`);
  }

  window.addEventListener("click", (event) => {
    if (event.target === levelUpModal || event.target.classList.contains('close')) {
      levelUpModal.style.display = "none";
      sessionStorage.removeItem('levelUpMessageDisplayed');
      location.reload();
    }
  });
});
