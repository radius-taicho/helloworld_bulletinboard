import consumer from "./consumer" 
//あとで見直し

document.addEventListener("turbo:load", () => {
  const messageWrapper = document.querySelector('.message-wrapper');
  const messageBox = document.querySelector('.message-box');
  const roomId = messageWrapper?.dataset.roomId;
  const currentUserId = messageWrapper?.dataset.currentUserId;

  if (roomId && currentUserId) {

    function scrollToBottom() {
      messageWrapper.scrollTop = messageWrapper.scrollHeight;
    }

    window.roomSubscription = consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
      received(data) {
        const { content, sender_id, sender_nickname } = data.message;
        const isCurrentUser = sender_id === currentUserId;
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message');
        messageDiv.classList.add(isCurrentUser ? 'message-right' : 'message-left');

        messageDiv.innerHTML = `
          <p>${content || 'No content'}</p>
          <strong class="${isCurrentUser ? 'right-messenger-name' : 'left-messenger-name'}">
            ${sender_nickname || 'Unknown sender'}
          </strong>
        `;

        messageBox.appendChild(messageDiv);

        // 新しいメッセージが追加された後、一番下までスクロール
        scrollToBottom();
      }
    });

    // ページロード時に一番下までスクロール
    scrollToBottom();
  }
});
