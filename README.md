# Slotora

Slotora is a local appointment scheduling app. It lets users choose a booking
duration, view available time slots, validate a selection, and confirm a
booking. The app includes light and dark themes and English and Arabic
localization.

## Development

```sh
flutter pub get
flutter analyze
flutter test
```

## Release builds

Configure a publisher-owned Android application ID and release signing key
before publishing. The checked-in Android release build currently uses the
debug signing configuration. Configure the iOS bundle identifier and signing
team in Xcode before distributing an iOS build.
