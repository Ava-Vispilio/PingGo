# PingGo

## Current Directory Structure

```
.
├── BusTrackerApp
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── BusTrackerApp.entitlements
│   ├── BusTrackerApp.swift
│   ├── ContentView.swift
│   ├── Services
│   │   └── NotificationManager.swift
│   ├── ViewModels
│   │   ├── NTU
│   │   │   ├── NTUActiveBusLinesViewModel.swift
│   │   │   ├── NTUInternalBusLineDetailViewModel.swift
│   │   │   ├── NTUInternalBusStopArrivalViewModel.swift
│   │   │   ├── NTUPublicBusLineDetailViewModel.swift
│   │   │   └── NTUPublicBusStopArrivalViewModel.swift
│   │   ├── NUS
│   │   │   ├── NUSActiveBusLineListViewModel.swift
│   │   │   ├── NUSPublicBusArrivalViewModel.swift
│   │   │   └── NUSPublicBusStopListViewModel.swift
│   │   └── SMU
│   │       ├── SMUPublicBusArrivalViewModel.swift
│   │       └── SMUPublicBusStopListViewModel.swift
│   └── Views
│       ├── NTU
│       │   ├── NTUInternalBusLineDetailView.swift
│       │   ├── NTUInternalBusStopArrivalView.swift
│       │   ├── NTULineSelectionView.swift
│       │   ├── NTUPublicBusLineDetailView.swift
│       │   └── NTUPublicBusStopArrivalView.swift
│       ├── NUS
│       │   ├── NTUPublicBusStopListView.swift
│       │   ├── NUSLineSelectionView.swift
│       │   └── NUSPublicBusArrivalView.swift
│       └── SMU
│           ├── SMUPublicBusArrivalView.swift
│           └── SMUPublicBusStopSelectionView.swift
├── BusTrackerApp.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   └── swiftpm
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       └── ava_vispilio.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   └── xcuserdata
│       └── ava_vispilio.xcuserdatad
│           └── xcschemes
│               └── xcschememanagement.plist
├── BusTrackerAppTests
│   └── BusTrackerAppTests.swift
├── BusTrackerAppUITests
│   ├── BusTrackerAppUITests.swift
│   └── BusTrackerAppUITestsLaunchTests.swift
├── BusTrackerWatchApp Watch App
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── BusTrackerWatchApp.swift
│   ├── ContentView.swift
│   ├── Services
│   │   └── NotificationManager.swift
│   ├── ViewModels
│   │   ├── NTUWatchArrivalViewModel.swift
│   │   ├── NTUWatchBusStopListViewModel.swift
│   │   └── NTUWatchLineSelectionViewModel.swift
│   └── Views
│       ├── NTUWatchArrivalView.swift
│       ├── NTUWatchBusStopListView.swift
│       └── NTUWatchLineSelectionView.swift
├── BusTrackerWatchApp Watch AppTests
│   └── BusTrackerWatchApp_Watch_AppTests.swift
├── BusTrackerWatchApp Watch AppUITests
│   ├── BusTrackerWatchApp_Watch_AppUITests.swift
│   └── BusTrackerWatchApp_Watch_AppUITestsLaunchTests.swift
└── Shared
    ├── Models
    │   ├── LTA
    │   │   ├── LTABusArrival.swift
    │   │   ├── PublicBusArrival.swift
    │   │   ├── PublicBusLine.swift
    │   │   └── PublicBusStop.swift
    │   ├── NTU
    │   │   ├── NTUInternalBus.swift
    │   │   ├── NTUInternalBusArrival.swift
    │   │   └── NTUInternalBusStop.swift
    │   ├── NUS
    │   └── SMU
    │       └── SMUBusStop.swift
    ├── Networking
    │   ├── Common
    │   │   ├── Constants.swift
    │   │   └── NetworkError.swift
    │   ├── LTA
    │   │   └── ArriveLahService.swift
    │   ├── NTU
    │   │   ├── APIResponseWrappers.swift
    │   │   ├── NTUAPIResponseWrappers.swift
    │   │   ├── NTUBusAPIClient.swift
    │   │   └── NTUEndpoint.swift
    │   └── NUS
    └── Resources
        ├── NTUPublicBusStopList.json
        ├── NUSPublicBusStopList.json
        └── SMUPublicBusStopList.json

47 directories, 67 files
```
