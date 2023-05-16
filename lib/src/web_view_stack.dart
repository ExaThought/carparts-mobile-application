import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

class WebViewStack extends StatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // print("vaishak");
    // print(widget.controller.currentUrl().then((value) => print(value)));
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          // onPageStarted: (url) async {
          //   print(
          //       "onPageStarted**************************************************************************");
          //   if (_isInitialLoad) {
          //     final Uri uri = Uri.parse(url);
          //     print("on page started $uri");
          //     final Map<String, String> queryParameters =
          //         Map.from(uri.queryParameters);
          //     queryParameters.addAll({'fromMobile': '1'});
          //     print("on page started $queryParameters");
          //     final Uri modifiedUri =
          //         Uri.https(uri.authority, uri.path, queryParameters);
          //     print("on page started $modifiedUri");
          //     await widget.controller.loadRequest(modifiedUri);
          //     setState(() {
          //       loadingPercentage = 0;
          //     });
          //     _isInitialLoad = false;
          //   }
          //   // final Uri uri = Uri.parse(url);
          //   // print(uri);
          //   // final Map<String, String> queryParameters =
          //   //     Map.from(uri.queryParameters);
          //   // queryParameters.addAll({'fromMobile': '1'});
          //   // print(queryParameters);
          //   // final Uri modifiedUri =
          //   //     Uri.https(uri.authority, uri.path, queryParameters);
          //   // print(modifiedUri);
          //   // await widget.controller.loadRequest(modifiedUri);
          //   // setState(() {
          //   //   loadingPercentage = 0;
          //   // });
          // },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation)  {
            // print(
            //     "onNavigationRequest^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
            // final Uri uri = Uri.parse(navigation.url);
            // print(navigation);
            // print(navigation.url);
            // print(uri);
            // final Map<String, String> queryParameters =
            //     Map.from(uri.queryParameters);
            // queryParameters.addAll({'fromMobile': '1'});
            // print(queryParameters);
            // final Uri modifiedUri =
            //     Uri.https(uri.authority, uri.path, queryParameters);
            // print(modifiedUri);
            // if (navigation.url.contains('//page/')) {
            //   return NavigationDecision.prevent;
            // }
            // widget.controller.loadRequest(modifiedUri);
            // // if (navigation.url.contains('//page/')) {
            // //   return NavigationDecision.prevent;
            // // }
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) async {
            // print("steph curry");
            // final Uri uri = Uri.parse(change as String);
            //   print("onUrlChange $uri");
            //   final Map<String, String> queryParameters =
            //       Map.from(uri.queryParameters);
            //   queryParameters.addAll({'fromMobile': '1'});
            //   print("onUrlChange $queryParameters");
            //   final Uri modifiedUri =
            //       Uri.https(uri.authority, uri.path, queryParameters);
            //   print("onUrlChange $modifiedUri");
            //   await widget.controller.loadRequest(modifiedUri);
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          },
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
