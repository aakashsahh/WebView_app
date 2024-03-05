import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_view/Screens/splash_screen.dart';
import 'package:web_view/widgets/my_web_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child:  const MyApp()),
    );
     
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
