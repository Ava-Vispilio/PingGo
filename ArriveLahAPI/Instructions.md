# Setting up ArriveLah in Xcode

1. Copy the follwoing 4 files over:
    - ArriveLahService.swift
    - BusArrivalResponse file (parses json response)
    - BusArrivalTestView.swift
    - ArriveLahApp.swift
2. Edit ArriveLahService.swift to key in IP Address
3. Create an Info.plist file
   - Add "App Transport Security Settings" (as a dictionary)
   - Add a subkey, type in "Allow Arbitrary Loads" and set the value to "YES"
   - Ensure the Info.plist file is not under build phases -> copy bundle resources (click and delete if it is there)
4. Get ArriveLah API running on local host (see "How to Use ArriveLah" below)
5. Run the build to test with any bus stop code

##Here's what to expect:
VScode Terminal (after keying `npm start`)

```
> arrivelah@5.0.0 start
> vercel dev
Vercel CLI 25.1.0
> Ready! Available at http://localhost:3000
🚌  22521
[cD90] ↗️  https://datamall2.mytransport.sg/ltaodataservice/v3/BusArrival?BusStopCode=22521
```

Xcode Terminal had a bunch of warnings but no errors

```
Failed to send CA Event for app launch measurements for ca_event_type: 0 event_name: com.apple.app_launch_measurement.FirstFramePresentationMetric
Failed to send CA Event for app launch measurements for ca_event_type: 1 event_name: com.apple.app_launch_measurement.ExtendedLaunchMetrics
nw_protocol_socket_set_no_wake_from_sleep [C1:2] setsockopt SO_NOWAKEFROMSLEEP failed [22: Invalid argument]
nw_protocol_socket_set_no_wake_from_sleep setsockopt SO_NOWAKEFROMSLEEP failed [22: Invalid argument]
```

---

# How to Use ArriveLah

A detailed guide to using [ArriveLah](https://github.com/cheeaun/arrivelah). (Can read this instead of their [README.md](https://github.com/cheeaun/arrivelah/blob/master/README.md))

ArriveLah acts as a proxy to [LTA's DataMall Bus Arrival API](http://www.mytransport.sg/content/mytransport/home/dataMall.html).

## Getting Started

### Prerequisites

- Obtain API Key from from [LTA's DataMall](http://www.mytransport.sg/content/mytransport/home/dataMall.html)
  - [Request for API Access](https://datamall.lta.gov.sg/content/datamall/en/request-for-api.html)
- Make a copy of the files in the [ArriveLah repository](https://github.com/cheeaun/arrivelah)
- Choose either 1 of the 2 ways to edit the .envexample file
  1. Copy and rename `.env.example` to `.env`.
  2. Add environment variables.
- Install and set up [Vercel CLI](https://vercel.com/docs/cli)
  - Login and link to GitHub repository as necessary

### Launching Arrivelah

- `npm install` (for the first time around)
- `npm start` (use this only subsequently once logged in to Vercel)

## Base URL

Somehow opens on [local host port 3000](http://localhost:3000) every time.

## Authentication

Pass API key into the .env file under `accountKeys`in the first line of code if the `.env` file is a copy of the `.env.example` file. Else, pass it where necessary.

## Endpoints

Only one endpoint - to make a request to get all bus services servicing a specific bus stop in real time.

Each request is made with the specific bus stop code/ID and returns in json the details and next 3 arrival times of each bus service/number.

### Request

Append `/?id=66271` to the end of the URL, with `id` as the required 5-digit Bus stop code.

### Response

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

The responses are cached for **15 seconds**.

## Acronyms of Details from the Responses

- `operator`:
  - `SBST` - SBS Transit
  - `SMRT` - SMRT Corporation
  - `TTS` - Tower Transit Singapore
  - `GAS` - Go Ahead Singapore
- `load`:
  - `SEA` - Seats Available
  - `SDA` - Standing Available
  - `LSD` - Limited Standing
- `feature`:
  - `WAB` - Wheelchair Accessible Bus
- `type`:
  - `SD` - Single Deck
  - `DD` - Double Deck
  - `BD` - Bendy

## Resources/Tools

- [Vercel CLI](https://vercel.com/docs/cli)
- [Http response status codes](https://http.cat)

## Credits

Credits to [Lim Chee Aun](http://cheeaun.mit-license.org/). Data is copyrighted by [LTA](http://www.mytransport.sg/).
