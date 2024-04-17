import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/models/share_guardar.dart';
import 'app/clases/cConfig_UI.dart';
import 'app/controllers/firebase_push/token_monitor.dart';
import 'app/models/app.dart';
import 'app/models/share_clientes.dart' as share_clientes;
import 'app/models/share_kyc.dart' as kyc;
import 'app/models/share_preferences.dart' as login;
import 'app/models/share_productos.dart' as share_productos;
import 'firebase_options.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await login.Preferences.init();
  await kyc.PreferencesKYC.init();
  await share_clientes.PreferencesCliente.init();
  await share_productos.PreferencesProductos.init();
  await PreferencesGuardar.init();
  // INTERNET
  //FIREBASE
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                color: Color.fromARGB(255, 255, 0, 0),
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
  final pushProvider = PushNotificationProvider();
  pushProvider.initNotifications();
  //**FIN FIREBASE
//Defino Colores en la barra superior e inferior
  final Brightness bright =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          bright == Brightness.light ? ColorFondo.PRIMARY : ColorFondo.PRIMARY,
      // systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: bright == Brightness.light
          ? ColorFondo.PRIMARY
          : ColorFondo.PRIMARY));
  // Orientación Solo Vertical
  /* SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); */
  runApp(MyApp(
    prefs: prefs,
  ));
}
