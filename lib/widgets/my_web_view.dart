import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConnectivityProvider extends ChangeNotifier {
  late bool _isConnected;

  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _isConnected = true; // Assume connected initially
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = (result != ConnectivityResult.none);
      notifyListeners();
    });
  }
  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    _isConnected = (connectivityResult != ConnectivityResult.none);
    notifyListeners();
  }
}

class MyWebView extends StatefulWidget {
  const MyWebView({super.key, required this.controller});
  final WebViewController controller;

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  var loadingPercentage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (mounted) {
      Provider.of<ConnectivityProvider>(context, listen: false).checkConnectivity();
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

  // Future<void> checkConnectivity() async {
  //   var connectivityResult = await Connectivity().checkConnectivity();
  //   setState(() {
  //     isConnected = (connectivityResult != ConnectivityResult.none);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: true);
    return connectivityProvider.isConnected
        ? Stack(
            children: [
              WebViewWidget(controller: widget.controller),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100.0,
                ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/no_internet.png'),
              const Center(
                child: Text(
                  "Oops!! No internet connection",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
  }
}
