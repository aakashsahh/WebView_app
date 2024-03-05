
import 'package:flutter/material.dart';
import 'package:web_view/widgets/my_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
 
}

class _HomePageState extends State<HomePage> {
  late final WebViewController controller;
  //inttialize controller
  
   @override
  void initState() {
    super.initState();
     controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse('https://koselixpress.com/'));
    
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body:
            MyWebView(controller: controller ),

            
          
        );
  }
}



