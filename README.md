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

Frontend Platforms:
- Two independent UIs: one for iOS, one for watchOS
- Each platform has its own:
   - Views (e.g., line & stop selection screens)
   - ViewModels (handle data logic and API calls)
   - Notification manager (schedules local notifications with customizable lead times)

Shared Layer:
- Networking services to fetch data
- Shared data models (e.g., Bus, BusStop, BusRoute)
- Used by both iOS and watchOS apps for consistent logic and data handling

External APIs Integrated:
- ArriveLah – for public bus arrivals across Singapore
- NUS NextBus – for internal NUS shuttle services
- NTU Omnibus – for internal NTU shuttle services

Data Flow:
- User interacts with the app (e.g., selects a bus line)
- ViewModel sends a request to the shared networking layer
- Networking layer calls one of the 3 external APIs
- Response is decoded into shared models
- ViewModel updates the UI with arrival times and other metadata (e.g., capacity) and schedules a local notification via the platform's notification manager

Independence:
- iOS and watchOS apps run independently
- No dependency between platforms — both fetch data directly via shared logic

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

* Xcode Project
```
.
└── BusTrackerApp
    ├── BusTrackerApp
    │   ├── Assets.xcassets                     # Asset catalog for colors, icons, etc.
    │   │   ├── AccentColor.colorset           # Custom accent color used across the app
    │   │   ├── AppIcon.appiconset             # App icon for iOS app
    │   │   └── Contents.json                  # Metadata for asset catalog
    │   ├── BusTrackerApp.entitlements         # App capabilities and permissions (e.g. notifications)
    │   ├── BusTrackerApp.swift                # App entry point (main struct)
    │   ├── ContentView.swift                  # Root content view (entry view for the UI)
    │   ├── Info.plist                         # App metadata and configuration settings
    │   ├── Services
    │   │   └── NotificationManager.swift      # Handles scheduling and cancelling local notifications
    │   ├── ViewModels                         # ViewModel layer for MVVM architecture
    │   │   ├── NTU
    │   │   │   ├── NTUActiveBusLinesViewModel.swift         # Fetches active NTU lines (internal and public)
    │   │   │   ├── NTUInternalBusLineDetailViewModel.swift  # Loads internal NTU route stops and buses
    │   │   │   ├── NTUInternalBusStopArrivalViewModel.swift # Gets arrival times at internal NTU stops
    │   │   │   ├── NTUPublicBusLineDetailViewModel.swift    # Loads stops for a selected NTU public route
    │   │   │   └── NTUPublicBusStopArrivalViewModel.swift   # Gets arrival data at a public NTU stop
    │   │   ├── NUS
    │   │   │   ├── NUSActiveBusLineListViewModel.swift      # Gets active NUS lines from static data and API
    │   │   │   ├── NUSInternalBusLineDetailViewModel.swift  # Loads internal NUS route stops and buses
    │   │   │   ├── NUSInternalBusStopArrivalViewModel.swift # Tracks arrival times at internal NUS stops
    │   │   │   ├── NUSPublicBusArrivalViewModel.swift       # Manages public bus arrival state for NUS stop
    │   │   │   └── NUSPublicBusStopListViewModel.swift      # Loads list of public bus stops for a route
    │   │   └── SMU
    │   │       ├── SMUPublicBusArrivalViewModel.swift       # Tracks arrival state for a single SMU public bus
    │   │       ├── SMUPublicBusLineSelectionViewModel.swift # Fetches public bus services at a selected stop
    │   │       └── SMUPublicBusStopListViewModel.swift      # Loads all public bus stops near SMU
    │   └── Views
    │       ├── NTU
    │       │   ├── NTUInternalBusLineDetailView.swift        # Displays NTU internal route with stop links
    │       │   ├── NTUInternalBusStopArrivalView.swift       # Shows arrival info and notifications for internal stop
    │       │   ├── NTULineSelectionView.swift                # Top-level NTU line selector (internal & public)
    │       │   ├── NTUPublicBusLineDetailView.swift          # Lists stops for selected NTU public route
    │       │   └── NTUPublicBusStopArrivalView.swift         # Shows arrivals and notification toggle at NTU public stop
    │       ├── NUS
    │       │   ├── NUSInternalBusLineDetailView.swift        # Lists stops for a selected NUS internal route
    │       │   ├── NUSInternalBusStopArrivalView.swift       # Displays NUS internal bus arrival times + toggle
    │       │   ├── NUSLineSelectionView.swift                # Shows all active NUS internal + public lines
    │       │   ├── NUSPublicBusArrivalView.swift             # Displays public bus arrival + notification for a stop
    │       │   └── NUSPublicBusStopListView.swift            # Lists all stops for a NUS public route
    │       └── SMU
    │           ├── SMUPublicBusArrivalView.swift             # Shows arrivals and notification settings for SMU bus
    │           ├── SMUPublicBusLineSelectionView.swift       # Lists active SMU bus services at a stop
    │           └── SMUPublicBusStopSelectionView.swift       # Lists all public bus stops near SMU
    ├── BusTrackerApp.xcodeproj               # Project file used by Xcode
    │   ├── project.pbxproj                   # Core Xcode build settings and structure
    │   ├── project.xcworkspace               # Xcode workspace container
    │   │   ├── contents.xcworkspacedata      # Metadata for workspace layout
    │   │   ├── xcshareddata                  # Shared workspace settings
    │   │   └── xcuserdata                    # User-specific workspace/editor state
    │   └── xcuserdata                        # User schemes, breakpoints, preferences
    ├── BusTrackerAppTests
    │   └── BusTrackerAppTests.swift          # Unit tests for app logic
    ├── BusTrackerAppUITests
    │   ├── BusTrackerAppUITests.swift        # UI tests for interactive components
    │   └── BusTrackerAppUITestsLaunchTests.swift # Launch tests for verifying app starts correctly
    ├── BusTrackerWatchApp Watch App
    │   ├── Assets.xcassets                   # Asset catalog for the watchOS app
    │   │   ├── AccentColor.colorset         # Accent color for watch app
    │   │   ├── AppIcon.appiconset           # App icon for watch app
    │   ├── BusTrackerWatchApp.swift         # Main entry point for watchOS app
    │   ├── ContentView.swift                # Root UI view for watchOS app
    │   ├── PageContainerView.swift          # Watch UI pager container
    │   ├── Services
    │   │   ├── NotificationLeadTimePickerView.swift # Sheet UI to pick notification lead time
    │   │   └── NotificationManager.swift     # Handles watchOS local notifications
    │   ├── ViewModels
    │   │   ├── NTU                           # Same purpose as iOS NTU view models but adapted for watch
    │   │   ├── NUS                           # NUS view models for watch app
    │   │   └── SMU                           # SMU watch-specific view models
    │   └── Views
    │       ├── NTU                           # Watch UI for NTU lines, stops, arrivals
    │       ├── NUS                           # Watch UI for NUS
    │       └── SMU                           # Watch UI for SMU
    ├── BusTrackerWatchApp Watch AppTests
    │   └── BusTrackerWatchApp_Watch_AppTests.swift # Unit tests for watch app logic
    ├── BusTrackerWatchApp Watch AppUITests
    │   ├── BusTrackerWatchApp_Watch_AppUITests.swift # UI tests for watch app
    │   └── BusTrackerWatchApp_Watch_AppUITestsLaunchTests.swift # Tests for watch app launch
    ├── BusTrackerWatchApp-Watch-App-Info.plist # Info.plist for watchOS app configuration
    └── Shared
        ├── Models                            # Shared data models between iOS and watchOS
        │   ├── LTA
        │   │   ├── LTABusArrival.swift       # Arrival model parsed from ArriveLah response
        │   │   ├── LTALineActivityWrapper.swift # Helps determine which LTA lines are active
        │   │   ├── PublicBusArrival.swift    # Generic arrival model for public buses
        │   │   ├── PublicBusLine.swift       # Model representing a public bus line (number, name)
        │   │   └── PublicBusStop.swift       # Stop model for LTA-based public bus stops
        │   ├── NTU
        │   │   ├── NTUInternalBus.swift      # Model representing a shuttle bus and its vehicles
        │   │   ├── NTUInternalBusArrival.swift # Model for arrivals at an NTU shuttle stop
        │   │   └── NTUInternalBusStop.swift  # Model for internal NTU shuttle stops
        │   ├── NUS
        │   │   ├── NUSInternalBusArrival.swift # Arrival info for NUS internal buses
        │   │   ├── NUSInternalBusRoute.swift   # Route definition for NUS shuttles
        │   │   ├── NUSInternalBusStop.swift    # Model for a stop along a NUS route
        │   │   └── NUSLineActivityWrapper.swift# Helps determine if a NUS line is active
        │   └── SMU
        │       └── SMUBusStop.swift           # Model representing a public bus stop around SMU
        ├── Networking
        │   ├── Common
        │   │   ├── Constants.swift           # Shared API base URLs, keys, and other constants
        │   │   └── NetworkError.swift        # Standardized error enum for networking failures
        │   ├── LTA
        │   │   └── ArriveLahService.swift    # Fetches LTA public bus data from the ArriveLah API
        │   ├── NTU
        │   │   ├── APIResponseWrappers.swift # Codable wrappers for NTU API response decoding
        │   │   ├── NTUAPIResponseWrappers.swift # Possibly redundant or additional API models
        │   │   ├── NTUBusAPIClient.swift     # Client for fetching NTU internal bus data
        │   │   └── NTUEndpoint.swift         # Endpoint strings/paths for NTU API
        │   └── NUS
        │       └── NUSNextBusService.swift   # Client for NUS internal shuttle arrival data
        └── Resources
            ├── NTUPublicBusStopList.json    # Static stop list for NTU public buses
            ├── NUSInternalBusStopList.json  # Static stop list for NUS internal shuttles
            ├── NUSPublicBusStopList.json    # Static stop list for NUS public buses
            └── SMUPublicBusStopList.json    # Static stop list for SMU public buses

```

* ArriveLah API
```
.
└── ArriveLahAPI
    ├── api
    │   └── arrival.js
    ├── ArriveLahApp.swift
    ├── ArriveLahService.swift
    ├── BusArrivalResponse.swift
    ├── BusArrivalTestView.swift
    ├── env.txt
    ├── Instructions.md
    ├── package-lock.json
    ├── package.json
    ├── server.js
    ├── service.js
    └── vercel.json
```

* NTU Shuttle Bus API
```
.
└── NTUBusAPI
    ├── api
    │   ├── getBlueBus.ts
    │   ├── getBrownBus.ts
    │   ├── getBusArrival.ts
    │   ├── getBusStopDetails.ts
    │   ├── getGreenBus.ts
    │   ├── getRedBus.ts
    │   ├── getYellowBus.ts
    │   └── simulateGetBusArrival.ts
    ├── helper
    │   └── helper.ts
    ├── Instructions.md
    ├── jest.config.ts
    ├── LICENSE
    ├── package.json
    ├── serverless.yml
    ├── src
    │   ├── blueBus
    │   │   └── handler.ts
    │   ├── brownBus
    │   │   └── handler.ts
    │   ├── busArrival
    │   │   └── handler.ts
    │   ├── busStopDetails
    │   │   └── handler.ts
    │   ├── greenBus
    │   │   └── handler.ts
    │   ├── main
    │   │   └── handler.ts
    │   ├── redBus
    │   │   └── handler.ts
    │   └── yellowBus
    │       └── handler.ts
    └── yarn.lock
```

* NUS NextBus API
```
.
└── NUSBusAPI
    ├── NUSBusAPI
    │   ├── Assets.xcassets
    │   │   ├── AccentColor.colorset
    │   │   │   └── Contents.json
    │   │   ├── AppIcon.appiconset
    │   │   │   └── Contents.json
    │   │   └── Contents.json
    │   ├── ContentView.swift
    │   ├── Instructions.md
    │   ├── Models
    │   │   ├── ActiveBus.swift
    │   │   ├── ArrivalInfo.swift
    │   │   ├── BusRoute.swift
    │   │   └── BusStop.swift
    │   ├── NUSBusAPIApp.swift
    │   ├── Resources
    │   │   └── NUSBusStops.json
    │   ├── Services
    │   │   └── NUSNextBusService.swift
    │   ├── Utilities
    │   │   └── NetworkConstants.swift
    │   ├── ViewModels
    │   │   ├── ActiveBusViewModel.swift
    │   │   └── BusArrivalViewModel.swift
    │   └── Views
    │       ├── ActiveBusTestView.swift
    │       └── BusArrivalTestView.swift
    └── NUSBusAPI.xcodeproj
        ├── project.pbxproj
        ├── project.xcworkspace
        │   ├── contents.xcworkspacedata
        │   └── xcuserdata
        │       └── ava.xcuserdatad
        │           └── UserInterfaceState.xcuserstate
        └── xcuserdata
            └── ava.xcuserdatad
                ├── xcdebugger
                │   └── Breakpoints_v2.xcbkptlist
                └── xcschemes
                    └── xcschememanagement.plist
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