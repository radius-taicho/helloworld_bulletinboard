import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  const roomElement = document.querySelector('.message-wrapper');
  const roomId = roomElement?.dataset.roomId;
  const currentUserId = roomElement?.dataset.currentUserId; // 現在のユーザーIDを取得

  if (roomId && currentUserId) {
    // 既存のサブスクリプションがある場合はキャンセルする
    if (window.roomSubscription) {
      window.roomSubscription.unsubscribe();
    }

    // 新しいサブスクリプションを作成
    window.roomSubscription = consumer.subscriptions.create({ channel: "RoomChannel", room_id: roomId }, {
      received(data) {
        const messageBox = document.querySelector('.message-box');

        // メッセージのデータを取得
        const { content, sender_id, sender_nickname } = data.message;
        const isCurrentUser = sender_id === currentUserId; // 現在のユーザーかどうかを判断

        // メッセージ要素を作成
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message');
        messageDiv.classList.add(isCurrentUser ? 'message-right' : 'message-left'); // クラスを追加

        // メッセージのHTMLを設定
        messageDiv.innerHTML = `
          <p>${content || 'No content'}</p>
          <strong class="${isCurrentUser ? 'right-messenger-name' : 'left-messenger-name'}">
            ${sender_nickname || 'Unknown sender'}
          </strong>
        `;

        // メッセージボックスに新しいメッセージを追加
        messageBox.appendChild(messageDiv);

        // スクロール位置を調整
        messageBox.scrollTop = messageBox.scrollHeight;
      }
    });
  }
});

