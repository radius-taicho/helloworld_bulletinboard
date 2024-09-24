document.addEventListener("turbo:load", ()=>{

const skillButton = document.getElementById("user-skill-button");
const userOptionsView = document.getElementById("user-options-view");
const userSkillView = document.getElementById("user-skill-view");
const backButton = document.querySelector(".game-back-button")


if (!skillButton||!userOptionsView||!userSkillView) return

skillButton.addEventListener("click", ()=>{
  userOptionsView.style.display = "none"
  userSkillView.style.display = "flex"
})

backButton.addEventListener("click", ()=>{
  userSkillView.style.display = "none"
  userOptionsView.style.display = "block"
})


});