document.addEventListener("turbo:load", () => {
  // モーダルの表示/非表示を制御
  const notificationCheckButton = document.querySelector(".notification-image");
  const notificationModal = document.querySelector(".notification-modal");

  if (notificationCheckButton && notificationModal) {
    notificationCheckButton.addEventListener("click", () => {
      notificationModal.style.display = "block";
    });

    window.addEventListener("click", (event) => {
      // モーダル外をクリックしたら閉じる
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
      const userId = event.target.dataset.userId; // ユーザーIDを取得

      fetch(url, {
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(response => {
        if (!response.ok) throw new Error('リクエストが失敗しました');
        return response.json();
      }).then(data => {
        // 承認後に通知を送信
        fetch(`/notifications/approval`, {
          method: 'PATCH',
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ user_id: userId })
        }).then(response => {
          if (!response.ok) throw new Error('通知の送信に失敗しました');
          return response.json();
        }).then(notificationData => {
          alert(notificationData.message);
          location.reload(); // 必要に応じてページをリロード
        }).catch(error => {
          console.error(error);
          alert('通知の送信に失敗しました');
        });
      }).catch(error => {
        console.error(error);
        alert('承認に失敗しました');
      });
    });
  });

  // 拒否ボタンの処理
  document.querySelectorAll('.reject-request-button').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      const url = event.target.getAttribute('href');
      const userId = event.target.dataset.userId; // ユーザーIDを取得

      fetch(url, {
        method: 'PATCH',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      }).then(response => {
        if (!response.ok) throw new Error('リクエストが失敗しました');
        return response.json();
      }).then(data => {
        // 拒否後に通知を送信
        fetch(`/notifications/rejection`, {
          method: 'PATCH',
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
          },
          body: JSON.stringify({ user_id: userId })
        }).then(response => {
          if (!response.ok) throw new Error('通知の送信に失敗しました');
          return response.json();
        }).then(notificationData => {
          alert(notificationData.message);
          location.reload(); // 必要に応じてページをリロード
        }).catch(error => {
          console.error(error);
          alert('通知の送信に失敗しました');
        });
      }).catch(error => {
        console.error(error);
        alert('拒否に失敗しました');
      });
    });
  });
});
