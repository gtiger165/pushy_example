import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pushy_flutter/pushy_flutter.dart';

import 'app/routes/app_pages.dart';

// Please place this code in main.dart,
// After the import statements, and outside any Widget class (top-level)

void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'MyApp';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  Pushy.notify(notificationTitle, notificationText, data);

  // Clear iOS app badge number
  Pushy.clearBadge();
}

Future pushyRegister() async {
  print("execute pushRegister() method");
  try {
    Pushy.listen();
    // Register the user for push notifications
    String deviceToken = await Pushy.register();

    // Print token to console/logcat
    print('Device token: $deviceToken');

    // Display an alert with the device token
    Get.dialog(
      AlertDialog(
        title: Text('Pushy'),
        content: Text('Pushy device token: $deviceToken'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () => Get.back(),
          )
        ],
      ),
    );

    // Optionally send the token to your backend server via an HTTP GET request
    // ...
    // Enable in-app notification banners (iOS 10+)
    Pushy.toggleInAppBanner(true);

    // Listen for push notifications received
    Pushy.setNotificationListener(backgroundNotificationListener);
  } on PlatformException catch (error) {
    // Display an alert with the error message
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text("${error.message}"),
        actions: [TextButton(child: Text('OK'), onPressed: () => Get.back())],
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Pushy.listen();
  pushyRegister();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
