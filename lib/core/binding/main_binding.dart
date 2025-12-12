import 'package:get/get.dart';
import '/controller/auth/login_controller.dart';
import '/controller/home/home_controller.dart';
import '/controller/meal/meal_controller.dart';
import '/controller/order/order_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth/signup_controller.dart';
import 'local_preferences.dart';

class MainBinding extends Bindings{
  @override
  Future<void> dependencies() async {
    await Get.putAsync<LocalPreferences>(() async {
      final instance = await SharedPreferences.getInstance();
      LocalPreferences localStorage = LocalPreferences(instance);
      return localStorage;
    }, permanent: true);

    Get.lazyPut(()=>SignUpController(),fenix: true);
    Get.lazyPut(()=>LoginController(),fenix: true);
    Get.lazyPut(()=>HomeController(),fenix: true);
    Get.lazyPut(()=>MealController(),fenix: true);
    Get.lazyPut(()=>OrderController(),fenix: true);
    Get.lazyPut(()=>RestaurantController(),fenix: true);
  }
}