# PingGo
PingGo is a cross-platform bus arrival tracking app for iOS and watchOS.
Designed to keep users informed about internal shuttle services across Singapore’s universities, PingGo delivers real-time arrival times and monitors only active bus lines. With a clean, intuitive interface, it also offers customizable notifications to ensure users never miss their ride.

## Table of Contents
1. [Watch the Demo](#watch-the-demo)
2. [Key Features](#key-features)
3. [System Architecture](#system-architecture)
4. [Getting Started](#getting-started)
5. [Project Structure](#project-structure)
6. [Future Developments](#future-developments)
7. [Credits](#credits)

## Watch the Demo
See PingGo in action! Click [here](<https://youtu.be/LUrik9FijOE>) to watch a demonstration of our apps' capabilities!

## Key Features
- Bus Arrival Information across Singapore's universities with internal shuttles
    - Displays bus arrival times on iOS app
    - Bus Line & Stop Selection
        - Users can view & select from a list of active bus lines
        - Navigation flows allow users to drill down from lines → stops → arrival information
    - Displays other useful information (e.g. bus capacity) where available
- Active Bus Monitoring
    - Displays only active bus lines
- Notifications & Reminders on bus arrival
    - Enable/Disable arrival notifications for when a bus is arriving at a stop with customisable lead times
    - Notifications are managed and can be toggled or rescheduled as needed
- Watch App Support
    - All of the above features also applied to watch app
- ViewModels manage API calls to fetch:
    - Active bus lines
    - Bus arrival times at specific stops
    - List of stops per bus line
    - Other information (e.g. bus capacity)

## System Architecture
![SA Diagram](https://i.imgur.com/5wng4Co.jpeg)

## Getting Started
### Prerequisites
- Serverless Account
- Vercel Account
- LTA DataMall API Key
- NUS NextBus Login Details
- Node.js version that is < 20 (this project uses v18)
- Xcode

### Setting Up APIs
Look within each API's respective folders (ArriveLahAPI, NTUBusAPI and NUSBusAPI) for `Instructions.md` 

### Running PingGo
- Download [Xcode](https://developer.apple.com/xcode/) and install simulators for your target device (this project was built on Ver 16.4)
- Set up your [Apple Developer Account](https://developer.apple.com/) if you have not done so already
- Populate `Constants.swift` (located in `Shared > Networking > Common`) with your API details 
- Open the `BusTrackApp` folder in Xcode
- Select your target device and build (then run) the app

## Project Structure
```
.
├── ArriveLahAPI
│   ├── api
│   │   └── arrival.js
│   ├── ArriveLahApp.swift
│   ├── ArriveLahService.swift
│   ├── BusArrivalResponse.swift
│   ├── BusArrivalTestView.swift
│   ├── env.txt
│   ├── Instructions.md
│   ├── package-lock.json
│   ├── package.json
│   ├── server.js
│   ├── service.js
│   └── vercel.json
├── BusTrackerApp
│   ├── BusTrackerApp
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── BusTrackerApp.entitlements
│   │   ├── BusTrackerApp.swift
│   │   ├── ContentView.swift
│   │   ├── Info.plist
│   │   ├── Services
│   │   │   └── NotificationManager.swift
│   │   ├── ViewModels
│   │   │   ├── NTU
│   │   │   │   ├── NTUActiveBusLinesViewModel.swift
│   │   │   │   ├── NTUInternalBusLineDetailViewModel.swift
│   │   │   │   ├── NTUInternalBusStopArrivalViewModel.swift
│   │   │   │   ├── NTUPublicBusLineDetailViewModel.swift
│   │   │   │   └── NTUPublicBusStopArrivalViewModel.swift
│   │   │   ├── NUS
│   │   │   │   ├── NUSActiveBusLineListViewModel.swift
│   │   │   │   ├── NUSInternalBusLineDetailViewModel.swift
│   │   │   │   ├── NUSInternalBusStopArrivalViewModel.swift
│   │   │   │   ├── NUSPublicBusArrivalViewModel.swift
│   │   │   │   └── NUSPublicBusStopListViewModel.swift
│   │   │   └── SMU
│   │   │       ├── SMUPublicBusArrivalViewModel.swift
│   │   │       ├── SMUPublicBusLineSelectionViewModel.swift
│   │   │       └── SMUPublicBusStopListViewModel.swift
│   │   └── Views
│   │       ├── NTU
│   │       │   ├── NTUInternalBusLineDetailView.swift
│   │       │   ├── NTUInternalBusStopArrivalView.swift
│   │       │   ├── NTULineSelectionView.swift
│   │       │   ├── NTUPublicBusLineDetailView.swift
│   │       │   └── NTUPublicBusStopArrivalView.swift
│   │       ├── NUS
│   │       │   ├── NUSInternalBusLineDetailView.swift
│   │       │   ├── NUSInternalBusStopArrivalView.swift
│   │       │   ├── NUSLineSelectionView.swift
│   │       │   ├── NUSPublicBusArrivalView.swift
│   │       │   └── NUSPublicBusStopListView.swift
│   │       └── SMU
│   │           ├── SMUPublicBusArrivalView.swift
│   │           ├── SMUPublicBusLineSelectionView.swift
│   │           └── SMUPublicBusStopSelectionView.swift
│   ├── BusTrackerApp.xcodeproj
│   │   ├── project.pbxproj
│   │   ├── project.xcworkspace
│   │   │   ├── contents.xcworkspacedata
│   │   │   ├── xcshareddata
│   │   │   │   ├── swiftpm
│   │   │   │   │   └── configuration
│   │   │   │   └── WorkspaceSettings.xcsettings
│   │   │   └── xcuserdata
│   │   │       ├── ava_vispilio.xcuserdatad
│   │   │       │   └── UserInterfaceState.xcuserstate
│   │   │       └── ava.xcuserdatad
│   │   │           ├── UserInterfaceState.xcuserstate
│   │   │           └── WorkspaceSettings.xcsettings
│   │   └── xcuserdata
│   │       ├── ava_vispilio.xcuserdatad
│   │       │   └── xcschemes
│   │       │       └── xcschememanagement.plist
│   │       └── ava.xcuserdatad
│   │           ├── xcdebugger
│   │           │   └── Breakpoints_v2.xcbkptlist
│   │           └── xcschemes
│   │               └── xcschememanagement.plist
│   ├── BusTrackerAppTests
│   │   └── BusTrackerAppTests.swift
│   ├── BusTrackerAppUITests
│   │   ├── BusTrackerAppUITests.swift
│   │   └── BusTrackerAppUITestsLaunchTests.swift
│   ├── BusTrackerWatchApp Watch App
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── BusTrackerWatchApp.swift
│   │   ├── ContentView.swift
│   │   ├── PageContainerView.swift
│   │   ├── Services
│   │   │   ├── NotificationLeadTimePickerView.swift
│   │   │   └── NotificationManager.swift
│   │   ├── ViewModels
│   │   │   ├── NTU
│   │   │   │   ├── NTUActiveBusLinesViewModel.swift
│   │   │   │   ├── NTUInternalBusLineDetailViewModel.swift
│   │   │   │   ├── NTUInternalBusStopArrivalViewModel.swift
│   │   │   │   ├── NTUPublicBusLineDetailViewModel.swift
│   │   │   │   └── NTUPublicBusStopArrivalViewModel.swift
│   │   │   ├── NUS
│   │   │   │   ├── NUSActiveBusLineListViewModel.swift
│   │   │   │   ├── NUSInternalBusLineDetailViewModel.swift
│   │   │   │   ├── NUSInternalBusStopArrivalViewModel.swift
│   │   │   │   ├── NUSPublicBusArrivalViewModel.swift
│   │   │   │   └── NUSPublicBusStopListViewModel.swift
│   │   │   └── SMU
│   │   │       ├── SMUPublicBusArrivalViewModel.swift
│   │   │       ├── SMUPublicBusLineSelectionViewModel.swift
│   │   │       └── SMUPublicBusStopListViewModel.swift
│   │   └── Views
│   │       ├── NTU
│   │       │   ├── NTUInternalBusLineDetailView.swift
│   │       │   ├── NTUInternalBusStopArrivalView.swift
│   │       │   ├── NTULineSelectionView.swift
│   │       │   ├── NTUPublicBusLineDetailView.swift
│   │       │   └── NTUPublicBusStopArrivalView.swift
│   │       ├── NUS
│   │       │   ├── NUSInternalBusLineDetailView.swift
│   │       │   ├── NUSInternalBusStopArrivalView.swift
│   │       │   ├── NUSLineSelectionView.swift
│   │       │   ├── NUSPublicBusArrivalView.swift
│   │       │   └── NUSPublicBusStopListView.swift
│   │       └── SMU
│   │           ├── SMUPublicBusArrivalView.swift
│   │           ├── SMUPublicBusLineSelectionView.swift
│   │           └── SMUPublicBusStopSelectionView.swift
│   ├── BusTrackerWatchApp Watch AppTests
│   │   └── BusTrackerWatchApp_Watch_AppTests.swift
│   ├── BusTrackerWatchApp Watch AppUITests
│   │   ├── BusTrackerWatchApp_Watch_AppUITests.swift
│   │   └── BusTrackerWatchApp_Watch_AppUITestsLaunchTests.swift
│   ├── BusTrackerWatchApp-Watch-App-Info.plist
│   └── Shared
│       ├── Models
│       │   ├── LTA
│       │   │   ├── LTABusArrival.swift
│       │   │   ├── LTALineActivityWrapper.swift
│       │   │   ├── PublicBusArrival.swift
│       │   │   ├── PublicBusLine.swift
│       │   │   └── PublicBusStop.swift
│       │   ├── NTU
│       │   │   ├── NTUInternalBus.swift
│       │   │   ├── NTUInternalBusArrival.swift
│       │   │   └── NTUInternalBusStop.swift
│       │   ├── NUS
│       │   │   ├── NUSInternalBusArrival.swift
│       │   │   ├── NUSInternalBusRoute.swift
│       │   │   ├── NUSInternalBusStop.swift
│       │   │   └── NUSLineActivityWrapper.swift
│       │   └── SMU
│       │       └── SMUBusStop.swift
│       ├── Networking
│       │   ├── Common
│       │   │   ├── Constants.swift
│       │   │   └── NetworkError.swift
│       │   ├── LTA
│       │   │   └── ArriveLahService.swift
│       │   ├── NTU
│       │   │   ├── APIResponseWrappers.swift
│       │   │   ├── NTUAPIResponseWrappers.swift
│       │   │   ├── NTUBusAPIClient.swift
│       │   │   └── NTUEndpoint.swift
│       │   └── NUS
│       │       └── NUSNextBusService.swift
│       └── Resources
│           ├── NTUPublicBusStopList.json
│           ├── NUSInternalBusStopList.json
│           ├── NUSPublicBusStopList.json
│           └── SMUPublicBusStopList.json
├── NTUBusAPI
│   ├── api
│   │   ├── getBlueBus.ts
│   │   ├── getBrownBus.ts
│   │   ├── getBusArrival.ts
│   │   ├── getBusStopDetails.ts
│   │   ├── getGreenBus.ts
│   │   ├── getRedBus.ts
│   │   ├── getYellowBus.ts
│   │   └── simulateGetBusArrival.ts
│   ├── helper
│   │   └── helper.ts
│   ├── Instructions.md
│   ├── jest.config.ts
│   ├── LICENSE
│   ├── package.json
│   ├── serverless.yml
│   ├── src
│   │   ├── blueBus
│   │   │   └── handler.ts
│   │   ├── brownBus
│   │   │   └── handler.ts
│   │   ├── busArrival
│   │   │   └── handler.ts
│   │   ├── busStopDetails
│   │   │   └── handler.ts
│   │   ├── greenBus
│   │   │   └── handler.ts
│   │   ├── main
│   │   │   └── handler.ts
│   │   ├── redBus
│   │   │   └── handler.ts
│   │   └── yellowBus
│   │       └── handler.ts
│   └── yarn.lock
├── NUSBusAPI
│   ├── NUSBusAPI
│   │   ├── Assets.xcassets
│   │   │   ├── AccentColor.colorset
│   │   │   │   └── Contents.json
│   │   │   ├── AppIcon.appiconset
│   │   │   │   └── Contents.json
│   │   │   └── Contents.json
│   │   ├── ContentView.swift
│   │   ├── Instructions.md
│   │   ├── Models
│   │   │   ├── ActiveBus.swift
│   │   │   ├── ArrivalInfo.swift
│   │   │   ├── BusRoute.swift
│   │   │   └── BusStop.swift
│   │   ├── NUSBusAPIApp.swift
│   │   ├── Resources
│   │   │   └── NUSBusStops.json
│   │   ├── Services
│   │   │   └── NUSNextBusService.swift
│   │   ├── Utilities
│   │   │   └── NetworkConstants.swift
│   │   ├── ViewModels
│   │   │   ├── ActiveBusViewModel.swift
│   │   │   └── BusArrivalViewModel.swift
│   │   └── Views
│   │       ├── ActiveBusTestView.swift
│   │       └── BusArrivalTestView.swift
│   └── NUSBusAPI.xcodeproj
│       ├── project.pbxproj
│       ├── project.xcworkspace
│       │   ├── contents.xcworkspacedata
│       │   └── xcuserdata
│       │       └── ava.xcuserdatad
│       │           └── UserInterfaceState.xcuserstate
│       └── xcuserdata
│           └── ava.xcuserdatad
│               ├── xcdebugger
│               │   └── Breakpoints_v2.xcbkptlist
│               └── xcschemes
│                   └── xcschememanagement.plist
├── README.md 
└── Contents.md
```

## Future Developments
- Pull to refresh bus arrival times
- Favourite bus stops
- Dark mode

## Credits
The PingGo project would not be possible without the contributions of the following individuals:

| Creators | GitHub | LinkedIn |
|------|--------|----------|
| Yong Rui Jie | [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Ava-Vispilio) | [![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/yong-rui-jie/) |
| Xue Qi | [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/xq-wong) | [![LinkedIn](https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/) |

| API | Author | Repo |
|------|--------|----------|
 ArriveLah | Lim Chee Aun | [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/cheeaun/arrivelah) | 
 | NTU Shuttle Bus | Donald Wu | [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yeukfei02/ntu-shuttle-bus-api) | 
 | NUS NextBus | Hu Jialun | [![GitHub](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/SuibianP/nus-nextbus-new-api) | 