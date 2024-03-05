import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  MyWebView({Key? key, required this.controller}) : super(key: key);
  final WebViewController controller;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var loadingPercentage = 0;
  bool isConnected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        isConnected = (result != ConnectivityResult.none);
      });
    });

    if (mounted) {
      checkConnectivity();
    }

    widget.controller
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        loadingPercentage = 0;
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("Snack", onMessageReceived: (message) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
      });
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isConnected
        ? Stack(
            children: [
              WebViewWidget(controller: widget.controller),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          )
        : const Column(
            children: [
              Icon(
                Icons.signal_wifi_statusbar_connected_no_internet_4,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text("No internet"),
              ),
            ],
          );
  }
}
