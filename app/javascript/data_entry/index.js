document.addEventListener("DOMContentLoaded", function(){
  updateInstructions();
  setCodeBlockWidth();

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

function setCodeBlockWidth() {
  const codeWrappers = document.querySelectorAll(".step-wrapper .code-block");
  for (let i = 0; i < codeWrappers.length; i++) {
    let wrapper = codeWrappers[i];
    let stepContainer = wrapper.closest("div.step-wrapper");
    wrapper.style.maxWidth = `${stepContainer.getBoundingClientRect().width - 64}px`;
  }
}
