# adplayer_flutter_plugin

A Flutter plugin for using the native AdPlayer SDK.

## Getting Started

### Setup

To gain access to the AdPlayer APIs, first initialize AdPlayer SDK:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdPlayer.initialize(
      iosStoreUrl: "STORE_URL_TO_YOUR_APP" // mandatory only for iOS
  );
  await AdPlayer.initializePublisher(publisherId: pubId, tagId: tagId);

  runApp(const MyApp());
}
```

### Display

The player is displayed with the help of `AdPlayerPlacementWidget` widget:

```dart
  @override
Widget build(BuildContext context) {
  return AdPlayerPlacementWidget(tagId: tagId);
}
```
