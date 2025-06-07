// import axios from "axios";
// import { getBusRootUrl } from "../helper/helper";

// const rootUrl = getBusRootUrl();

// const yellowBusId = "44505";

// export const getYellowBus = async (): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${yellowBusId}`, {
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
const yellowBusId = "44505";

export const getYellowBus = async (): Promise<any> => {
  let result = {};

  try {
    const response = await axios.get(`${rootUrl}/${yellowBusId}`, {
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
      id: 44505,
      name: "Bus Campus Loop - Yellow [Singapore]: Opposite Administration Building - Opposite Administration Building",
      routeName: "Campus Loop - YellowNone",
      vehicles: [],
    };
    result = obj;
  }

  return result;
};