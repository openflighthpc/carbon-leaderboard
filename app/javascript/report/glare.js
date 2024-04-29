$(document).ready(async () => {
  $('.leaderboard-wrapper .leaderboard-content-wrapper').on('mousemove', (e) => {
    let leaderboardDimensions;
    if (document.getElementsByClassName('home-leaderboard').length === 0) {
      leaderboardDimensions = $('.leaderboard-wrapper .leaderboard-header-wrapper').get(0).getBoundingClientRect();
    } else {
      leaderboardDimensions = $('.leaderboard-wrapper .leaderboard-item-wrapper').get(0).getBoundingClientRect();
    }
    const glareTranslateX = e.clientX - leaderboardDimensions.left;

    for (const glareDom of document.getElementsByClassName('leaderboard-item glare')) {
      glareDom.style.transform = `translateX(${glareTranslateX}px)`;
    }
  });
});
