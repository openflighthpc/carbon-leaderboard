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
  let stepNumber = 1;
  const cards = document.getElementsByClassName('step-card');
  if (yesButton().checked) {
    for (let i = 0; i < cards.length; i++) {
      let card = cards[i];
      if (card.dataset.online === 'true') {
        card.style.display = 'block';
        card.getElementsByClassName('step-number')[0].innerHTML = stepNumber;
        stepNumber++;
      } else {
        card.style.display = 'none';
      }
    }
  } else {
    for (let i = 0; i < cards.length; i++) {
      let card = cards[i];
      if (card.dataset.offline === 'true') {
        card.style.display = 'block';
        card.getElementsByClassName('step-number')[0].innerHTML = stepNumber;
        stepNumber++;
      } else {
        card.style.display = 'none';
      }
    }
  }
}
