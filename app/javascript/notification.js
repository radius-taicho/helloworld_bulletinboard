document.addEventListener("turbo:load", () => {
  // モーダルの表示/非表示を制御
  const notificationCheckButton = document.querySelector(".notification-image");
  const notificationModal = document.querySelector(".notification-modal");

  if (notificationCheckButton && notificationModal) {
    notificationCheckButton.addEventListener("click", () => {
      notificationModal.style.display = "block";
    });

    window.addEventListener("click", (event) => {
      if (event.target === notificationModal) {
        notificationModal.style.display = "none";
      }
    });
  }

  // 承認ボタンの処理
  document.querySelectorAll('.approve-request-button').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = event.target.getAttribute('href');
      const requestId = event.target.dataset.id; // ここでIDを取得する

      fetch(url, {
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(response => {
        if (!response.ok) throw new Error('承認リクエストの送信に失敗しました');
        return response.json();
      }).then(data => {
        return fetch(`/notifications/approval`, {
          method: 'PATCH',
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ request_id: requestId }) // IDをここで使用する
        });
      }).then(response => {
        if (!response.ok) throw new Error('通知の送信に失敗しました');
        return response.json();
      }).then(notificationData => {
        // リクエストの要素を削除または更新
        const requestElement = event.target.closest('.direct-message-request'); // リクエストの親要素を取得
        if (requestElement) {
          requestElement.remove(); // リクエスト要素を削除
        }
        alert(notificationData.message);
        location.reload()
      }).catch(error => {
        console.error(error);
        alert('承認処理中にエラーが発生しました');
      });
    });
  });

  // 拒否ボタンの処理
  document.querySelectorAll('.reject-request-button').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = event.target.getAttribute('href');
      const requestId = event.target.dataset.id; // ここでIDを取得する

      fetch(url, {
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(response => {
        if (!response.ok) throw new Error('拒否リクエストの送信に失敗しました');
        return response.json();
      }).then(data => {
        return fetch(`/notifications/rejection`, {
          method: 'PATCH',
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ request_id: requestId }) // IDをここで使用する
        });
      }).then(response => {
        if (!response.ok) throw new Error('通知の送信に失敗しました');
        return response.json();
      }).then(notificationData => {
        // リクエストの要素を削除または更新
        const requestElement = event.target.closest('.direct-message-request'); // リクエストの親要素を取得
        if (requestElement) {
          requestElement.remove(); // リクエスト要素を削除
        }
        alert(notificationData.message);
        location.reload();
      }).catch(error => {
        console.error(error);
        alert('拒否処理中にエラーが発生しました');
      });
    });
  });
});
