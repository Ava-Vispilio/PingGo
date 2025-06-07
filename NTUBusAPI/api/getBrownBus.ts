// import axios from "axios";
// import { getBusRootUrl } from "../helper/helper";

// const rootUrl = getBusRootUrl();

// const brownBusId = "44481";

// export const getBrownBus = async (): Promise<any> => {
//   let result = {};

//   const response = await axios.get(`${rootUrl}/${brownBusId}`, {
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
const brownBusId = "44481";

export const getBrownBus = async (): Promise<any> => {
  let result = {};

  try {
    const response = await axios.get(`${rootUrl}/${brownBusId}`, {
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
      id: 44481,
      name: "Bus Campus WeekEnd Rider Brown [Singapore]: Pioneer MRT Station Exit B at Blk 649A - Pioneer MRT Station Exit B at Blk 649A",
      routeName: "Campus WeekEnd Rider BrownNone",
      vehicles: [
        {
          latitude: "1.346867000000",
          longitude: "103.683795000000",
        },
        {
          latitude: "1.347369000000",
          longitude: "103.686607000000",
        },
      ],
    };
    result = obj;
  }

  return result;
};