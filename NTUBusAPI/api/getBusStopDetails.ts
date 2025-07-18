export const getBusStopDetails = async (): Promise<any> => {
  let result = {};

  const blueBusStopDetailsList = [
    {
      name: "NIE, Opp. LWN Library",
      busStopId: "378225",
    },
    {
      name: "Opp. Hall 3 & 16",
      busStopId: "382999",
    },
    {
      name: "Opp. Hall 14 & 15",
      busStopId: "378203",
    },
    {
      name: "Opp. Saraca Hall",
      busStopId: "383048",
    },
    {
      name: "Opposite Hall 11, bus stop",
      busStopId: "378222",
    },
    {
      name: "Nanyang Height, Opposite Hall 8 Bus Stop",
      busStopId: "383003",
    },
    {
      name: "Hall 6, Opp. Hall 2",
      busStopId: "378234",
    },
    {
      name: "Opp. Hall 4",
      busStopId: "383004",
    },
    {
      name: "Opp. Yunnan Gardens",
      busStopId: "383006",
    },
    {
      name: "Opp. SPMS",
      busStopId: "383009",
    },
    {
      name: "Opp. WKWSCI",
      busStopId: "383010",
    },
    {
      name: "Opp. CEE",
      busStopId: "378226",
    },
  ];
  const redBusStopDetailsList = [
    {
      name: "LWN Library, Opp. NIE",
      busStopId: "378224",
    },
    {
      name: "SBS",
      busStopId: "382995",
    },
    {
      name: "WKWSCI",
      busStopId: "378227",
    },
    // {
    //   name: "Hall 7",
    //   busStopId: "378228",
    // },
    {
      name: "SPMS",
      busStopId: "378228",
    },
    // {
    //   name: "Yunnan Gardens",
    //   busStopId: "378229",
    // },
    {
      name: "Gaia",
      busStopId: "378229",
    },
    {
      name: "Hall 4",
      busStopId: "378230",
    },
    {
      name: "Hall 1 (Blk 18)",
      busStopId: "378233",
    },
    // {
    //   name: "Canteen 2",
    //   busStopId: "378237",
    // },
    {
      name: "Hall 2",
      busStopId: "378237",
    },
    // {
    //   name: "Nanyang Height, Opposite Hall 8 bus stop",
    //   busStopId: "382998",
    // },
    {
      name: "Hall 8 & 9",
      busStopId: "382998",
    },
    {
      name: "Opposite Hall 11 Bus Stop",
      busStopId: "383049",
    },
    // {
    //   name: "Grad Hall 1 & 2",
    //   busStopId: "378202",
    // },
    {
      name: "Hall 11 Blk 55",
      busStopId: "378202",
    },
    {
      name: "Saraca Hall",
      busStopId: "383050",
    },
    {
      name: "Hall 12 & 13",
      busStopId: "378204",
    },
  ];
  const yellowBusStopDetailsList = [
    {
      name: "Campus Clubhouse, NEC",
      busStopId: "383091",
    },
    {
      name: "Blk 96, Staircase 3",
      busStopId: "383090",
    },
    {
      name: "Child Care Centre",
      busStopId: "383093",
    },
    {
      name: "Opposite Hall 11 Bus Stop",
      busStopId: "378222",
    },
    {
      name: "Nanyang Height, Opposite Hall 8 Bus Stop",
      busStopId: "383003",
    },
    {
      name: "University Health Services (SSC Bus Stop)",
      busStopId: "383011",
    },
    {
      name: "Opposite Administration Building",
      busStopId: "383013",
    },
  ];
  const greenBusStopDetailsList = [
    {
      name: "Pioneer MRT Station Exit B at Blk 649A",
      busStopId: "377906",
    },
    {
      name: "Hall 1 (Blk 18)",
      busStopId: "378233",
    },
    // {
    //   name: "Canteen 2",
    //   busStopId: "378237",
    // },
    {
      name: "Hall 2",
      busStopId: "378237",
    },
    {
      name: "University Health Services (SSC Bus Stop)",
      busStopId: "383011",
    },
    // {
    //   name: "Opposite Administration Building",
    //   busStopId: "383013",
    // },
    {
      name: "TCT-LT",
      busStopId: "383013",
    },
    // {
    //   name: "Opposite Food court 2",
    //   busStopId: "383014",
    // },
    {
      name: "Hall 2",
      busStopId: "383014",
    },
  ];
  const brownBusStopDetailsList = [
    {
      name: "Pioneer MRT Station Exit B at Blk 649A",
      busStopId: "377906",
    },
    {
      name: "Hall 1 (Blk 18)",
      busStopId: "378233",
    },
    // {
    //   name: "Canteen 2",
    //   busStopId: "378237",
    // },
    {
      name: "Hall 2",
      busStopId: "378237",
    },
    {
      name: "University Health Services(SSC bus stop)",
      busStopId: "383011",
    },
    // {
    //   name: "Opposite Administration Building",
    //   busStopId: "383013",
    // },
    {
      name: "TCT-LT",
      busStopId: "383013",
    },
    {
      name: "ADM, Hall 8",
      busStopId: "378207",
    },
    {
      name: "LWN Library, Opp. NIE",
      busStopId: "378224",
    },
    {
      name: "School of CEE",
      busStopId: "383015",
    },
    {
      name: "SBS",
      busStopId: "382995",
    },
    {
      name: "WKWSCI",
      busStopId: "378227",
    },
    // {
    //   name: "Hall 7",
    //   busStopId: "378228",
    // },
    {
      name: "SPMS",
      busStopId: "378228",
    },
    // {
    //   name: "Yunnan Gardens",
    //   busStopId: "378229",
    // },
    {
      name: "Gaia",
      busStopId: "378229",
    },
    {
      name: "Hall 4",
      busStopId: "378230",
    },
    {
      name: "Hall 5",
      busStopId: "383018",
    },
  ];

  result = {
    blueBus: blueBusStopDetailsList,
    redBus: redBusStopDetailsList,
    yellowBus: yellowBusStopDetailsList,
    greenBus: greenBusStopDetailsList,
    brownBus: brownBusStopDetailsList,
  };

  return result;
};