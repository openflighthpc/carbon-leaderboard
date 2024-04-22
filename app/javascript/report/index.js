$(document).ready(async () => {
  // add report
  // await fetch(new Request(
  //   '/add-record',
  //   {
  //     method: 'POST',
  //     body: JSON.stringify({
  //       'user_id': crypto.randomUUID(),
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
  const {max_main, header, devices} = await leaderboardResponse.json();
  $('#leaderboard-bar-value-wrapper').text(header.main);
  delete header.main;
  const columns = Object.keys(header);
  for (const column of columns){
    $('#leaderboard-bar-header-wrapper').append(`<div class="leaderboard-header ${column.replace(/_/g, '-')}-column">${header[column]}</div>`);
  }
  for (const device of devices) {
    let barHTML= '';
    for (const column of columns) {
      barHTML += `<div class="leaderboard-item ${column.replace(/_/g, '-')}-column">${device[column]}</div>`;
    }
    $('.leaderboard-content-wrapper').append(`
      <div class="leaderboard-item-wrapper rank-${device.rank < 4 ? device.rank : 'other'} slanted-shape">
        <div class="leaderboard-item glare"></div>
        <div class="leaderboard-item rank-column">${device.rank}</div>
        <div class="leaderboard-item bar-column" style="--flight-bar-length: ${device.main * 100/ max_main}%">
          <div class="leaderboard-item bar-data">${barHTML}</div>
        </div>
        <div class="value-column">${device.main}</div>
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
