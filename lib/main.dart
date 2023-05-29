import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(MaterialApp(
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
      home: new MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    javaScriptEnabled: true,
    javaScriptCanOpenWindowsAutomatically: true,
    allowsBackForwardNavigationGestures: true,
    supportMultipleWindows: true,
    // useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: true,
    allowsInlineMediaPlayback: true,
    // // iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    userAgent:
        '(Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Mobile Safari/537.36',
    // userAgent:
    //     'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.5304.105 Mobile Safari/537.36'
  );

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Color.fromARGB(255, 47, 71, 135),
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // detect Android back button click
          final controller = webViewController;
          if (controller != null) {
            if (await controller.canGoBack()) {
              controller.goBack();
              return false;
            }
          }
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
            ),
            body: SafeArea(
                child: Column(children: <Widget>[
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      key: webViewKey,
                      initialUrlRequest:
                          URLRequest(url: WebUri('https://www.carparts.com')),
                      initialSettings: settings,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) {
                        webViewController = controller;
                      },
                      onLoadStart: (controller, url) {
                        // print("URL" + url.toString());
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onPermissionRequest: (controller, request) async {
                        return PermissionResponse(
                            resources: request.resources,
                            action: PermissionResponseAction.GRANT);
                      },
                      onCreateWindow: (controller, createWindowAction) async {
                        if (url.contains("checkout")) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return WindowPopup(
                                  createWindowAction: createWindowAction);
                            },
                          );
                          return true;
                        } else if (Platform.isAndroid) {
                          print("INSIDE");
                          showDialog(
                            context: context,
                            builder: (context) {
                              return NavigationWindowWidget(
                                  createWindowAction: createWindowAction,
                                  webViewController: webViewController,
                                  url: url);
                            },
                          );
                          return true;
                        }
                        return false;
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        print(
                            "main shouldOverrideUrlLoading***************************************************");
                        var uri = navigationAction.request.url!;

                        if (url.contains("fb://page/")) {
                          return NavigationActionPolicy.CANCEL;
                        }

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunchUrl(uri)) {
                            // Launch the App
                            await launchUrl(
                              uri,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController?.endRefreshing();
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onReceivedError: (controller, request, error) {
                        pullToRefreshController?.endRefreshing();
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController?.endRefreshing();
                        }
                        setState(() {
                          this.progress = progress / 100;
                          urlController.text = this.url;
                        });
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        // print(consoleMessage);
                      },
                    ),
                    progress < 1.0
                        ? LinearProgressIndicator(value: progress)
                        : Container(),
                  ],
                ),
              ),
            ]))));
  }
}

class WindowPopup extends StatefulWidget {
  final CreateWindowAction createWindowAction;

  const WindowPopup({Key? key, required this.createWindowAction})
      : super(key: key);

  @override
  State<WindowPopup> createState() => _WindowPopupState();
}

class _WindowPopupState extends State<WindowPopup> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisSize: MainAxisSize.max, children: [
              Expanded(
                child:
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close))
            ]),
            Expanded(
              child: InAppWebView(
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                windowId: widget.createWindowAction.windowId,
                onTitleChanged: (controller, title) {
                  setState(() {
                    this.title = title ?? '';
                  });
                },
                onCloseWindow: (controller) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationWindowWidget extends StatefulWidget {
  final CreateWindowAction createWindowAction;
  final InAppWebViewController? webViewController;
  final String url;

  NavigationWindowWidget(
      {Key? key,
      required this.createWindowAction,
      required this.webViewController,
      required this.url})
      : super(key: key);

  @override
  _NavigationWindowWidgetState createState() =>
      new _NavigationWindowWidgetState();
}

class _NavigationWindowWidgetState extends State<NavigationWindowWidget> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    print("WIDGET VIEW");
    return WillPopScope(
      onWillPop: () async {
        // detect Android back button click
        final controller = widget.webViewController;
        if (controller != null) {
          if (await controller.canGoBack()) {
            controller.goBack();
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InAppWebView(
                  initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      allowsBackForwardNavigationGestures: true,
                      supportMultipleWindows: true,
                      javaScriptCanOpenWindowsAutomatically: true),
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onCreateWindow: (controller, createWindowAction) async {
                    print("OHHH");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NavigationWindowWidget(
                          createWindowAction: createWindowAction,
                          webViewController: widget.webViewController,
                          url: widget.url,
                        );
                      },
                    );
                    return true;
                  },
                  windowId: widget.createWindowAction.windowId,
                  onTitleChanged: (controller, title) {
                    setState(() {
                      this.title = title ?? '';
                    });
                  },
                  onCloseWindow: (controller) {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
