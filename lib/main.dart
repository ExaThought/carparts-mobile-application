import 'package:carparts/src/inapp_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/web_view_stack.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
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
    return InAppWebViewWidget();
    // return WillPopScope(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       toolbarHeight: 0,
    //     ),
    //     body: WebViewStack(controller: controller),
    //   ),
    //   onWillPop: () async {
    //     if (await controller.canGoBack()) {
    //       await controller.goBack();
    //     } else {
    //       return Future.value(true);
    //     }
    //     return Future.value(false);
    //   },
    // );
  }
}
