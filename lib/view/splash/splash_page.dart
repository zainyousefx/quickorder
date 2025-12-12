import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/view/auth/sign_up.dart';
import '/view/home/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      LocalPreferences localPreferences = Get.find();

      if (localPreferences.getUser() != null) {
        Get.off(() => const BottomNavigation());
      } else {
        Get.off(() => const SignUp());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/food.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.center),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(75.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Restaurant App",
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
