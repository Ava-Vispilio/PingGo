// import axios from "axios";
// import { getBusRootUrl } from "../helper/helper";

// const rootUrl = getBusRootUrl();

// const greenBusId = "44480";

// export const getGreenBus = async (): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${greenBusId}`, {
//     params: {
//       format: "json",
//     },
//   });
//   if (response.status == 200) {
//     const responseData = response.data;
//     if (responseData) {
//       let vehicleList = [];
//       if (responseData.vehicles) {
//         vehicleList = responseData.vehicles.map((vehicle: any) => {
//           const obj = {
//             latitude: vehicle.lat,
//             longitude: vehicle.lon,
//           };
//           return obj;
//         });
//       }

//       const obj = {
//         id: responseData.id,
//         name: responseData.name,
//         routeName: responseData.routename,
//         vehicles: vehicleList,
//       };
//       result = obj;
//     }
//   }

//   return result;
// };

import axios from "axios";
import { getBusRootUrl } from "../helper/helper";

const rootUrl = getBusRootUrl();
const greenBusId = "44480";

export const getGreenBus = async (): Promise<any> => {
  let result = {};

  try {
    const response = await axios.get(`${rootUrl}/${greenBusId}`, {
      params: {
        format: "json",
      },
    });

    if (response.status === 200 && response.data) {
      const responseData = response.data;
      let vehicleList = [];

      if (responseData.vehicles) {
        vehicleList = responseData.vehicles.map((vehicle: any) => {
          const obj = {
            latitude: vehicle.lat,
            longitude: vehicle.lon,
          };
          return obj;
        });
      }

      const obj = {
        id: responseData.id,
        name: responseData.name,
        routeName: responseData.routename,
        vehicles: vehicleList,
      };
      result = obj;
    } else {
      throw new Error("Invalid response data");
    }
  } catch (error) {
    // Fallback data
    const obj = {
      id: 44480,
      name: "Bus Campus Rider Green [Singapore]: Pioneer MRT Station Exit B at Blk 649A - Pioneer MRT Station Exit B at Blk 649A",
      routeName: "Campus Rider GreenNone",
      vehicles: [
        {
          latitude: "1.346468000000",
          longitude: "103.687449000000",
        },
      ],
    };
    result = obj;
  }

  return result;
};