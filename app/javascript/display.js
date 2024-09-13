document.addEventListener("turbo:load", () => {
  const myPostsListButton = document.querySelector(".users-post-list-button");
  const myDmListButton = document.querySelector(".direct-message-list-button");
  const myCharacterCollectionButton = document.querySelector(".character-collection-list-button");

  const myPostsListDisplay = document.getElementById("my-posts-list-display");
  const myDmListDisplay = document.getElementById("my-dm-list-display");
  const myCharacterCollectionList = document.getElementById("my-character-collection-list");

  if (!myPostsListDisplay || !myDmListDisplay || !myCharacterCollectionList) return;

  // 投稿一覧ボタン
  myPostsListButton.addEventListener("click", () => {
    myPostsListDisplay.style.display = "block";
    myDmListDisplay.style.display = "none";
    myCharacterCollectionList.style.display = "none";
  });

  // DM一覧ボタン
  myDmListButton.addEventListener("click", () => {
    myPostsListDisplay.style.display = "none";
    myDmListDisplay.style.display = "block";
    myCharacterCollectionList.style.display = "none";
  });

  // 仲間図鑑ボタン
  myCharacterCollectionButton.addEventListener("click", () => {
    myPostsListDisplay.style.display = "none";
    myDmListDisplay.style.display = "none";
    myCharacterCollectionList.style.display = "block";
  });
});
