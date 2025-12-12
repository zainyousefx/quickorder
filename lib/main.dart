import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/binding/main_binding.dart';
import '/view/splash/splash_page.dart';

import 'core/constants/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBinding(),
      title: 'Restaurant Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}


