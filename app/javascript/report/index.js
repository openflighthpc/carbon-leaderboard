document.addEventListener('turbo:load', async () => {
  // add report
  // console.log(await fetch(new Request(
  //   '/add-record',
  //   {
  //     method: 'POST',
  //     headers: {
  //       'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MTMzNTYxOTl9._CN5ysusF_6DNn4tuJLBXH105IyoXPd2n7ozMcSdMnM'
  //     },
  //     body: JSON.stringify({
  //       'platform': 'Some University',
  //       'cpus': 1,
  //       'cores_per_cpu': 10,
  //       'ram_units': 2,
  //       'ram_capacity_per_unit': 16,
  //       'min': 30,
  //       'half': 40,
  //       'max': 65,
  //       'current': 32,
  //       'location': 'US'
  //     })
  //   }
  // )));

  const leaderboardResponse = await fetch(
    '/leaderboard/raw-data',
    {
      method: 'GET'
    }
  );
  const {header, reports} = await leaderboardResponse.json();
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
    $('#leaderboard-wrapper').append(`
      <div class="leaderboard-row leaderboard-item">
        <div class="leaderboard-item glare"></div>
        <div class="leaderboard-item rank-column">${report.rank}</div>
        <div class="leaderboard-item bar-column">
          <div class="leaderboard-item bar-data">${barHTML}</div>
        </div>
        <div class="leaderboard-item value-column">${report.main}</div>
      </div>
    `);
  }
});
