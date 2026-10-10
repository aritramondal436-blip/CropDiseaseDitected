# emergency_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Weather

The home screen shows live weather for the device's current position. Weather
is fetched from [Open-Meteo](https://open-meteo.com), a free service that needs
**no API key**, and the administrative city/region label is resolved from
OpenStreetMap's Nominatim reverse geocoder (also keyless). There is nothing to
configure or commit.

### Web notes

Browser geolocation only works in a secure context, so serve the build over
`https`, or on `localhost` during development. `flutter run -d chrome` serves
on `localhost` and works out of the box, but serving `build/web` from a LAN IP
over plain `http` gets the location blocked by the browser — which surfaces as
a location error.

If Open-Meteo cannot be reached the weather card shows a retry prompt; the rest
of the app is unaffected.

