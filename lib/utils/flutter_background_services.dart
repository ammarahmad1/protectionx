import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:background_sms/background_sms.dart';
import 'package:background_location/background_location.dart';
import 'package:protectionx/db/db_services.dart';
import 'package:protectionx/model/contactsm.dart';
import 'package:telephony/telephony.dart';
import 'package:shake/shake.dart';
import 'package:vibration/vibration.dart';

bool isMessageSent = false;

sendMessage(String messageBody) async {
  List<TContact> contactList = await DatabaseHelper().getContactList();
  if (contactList.isEmpty) {
    Fluttertoast.showToast(msg: "No number exists. Please add a number.");
  } else {
    for (var contact in contactList) {
      Telephony.backgroundInstance
          .sendSms(to: contact.number, message: messageBody)
          .then((value) {
        Fluttertoast.showToast(msg: "Message sent");
      }).catchError((error) {
        Fluttertoast.showToast(msg: "Failed to send message: $error");
      });
    }
  }
  isMessageSent = false;
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    "protection_x",
    "Protection X",
    description: "Used for important notifications",
    importance: Importance.low,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: "protection_x",
      initialNotificationTitle: "Protection X",
      initialNotificationContent: "Initializing",
      foregroundServiceNotificationId: 888,
    ),
  );
  service.startService();
}

@pragma('vm-entry-point')
void onStart(ServiceInstance service) async {
  Location? clocation;

  DartPluginRegistrant.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  await BackgroundLocation.setAndroidNotification(
    title: "Protection X - Location tracking is running in the background!",
    message: "You can turn it off from the settings menu inside the app",
    icon: '@mipmap/ic_logo',
  );
  BackgroundLocation.startLocationService(
    distanceFilter: 20,
  );

  BackgroundLocation.getLocationUpdates((location) {
    clocation = location;
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      ShakeDetector.autoStart(
        shakeThresholdGravity: 10, // Increased threshold for less sensitivity
        shakeSlopTimeMS: 500,
        shakeCountResetTime: 3000,
        minimumShakeCount: 1,
        onPhoneShake: () async {
          bool? hasVibrator = await Vibration.hasVibrator();
          if (!isMessageSent && (hasVibrator ?? false)) {
            if (await Vibration.hasCustomVibrationsSupport() ?? false) {
              Vibration.vibrate(duration: 1000);
            } else {
              Vibration.vibrate();
              await Future.delayed(Duration(milliseconds: 500));
              Vibration.vibrate();
            }

            if (clocation != null) {
              String messageBody =
                  "https://www.google.com/maps/search/?api=1&query=${clocation!.latitude}%2C${clocation!.longitude}";
              sendMessage(messageBody);
              isMessageSent = true; // Ensure only one message per shake
            } else {
              Fluttertoast.showToast(msg: "Location not available");
            }
          }
        },
      );

      flutterLocalNotificationsPlugin.show(
        888,
        "Protection X",
        clocation == null
            ? "Please enable location"
            : "Shake feature enabled at ${clocation!.latitude}",
        NotificationDetails(
          android: AndroidNotificationDetails(
            "protection_x",
            "Protection X",
            channelDescription: "Used for important notifications",
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );
    }
  }
}
