# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

Before Running Project 

```bash
flutter clean
flutter pub get
flutter run
```


If stuck on gradle build

```bash
cd ./Locatto/androind
```

Run:
```bash
 ./gradlew clean
```

## Routing

- Navigator

## To build with launch with custom icon 

must be config content on `app/flutter_launcher_icons.yaml` with icon from `app/assets/images/logo_primary.png`


if images was not found, shoud be config images path like `assets/images/footer/` on  `app/pubspec.yaml`


Then Run:
```bash
flutter pub run flutter_launcher_icons:main
```
