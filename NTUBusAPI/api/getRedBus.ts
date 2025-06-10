// import axios from "axios";
// import { getBusRootUrl } from "../helper/helper";

// const rootUrl = getBusRootUrl();

// const redBusId = "44478";

// export const getRedBus = async (): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${redBusId}`, {
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
const redBusId = "44478";

export const getRedBus = async (): Promise<any> => {
  let result = {};

  try {
    const response = await axios.get(`${rootUrl}/${redBusId}`, {
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
      id: 44478,
      name: "Bus Campus Loop Red (CL-R) [Singapore]: LWN Library, Opp. NIE - NIE, Opp. LWN Library",
      routeName: "Campus Loop Red (CL-R)None",
      vehicles: [
        {
          latitude: "1.349479000000",
          longitude: "103.684941000000",
        },
      ],
    };
    result = obj;
  }

  return result;
};