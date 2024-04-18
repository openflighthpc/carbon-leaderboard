$(document).ready(async () => {
  // add report
  // await fetch(new Request(
  //   '/add-record',
  //   {
  //     method: 'POST',
  //     body: JSON.stringify({
  //       'platform': 'Some University',
  //       'cpus': 1,
  //       'cores_per_cpu': 10,
  //       'ram_units': 2,
  //       'ram_capacity_per_unit': 16,
  //       'min': 30,
  //       'half': 40,
  //       'max': 67,
  //       'current': 32,
  //       'location': 'US'
  //     })
  //   }
  // ));

  const leaderboardResponse = await fetch(
    '/leaderboard/raw-data',
    {
      method: 'GET'
    }
  );
  const {max_main, header, reports} = await leaderboardResponse.json();
  $('leaderboard-bar-value-wrapper').text(header.main);
  delete header.main;
  const columns = Object.keys(header);
  for (const column of columns){
    $('#leaderboard-bar-header-wrapper').append(`<div class="leaderboard-header ${column.replace(/_/g, '-')}-column">${header[column]}</div>`);
  }
  for (const report of reports) {
    let barHTML= '';
    for (const column of columns) {
      barHTML += `<div class="leaderboard-item ${column.replace(/_/g, '-')}-column">${report[column]}</div>`;
    }
    $('.leaderboard-content-wrapper').append(`
      <div class="leaderboard-item-wrapper rank-${report.rank < 4 ? report.rank : 'other'}">
        <div class="leaderboard-item glare"></div>
        <div class="leaderboard-item rank-column">${report.rank}</div>
        <div class="leaderboard-item bar-column" style="--flight-bar-scale: ${report.main / max_main}">
          <div class="leaderboard-item bar-data">${barHTML}</div>
        </div>
        <div class="value-column">${report.main}</div>
      </div>
    `);
  }

  $('#leaderboard-wrapper .leaderboard-content-wrapper').on('mousemove', (e) => {
    const leaderboardDimensions = $('#leaderboard-wrapper .leaderboard-header-wrapper').get(0).getBoundingClientRect();
    const glareTranslateX = e.clientX - leaderboardDimensions.left;

    for (const glareDom of document.getElementsByClassName('leaderboard-item glare')) {
        glareDom.style.transform = `translateX(${glareTranslateX}px)`;
    }
  });
});