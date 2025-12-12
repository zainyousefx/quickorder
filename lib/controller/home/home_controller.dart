import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/core/binding/local_preferences.dart';
import '/model/meal_model.dart';
import '/model/restaurant_model.dart';
import '../../core/connection/dio_remote.dart';
import '../../core/constants/constants.dart';

class HomeController extends GetxController {
  LocalPreferences localPreferences = Get.find();

  var scrollController = ScrollController().obs;
  var hideNav = false.obs;

  var isSheetOpened = false.obs;

  var mealsLoading = false.obs;
  var mealsHasError = false.obs;
  var mealsError = "".obs;

  var restaurantLoading = false.obs;
  var restaurantHasError = false.obs;
  var restaurantError = "".obs;

  var meals = [].obs;
  var restaurantList = [].obs;

  getMeals() async {
    try {
      mealsLoading(true);
      final response = await DioSingleton().dioInstance.get(
          '${API}show_all_meals',
          data: {"user_id": localPreferences.getUser()!.value.id});

      if (response.statusCode == 200) {
        var mealsList = [];
        for (var meal in response.data["response"]) {
          mealsList.add(MealModel.fromJson(meal));
        }
        meals(mealsList);
        mealsHasError(false);
        mealsLoading(false);
      } else {
        debugPrint("error else $response");

        mealsLoading(false);
        mealsHasError(true);
        mealsError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      mealsLoading(false);
      mealsHasError(true);
      mealsError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getMealsByCategory() async {
    MealController mealController = Get.find();

    try {
      mealsLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .get('${API}show_meals_by_category_id', data: {
        'category_id': mealController.selectedCategoryFilter.value.id
      });

      if (response.statusCode == 200) {
        var mealsList = [];
        for (var meal in response.data["response"]) {
          mealsList.add(MealModel.fromJson(meal));
        }
        meals(mealsList);
        mealsHasError(false);
        mealsLoading(false);
      } else {
        debugPrint("error else $response");

        mealsLoading(false);
        mealsHasError(true);
        mealsError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      mealsLoading(false);
      mealsHasError(true);
      mealsError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getRestaurants() async {
    try {
      restaurantLoading(true);
      final response =
          await DioSingleton().dioInstance.get('${API}show_restaurant');

      if (response.statusCode == 200) {
        var resList = [];
        for (var restaurant in response.data["response"]) {
          resList.add(RestaurantModel.fromJson(restaurant));
        }
        restaurantList(resList);
        restaurantHasError(false);
        restaurantLoading(false);
      } else {
        debugPrint("error else $response");

        restaurantLoading(false);
        restaurantHasError(true);
        restaurantError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      restaurantLoading(false);
      restaurantHasError(true);
      restaurantError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
