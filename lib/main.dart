import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/web_view_stack.dart';
import 'package:quick_actions/quick_actions.dart';

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
  late final WebViewController trackOrderController;
  late final WebViewController contactUsController;
  late final WebViewController siteSettingsController;

  @override
  void initState() {
    super.initState();
    final QuickActions quickActions = const QuickActions();
    quickActions.initialize((String shortcutType) {
      if (shortcutType == 'action_Track Order') {
        print(
            '-----------------------The user tapped on the Track Order action.----------------------------');
        trackOrderController = WebViewController()
          ..loadRequest(
            Uri.parse('https://www.carparts.com/myaccount/orderhistory'),
          );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewWidget(
              controller: trackOrderController,
            ),
          ),
        );
      } else if (shortcutType == 'action_Contact Us') {
        print(
            '--------------------------The user tapped on the Contact Us action.-----------------------------');
        contactUsController = WebViewController()
          ..loadRequest(
              Uri.parse('https://www.carparts.com/customerservice/email'));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewWidget(
              controller: contactUsController,
            ),
          ),
        );
      } else if (shortcutType == 'action_Site settings') {
        print(
            '--------------------------The user tapped on the Site settings action.-----------------------------');
      }
    });
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'action_Track Order',
          localizedTitle: 'Track Order',
          icon: 'minus'),
      const ShortcutItem(
          type: 'action_Contact Us',
          localizedTitle: 'Contact Us',
          icon: 'plus'),
      const ShortcutItem(
          type: 'action_Site settings',
          localizedTitle: 'Site settings',
          icon: 'plus')
    ]);

    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.carparts.com/?force_can=1'),
      );
  }

  Scaffold scaffoldWidget() {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: WebViewStack(controller: controller),
    );
  }

  backGestureButton() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? GestureDetector(
            onPanEnd: (details) async => backGestureButton(),
            child: scaffoldWidget(),
          )
        : WillPopScope(
            child: scaffoldWidget(),
            onWillPop: () async => backGestureButton(),
          );
  }
}
