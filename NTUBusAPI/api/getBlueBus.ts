// import axios from "axios";
// import { getBusRootUrl } from "../helper/helper";

// const rootUrl = getBusRootUrl();

// const blueBusId = "44479";

// export const getBlueBus = async (): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${blueBusId}`, {
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
const blueBusId = "44479";

export const getBlueBus = async (): Promise<any> => {
  let result = {};

  try {
    const response = await axios.get(`${rootUrl}/${blueBusId}`, {
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
      id: 44479,
      name: "Bus Campus Loop - Blue (CL-B) [Singapore]: NIE, Opp. LWN Library - NIE, Opp. LWN Library",
      routeName: "Campus Loop - Blue (CL-B)None",
      vehicles: [
        {
          latitude: "1.354207000000",
          longitude: "103.683094000000",
        },
      ],
    };
    result = obj;
  }

  return result;
};