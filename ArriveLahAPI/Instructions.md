# ArriveLah

A local copy of [ArriveLah](https://github.com/cheeaun/arrivelah), included in this repository for local testing purposes

## How to get started

1. install Node.js
2. Obtain API Key from from [LTA's DataMall](http://www.mytransport.sg/content/mytransport/home/dataMall.html)
3. [Request for API Access](https://datamall.lta.gov.sg/content/datamall/en/request-for-api.html)
4. Rename `env.txt` to `.env` and fill in the following sections:
   ```
   accountKeys=[Your API Key]
   ```
5. Install necessary packages (only needs to be run once)
   ```zsh
   $ sudo npm install
   ```
6. Connect to [Vercel CLI](https://vercel.com/docs/cli)
7. Start the server (for subsequent launches)
   ```zsh
   $ npm start
   ```

## API GET Commands / Responses

There is only 1 command:
```zsh
// Replace [BusStopID] with Bus Stop ID / Code
$ curl http://localhost:3000/?id=[BusStopID]
```
Sample Response:
```json
{
  "services": [
    {
      "no": "136",
      "operator": "GAS",
      "next": {
        "time": "2022-06-18T21:19:43+08:00",
        "duration_ms": 395837,
        "lat": 1.3527008333333335,
        "lng": 103.8770235,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "65009",
        "destination_code": "54009"
      },
      "subsequent": {
        "time": "2022-06-18T21:33:22+08:00",
        "duration_ms": 1214837,
        "lat": 1.3723343333333333,
        "lng": 103.898075,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "65009",
        "destination_code": "54009"
      },
      "next2": {
        "time": "2022-06-18T21:33:22+08:00",
        "duration_ms": 1214837,
        "lat": 1.3723343333333333,
        "lng": 103.898075,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "65009",
        "destination_code": "54009"
      },
      "next3": {
        "time": "2022-06-18T21:51:23+08:00",
        "duration_ms": 2295837,
        "lat": 1.3994908333333334,
        "lng": 103.90791783333333,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "65009",
        "destination_code": "54009"
      }
    },
    {
      "no": "136",
      "operator": "GAS",
      "next": {
        "time": "2022-06-18T21:30:41+08:00",
        "duration_ms": 1053837,
        "lat": 0,
        "lng": 0,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "54009",
        "destination_code": "65009"
      },
      "subsequent": {
        "time": "2022-06-18T21:49:41+08:00",
        "duration_ms": 2193837,
        "lat": 0,
        "lng": 0,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "54009",
        "destination_code": "65009"
      },
      "next2": {
        "time": "2022-06-18T21:49:41+08:00",
        "duration_ms": 2193837,
        "lat": 0,
        "lng": 0,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "54009",
        "destination_code": "65009"
      },
      "next3": null
    },
    {
      "no": "315",
      "operator": "SBST",
      "next": {
        "time": "2022-06-18T21:13:30+08:00",
        "duration_ms": 22837,
        "lat": 1.3632465,
        "lng": 103.871274,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "subsequent": {
        "time": "2022-06-18T21:22:15+08:00",
        "duration_ms": 547837,
        "lat": 0,
        "lng": 0,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "next2": {
        "time": "2022-06-18T21:22:15+08:00",
        "duration_ms": 547837,
        "lat": 0,
        "lng": 0,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "next3": {
        "time": "2022-06-18T21:23:32+08:00",
        "duration_ms": 624837,
        "lat": 1.3752478333333333,
        "lng": 103.869852,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "66009",
        "destination_code": "66009"
      }
    },
    {
      "no": "317",
      "operator": "SBST",
      "next": {
        "time": "2022-06-18T21:20:49+08:00",
        "duration_ms": 461837,
        "lat": 1.3628948333333333,
        "lng": 103.86563566666666,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "subsequent": {
        "time": "2022-06-18T21:21:31+08:00",
        "duration_ms": 503837,
        "lat": 1.3497606666666666,
        "lng": 103.8737135,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "next2": {
        "time": "2022-06-18T21:21:31+08:00",
        "duration_ms": 503837,
        "lat": 1.3497606666666666,
        "lng": 103.8737135,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "66009",
        "destination_code": "66009"
      },
      "next3": {
        "time": "2022-06-18T21:32:39+08:00",
        "duration_ms": 1171837,
        "lat": 1.3497606666666666,
        "lng": 103.8737135,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "66009",
        "destination_code": "66009"
      }
    },
    {
      "no": "73",
      "operator": "SBST",
      "next": {
        "time": "2022-06-18T21:13:41+08:00",
        "duration_ms": 33837,
        "lat": 1.3632655,
        "lng": 103.871455,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "54009",
        "destination_code": "54009"
      },
      "subsequent": {
        "time": "2022-06-18T21:20:45+08:00",
        "duration_ms": 457837,
        "lat": 1.3435921666666666,
        "lng": 103.85476483333333,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "54009",
        "destination_code": "54009"
      },
      "next2": {
        "time": "2022-06-18T21:20:45+08:00",
        "duration_ms": 457837,
        "lat": 1.3435921666666666,
        "lng": 103.85476483333333,
        "load": "SEA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 2,
        "origin_code": "54009",
        "destination_code": "54009"
      },
      "next3": {
        "time": "2022-06-18T21:26:49+08:00",
        "duration_ms": 821837,
        "lat": 1.3712010000000001,
        "lng": 103.86542066666667,
        "load": "SDA",
        "feature": "WAB",
        "type": "SD",
        "visit_number": 1,
        "origin_code": "54009",
        "destination_code": "54009"
      }
    }
  ]
}

```
A few pointers:
* Responses are cached for **15 seconds**
* Details on what the acronyms mean will not be covered, refer to the [README](https://github.com/cheeaun/arrivelah/blob/master/README.md) of the base repository for more details
* This API's localhost instance is reachable through the host device's IP, hence it is not neccesary to configure it to start from 0.0.0.0

## How to integrate this into the app

## Credits

Credits to [Lim Chee Aun](http://cheeaun.mit-license.org/). Data is copyrighted by [LTA](http://www.mytransport.sg/).