import { getBusStopDetails } from "./getBusStopDetails";
import { getBlueBus } from "./getBlueBus";
import { getRedBus } from "./getRedBus";
import { getGreenBus } from "./getGreenBus";
import { getYellowBus } from "./getYellowBus";
import { getBrownBus } from "./getBrownBus";

interface BusStopDetail {
  name: string;
  busStopId: string;
}

interface BusStopDetailsList {
  [lineName: string]: BusStopDetail[];
}

export const simulateGetBusArrival = async (busStopId: string): Promise<any> => {
  const busStops = (await getBusStopDetails()) as BusStopDetailsList;

  let line: string | null = null;
  let stopName: string | null = null;

  for (const [lineName, stopList] of Object.entries(busStops) as [string, BusStopDetail[]][]) {
    const match = stopList.find((s) => s.busStopId === busStopId);
    if (match) {
      line = lineName;
      stopName = match.name;
      break;
    }
  }

  if (!line) {
    return {};
  }

  let busData: any = {};
  switch (line) {
    case 'blueBus':
      busData = await getBlueBus();
      break;
    case 'redBus':
      busData = await getRedBus();
      break;
    case 'greenBus':
      busData = await getGreenBus();
      break;
    case 'yellowBus':
      busData = await getYellowBus();
      break;
    case 'brownBus':
      busData = await getBrownBus();
      break;
    default:
      busData = { vehicles: [] };
  }

  const forecastList = [
    { minutes: Math.floor(Math.random() * 15) + 1 },
    { minutes: Math.floor(Math.random() * 15) + 15 },
  ];

  const geometryList = (busData.vehicles || []).map((v: any) => ({
    latitude: v.latitude,
    longitude: v.longitude,
  }));

  return {
    id: busStopId,
    name: stopName,
    forecasts: forecastList,
    geometries: geometryList,
  };
};