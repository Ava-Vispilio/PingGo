# ntu-shuttle-bus-api

A clone of the [original ntu-shuttle-bus-api](https://github.com/yeukfei02/ntu-shuttle-bus-api), included in this repository for local testing purposes

## How to get started

1. Install a Node.js version that is <20 (I'll be using v18 for this guide)
2. Install corepack and enable yarn
```zsh
$ npm install -g corepack
$ corepack enable yarn
```
3. Install dependencies 
```zsh
$ yarn install
```

If you have any errors (or installed the wrong version of Node), clear the cache and remove .node_modules, then try to install dependencies again
```zsh
$ yarn cache clean
$ yarn install
```

## Server-side Commands

* Test API in local
```zsh
$ yarn run dev
```
Note that this requires you to sign into Serverless and change the ```org``` field in ```serverless.yml``` to your Serverless username

After that, sign into Serverless (in another shell using) ```$ serverless login``` and deploy the app to run it locally

* Run API locally
```zsh
$ npx run serverless offline --host 0.0.0.0
```
This makes the local server accessible from the host device's LAN IP (so other devices can reach it)

* Deploy to serverless
```zsh
$ yarn run deploy
```

* Open serverless dashboard
```zsh
$ yarn run dashboard
```

* Lint code
```zsh
$ yarn run lint
```

* Format code
```zsh
$ yarn run format
```

* Run test case
```zsh
$ yarn run test
```

* Remove serverless services in aws (api gateway, lambda, s3, cloudformation)
```zsh
$ yarn run remove
```

## API GET Commands / Responses

* Get details of buses along each line

```zsh
// Replace [color] with line color
$ curl http://localhost:3000/prod/[color]-bus
```
Sample Response  

```json
{
  "message": "blueBus",
  "blueBus": {
    "id": 44479,
    "name": "Bus Campus Loop - Blue (CL-B) [Singapore]: NIE, Opp. LWN Library - NIE, Opp. LWN Library",
    "routeName": "Campus Loop - Blue (CL-B)None",
    "vehicles": [
      {
        "latitude": "1.354207000000",
        "longitude": "103.683094000000"
      }
    ]
  }
}
```

* Bus Stop Details
```
$ curl http://localhost:3000/prod/bus-stop-details
```

Sample Response
```json
{
  "message": "bus-stop-details",
  "busStopDetails": {
    "blueBus": [
      {
        "name": "NIE, Opp. LWN Library",
        "busStopId": "378225"
      },
      {
        "name": "Opp. Hall 3 & 16",
        "busStopId": "382999"
      },
      {
        "name": "Opp. Hall 14 & 15",
        "busStopId": "378203"
      },
      {
        "name": "Opp. Saraca Hall",
        "busStopId": "383048"
      },
      {
        "name": "Opposite Hall 11, bus stop",
        "busStopId": "378222"
      },
      {
        "name": "Nanyang Height, Opposite Hall 8 bus stop",
        "busStopId": "383003"
      },
      {
        "name": "Hall 6, Opp. Hall 2",
        "busStopId": "378234"
      },
      {
        "name": "Opp. Hall 4",
        "busStopId": "383004"
      },
      {
        "name": "Opp. Yunnan Gardens",
        "busStopId": "383006"
      },
      {
        "name": "Opp. SPMS",
        "busStopId": "383009"
      },
      {
        "name": "Opp. WKWSCI",
        "busStopId": "383010"
      },
      {
        "name": "Opp. CEE",
        "busStopId": "378226"
      }
    ],
    "redBus": [
      {
        "name": "LWN Library, Opp. NIE",
        "busStopId": "378224"
      },
      {
        "name": "SBS",
        "busStopId": "382995"
      },
      {
        "name": "WKWSCI",
        "busStopId": "378227"
      },
      {
        "name": "Hall 7",
        "busStopId": "378228"
      },
      {
        "name": "Yunnan Gardens",
        "busStopId": "378229"
      },
      {
        "name": "Hall 4",
        "busStopId": "378230"
      },
      {
        "name": "Hall 1 (Blk 18)",
        "busStopId": "378233"
      },
      {
        "name": "Canteen 2",
        "busStopId": "378237"
      },
      {
        "name": "Nanyang Height, Opposite Hall 8 bus stop",
        "busStopId": "382998"
      },
      {
        "name": "Opposite Hall 11, bus stop",
        "busStopId": "383049"
      },
      {
        "name": "Grad Hall 1 & 2",
        "busStopId": "378202"
      },
      {
        "name": "Saraca Hall",
        "busStopId": "383050"
      },
      {
        "name": "Hall 12 &13",
        "busStopId": "378204"
      }
    ],
    "yellowBus": [
      {
        "name": "Campus Clubhouse, NEC",
        "busStopId": "383091"
      },
      {
        "name": "Blk 96, Staircase 3",
        "busStopId": "383090"
      },
      {
        "name": "Child Care Centre",
        "busStopId": "383093"
      },
      {
        "name": "Opposite Hall 11, bus stop",
        "busStopId": "378222"
      },
      {
        "name": "Nanyang Height, Opposite Hall 8 bus stop",
        "busStopId": "383003"
      },
      {
        "name": "University Health Services(SSC bus stop)",
        "busStopId": "383011"
      },
      {
        "name": "Opposite Administration Building",
        "busStopId": "383013"
      }
    ],
    "greenBus": [
      {
        "name": "Pioneer MRT Station Exit B at Blk 649A",
        "busStopId": "377906"
      },
      {
        "name": "Hall 1 (Blk 18)",
        "busStopId": "378233"
      },
      {
        "name": "Canteen 2",
        "busStopId": "378237"
      },
      {
        "name": "University Health Services(SSC bus stop)",
        "busStopId": "383011"
      },
      {
        "name": "Opposite Administration Building",
        "busStopId": "383013"
      },
      {
        "name": "Opposite Food court 2",
        "busStopId": "383014"
      }
    ],
    "brownBus": [
      {
        "name": "Pioneer MRT Station Exit B at Blk 649A",
        "busStopId": "377906"
      },
      {
        "name": "Hall 1 (Blk 18)",
        "busStopId": "378233"
      },
      {
        "name": "Canteen 2",
        "busStopId": "378237"
      },
      {
        "name": "University Health Services(SSC bus stop)",
        "busStopId": "383011"
      },
      {
        "name": "Opposite Administration Building",
        "busStopId": "383013"
      },
      {
        "name": "ADM, Hall 8",
        "busStopId": "378207"
      },
      {
        "name": "LWN Library, Opp. NIE",
        "busStopId": "378224"
      },
      {
        "name": "School of CEE",
        "busStopId": "383015"
      },
      {
        "name": "SBS",
        "busStopId": "382995"
      },
      {
        "name": "WKWSCI",
        "busStopId": "378227"
      },
      {
        "name": "Hall 7",
        "busStopId": "378228"
      },
      {
        "name": "Yunnan Gardens",
        "busStopId": "378229"
      },
      {
        "name": "Hall 4",
        "busStopId": "378230"
      },
      {
        "name": "Hall 5",
        "busStopId": "383018"
      }
    ]
  }
}
```

* Bus Arrival
```zsh
// Replace ID with Bus Stop ID
$ curl http://localhost:3000/prod/bus-arrival?busStopId=[ID]
```

Sample Response
```json
{
  "message": "bus-arrival",
  "busArrival": {
    "id": 378202,
    "name": "Grad Hall 1 & 2",
    "forecasts": [
      {
        "minutes": 9
      }
    ],
    "geometries": [
      {
        "latitude": "1.3556335973",
        "longitude": "103.6862611771"
      }
    ]
  }
}
```

## How to integrate this into the app
1. (If running locally) Find the host device's IP address
```zsh
$ ipconfig getifaddr en0
```
2. Replace `baseURL` in `NTUEndpoint.swift` with your IP address
```
e.g. "http://192.168.1.1:3000/prod"
```

## More documentation: 
<https://documenter.getpostman.com/view/3827865/UVsHV8qv>

## Credits
Credits to [Donald Wu](https://github.com/yeukfei02/ntu-shuttle-bus-api?tab=MIT-1-ov-file)
