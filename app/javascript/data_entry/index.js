document.addEventListener("DOMContentLoaded", function(){
  updateInstructions();

  yesButton().onclick = updateInstructions;
  noButton().onclick = updateInstructions;
});

function yesButton() {
  return document.getElementById('radio-yes');
}

function noButton() {
  return document.getElementById('radio-no');
}

function updateInstructions() {
  if (yesButton().checked) {
    const cards = document.getElementsByClassName('step-card');
    for (let i = 0; i < cards.length; i++) {
      let card = cards[i];
      if (card.dataset.online === 'true') {
        card.style.display = 'block';
      } else {
        card.style.display = 'none';
      }
    }
  } else {
    const cards = document.getElementsByClassName('step-card');
    for (let i = 0; i < cards.length; i++) {
      let card = cards[i];
      if (card.dataset.offline === 'true') {
        card.style.display = 'block';
      } else {
        card.style.display = 'none';
      }
    }
  }
}
