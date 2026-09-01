# Places

An iOS app that fetches a list of places from a remote JSON feed, displays them in a list, and lets the user search for a new place either by name or by coordinates. Tapping a place opens it on Wikipedia (via the Wikipedia app if installed, falling back to the web).


Built with SwiftUI and the `@Observable` macro, targeting iOS 17.6+.


# Dependencies
[wikipedia-ios](https://github.com/zibeydaliyeva/Wikipedia)

## Features

- **Places list** — fetches locations from a remote JSON endpoint on launch and displays name + coordinates for each.
- **Deep linking** — selecting a place (from the list or from search) opens `wikipedia://places?lat=...&lon=...` in the Wikipedia app; if that fails, it falls back to opening the place's Wikipedia page in the browser.
- **Localization** — all user-facing strings are in `Localizable.strings` (English).
- **Accessibility** — accessibility labels, hints, and identifiers throughout, used by the UI test suite.

## Architecture

The app follows an MVVM structure, organized by feature module:

```
Places/
├── App/                 # App entry point
├── Models/              # Location, LocationsResponse
├── Modules/
│   ├── Locations/       # Places list (View + ViewModel)
│   ├── SearchLocation/  # Search screen (View + ViewModel)
│   └── Common/          # Shared views (loading/error states)
├── Services/
│   ├── Network/         # APIService, APIRouter, NetworkError
│   └── DeepLinkService.swift
├── Utility/              # UI tokens, shared helpers, identifiers
└── Localization/

- **Views** are SwiftUI, kept declarative and free of business logic.
- **ViewModels** are `@Observable` classes that own state and talk to services through protocols (`APIServiceProtocol`, `DeepLinkServiceProtocol`, `GeocodingServiceProtocol`), so they can be unit-tested with mocks/stubs instead of hitting the network or Core Location.
- **Networking** goes through a small `APIRouter` (builds requests) + `APIService` (executes them and maps errors to a `NetworkError` enum with localized messages).
- Loading/error/content states are modeled with a single `LoadingState<Value>` enum and rendered by a generic `LoadingStateView`, so every screen handles idle/loading/loaded/failed the same way.

## Requirements

- Xcode 16 or later
- iOS 17.6+ (deployment target)
- **Wikipedia App: Ensure the Wikipedia app is installed on your device or simulator; otherwise, the link will open in a web view.**
