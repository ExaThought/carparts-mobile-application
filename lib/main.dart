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

  print(await FirebaseMessaging.instance.getToken());

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
