// import axios from "axios";
// import { getBusArrivalRootUrl } from "../helper/helper";

// const rootUrl = getBusArrivalRootUrl();

// export const getBusArrival = async (busStopId: string): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${busStopId}`, {
//     params: {
//       format: "json",
//     },
//   });
//   if (response.status == 200) {
//     const responseData = response.data;
//     if (responseData) {
//       let forecastList = [];
//       let geometryList = [];

//       if (responseData.forecast) {
//         forecastList = responseData.forecast.map((item: any) => {
//           const minutes = Math.floor(item.forecast_seconds / 60);

//           const obj = {
//             minutes: minutes,
//           };
//           return obj;
//         });
//       }

//       if (responseData.geometry) {
//         geometryList = responseData.geometry.map((item: any) => {
//           const obj = {
//             latitude: item.lat,
//             longitude: item.lon,
//           };
//           return obj;
//         });
//       }

//       const obj = {
//         id: responseData.id,
//         name: responseData.name,
//         forecasts: forecastList,
//         geometries: geometryList,
//       };
//       result = obj;
//     }
//   }

//   return result;
// };

import axios from "axios";
import { getBusArrivalRootUrl } from "../helper/helper";
import { simulateGetBusArrival } from "./simulateGetBusArrival"; // import your simulation

const rootUrl = getBusArrivalRootUrl();

export const getBusArrival = async (busStopId: string): Promise<any> => {
  try {
    const response = await axios.get(`${rootUrl}/${busStopId}`, {
      params: {
        format: "json",
      },
    });

    if (response.status === 200 && response.data) {
      const responseData = response.data;
      let forecastList = [];
      let geometryList = [];

      if (responseData.forecast) {
        forecastList = responseData.forecast.map((item: any) => {
          const minutes = Math.floor(item.forecast_seconds / 60);

          return { minutes };
        });
      }

      if (responseData.geometry) {
        geometryList = responseData.geometry.map((item: any) => ({
          latitude: item.lat,
          longitude: item.lon,
        }));
      }

      return {
        id: responseData.id,
        name: responseData.name,
        forecasts: forecastList,
        geometries: geometryList,
      };
    } 
  } catch (error) {
    // Fallback to simulateGetBusArrival if API call fails
    return await simulateGetBusArrival(busStopId);
  }
};
