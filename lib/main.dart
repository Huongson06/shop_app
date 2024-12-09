import 'package:flutter/material.dart';
import 'package:shoplite/constants/color_data.dart';
import 'package:shoplite/ui/intro/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(primaryColor: primaryColor);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const SplashScreen(),
    );
  }
}
