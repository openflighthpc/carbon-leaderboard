document.addEventListener('turbo:load', async () => {
  // console.log('start add');
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
  const response = await fetch(
    '/leaderboard/raw-data',
    {
      method: 'GET'
    }
  );
  console.log(await response.text());
});
