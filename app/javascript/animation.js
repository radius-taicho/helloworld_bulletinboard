document.addEventListener("turbo:load", () =>{

const gameStartShoeImage = document.querySelector(".shoes-image");
const gameStartButton = document.querySelector(".start-game-btn");

if (!gameStartButton||!gameStartShoeImage) return

gameStartShoeImage.addEventListener("click", ()=> {
  gameStartButton.click();

});

// メニューボタンとメニューの要素を取得
const menuButton = document.querySelector('.menu-buttons.menu');
const menu = document.getElementById('menu');
const menuCloseButton = document.querySelector(".menu-close-button");

if (!menuButton || !menu || !menuCloseButton) return

// メニューボタンが存在しない場合は処理を中止
if (!menuButton) {
  console.error("メニューボタンが見つかりません");
} else {
  // メニューボタンがクリックされたときにメニューを表示・非表示を切り替える
  menuButton.addEventListener('click', () => {
    menu.classList.toggle('active'); // 'active' クラスの付け外しでスライドを制御
  });

  // 閉じるボタンがクリックされたときの処理
  menuCloseButton.addEventListener('click', () => {
    menu.classList.toggle('active');
  });
}

});
