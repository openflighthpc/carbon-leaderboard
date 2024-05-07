$(document).ready(async () => {
  // add report
  // await fetch(new Request(
  //   '/add-record',
  //   {
  //     method: 'POST',
  //     body: JSON.stringify({
  //       'device_id': crypto.randomUUID(),
  //       'platform': 'Alces Cloud',
  //       'cpus': 1,
  //       'cores_per_cpu': 10,
  //       'ram_units': 2,
  //       'ram_capacity_per_unit': 16,
  //       'min': 30,
  //       'half': 40,
  //       'max': 56,
  //       'current': 32,
  //       'location': 'US'
  //     })
  //   }
  // ));
  const leaderboardResponse = await fetch(
    '/leaderboard/grouped-data/g_per_hour',
    {
      method: 'GET'
    }
  );
  const {max_main, header, groups} = await leaderboardResponse.json();
  $('#leaderboard-bar-value-wrapper').text(header.main);
  delete header.main;
  const columns = Object.keys(header);
  for (const column of columns){
    $('#leaderboard-bar-header-wrapper').append(`<div class="leaderboard-header ${column.replace(/_/g, '-')}-column">${header[column]}</div>`);
  }
  for (const group of groups) {
    let barHTML= '';
    for (const column of columns) {
      barHTML += `<div class="leaderboard-item ${column.replace(/_/g, '-')}-column">${group[column]}</div>`;
    }
    $('.leaderboard-content-wrapper').append(`
      <a href="/group/${group.group_id}">
        <div class="leaderboard-item-wrapper full-leaderboard rank-${group.rank < 4 ? group.rank : 'other'}">
          <div class="leaderboard-item glare"></div>
          <div class="leaderboard-item rank-column">${group.rank}</div>
          <div class="leaderboard-item bar-column" style="--flight-bar-length: ${group.main * 100/ max_main}%">
            <div class="leaderboard-item bar-data">${barHTML}</div>
          </div>
          <div class="value-column">${group.main + group.unit}</div>
        </div>
      </a>
    `);
  }
});
