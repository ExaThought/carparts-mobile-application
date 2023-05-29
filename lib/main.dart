import 'package:carparts/local_notification_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'firebase_options.dart';
import 'src/web_view_stack.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  LocalNotificationPlugin.instance.backgroundDisplay(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging message = FirebaseMessaging.instance;
  NotificationSettings settings = await message.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  print(await FirebaseMessaging.instance.getToken());

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          shadowColor: Colors.transparent,
          elevation: 0.0,
          color: Color.fromARGB(255, 47, 71, 135),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color.fromARGB(255, 47, 71, 135),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      LocalNotificationPlugin.instance.initialize();
    });
    /*
    *On click of notification, it opens app from terminated state
    * It is also important so that foreground works and used when app is in background or terminated or closed
    */
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      /*
     *For routing of page from terminated state to be handled here
     */
      if (message != null) {
        LocalNotificationPlugin.instance.backgroundDisplay(message);
      }
    });

    /*
    *When app is in foreground that is running 
    */
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationPlugin.instance.display(message);
    });
    /*
      *When app is open and to make sure for onclick of notification that, 
      *It is routed to different page
      *Works when user taps on the notification 
      *Works only when app is in background but opened and user taps
      */

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      LocalNotificationPlugin.instance.backgroundDisplay(message);
    });

    controller = WebViewController();
    if (controller.platform is WebKitWebViewController) {
      (controller.platform as WebKitWebViewController)
          .setAllowsBackForwardNavigationGestures(true);
    }
    controller.loadRequest(
      Uri.parse('https://www.carparts.com/?force_can=1'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: WebViewStack(controller: controller),
      ),
      onWillPop: () async {
        if (await controller.canGoBack()) {
          await controller.goBack();
        } else {
          return Future.value(true);
        }
        return Future.value(false);
      },
    );
  }
}
