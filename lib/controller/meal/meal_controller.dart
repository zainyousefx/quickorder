import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/home/home_controller.dart';
import '/core/binding/local_preferences.dart';
import 'package:dio/dio.dart' as dio;
import '/model/category.dart';
import '/model/restaurant_model.dart';
import '../../core/connection/dio_remote.dart';
import '../../core/constants/constants.dart';
import '../../model/meal_model.dart';

class MealController extends GetxController {
  LocalPreferences localPreferences = Get.find();
  HomeController homeController = Get.find();

  var orderList = [];
  var meals = [].obs;
  var favMeals = <MealModel>[].obs;
  var categories = <Category>[].obs;
  var searchMealsList = <MealModel>[].obs;

  var name = TextEditingController();
  var description = TextEditingController();
  var price = TextEditingController();
  var category = TextEditingController();
  var selectedImage = XFile("").obs;
  var categoryId = -1.obs;
  var selectedRes = RestaurantModel(-1, "", "", 0, "", "", null, "", "").obs;
  var selectedCategory = Category(-1, "").obs;
  var selectedCategoryFilter = Category(-1, "").obs;

  var mealsLoading = false.obs;
  var mealsHasError = false.obs;
  var mealsError = "".obs;

  var addLoading = false.obs;
  var addHasError = false.obs;
  var addError = "".obs;

  var categoryLoading = false.obs;
  var categoryHasError = false.obs;
  var categoryError = "".obs;

  var addToFavMealId = (-1).obs;
  var addToFavLoading = false.obs;
  var addToFavHasError = false.obs;
  var addToFavError = "".obs;

  var removeFavLoading = false.obs;
  var removeFavHasError = false.obs;
  var removeFavError = "".obs;

  var favMealsLoading = false.obs;
  var favMealsHasError = false.obs;
  var favMealsError = "".obs;

  var searchMealsLoading = false.obs;
  var searchMealsHasError = false.obs;
  var searchMealsError = "".obs;

  var addCategoryLoading = false.obs;
  var addCategoryHasError = false.obs;
  var addCategoryError = "".obs;

  var deleteMealLoading = false.obs;
  var deleteMealHasError = false.obs;
  var deleteMealError = "".obs;

  getMealsByRes(int id) async {
    try {
      mealsLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .get('${API}show_restaurant_meals', data: {'restaurant_id': id});

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

  getMealsByCategory(int categoryId) async {
    try {
      mealsLoading(true);
      final response = await DioSingleton().dioInstance.get(
          '${API}show_meals_by_category_id',
          data: {'category_id': categoryId});

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

  getCategories() async {
    try {
      categoryLoading(true);
      final response =
          await DioSingleton().dioInstance.get('${API}show_all_categories');

      if (response.statusCode == 200) {
        var categoryList = <Category>[];
        for (var category in response.data["categories"]) {
          categoryList.add(Category.fromJson(category));
        }
        categories(categoryList);
        categoryHasError(false);
        categoryLoading(false);
      } else {
        debugPrint("error else $response");

        categoryLoading(false);
        categoryHasError(true);
        categoryError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      categoryLoading(false);
      categoryHasError(true);
      categoryError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  addMeal() async {
    try {
      debugPrint(
          "selectedImage  ${selectedImage.value.path}   ${selectedImage.value.name}");
      addLoading(true);
      final response = await DioSingleton().dioInstance.post('${API}add_meal',
          data: dio.FormData.fromMap({
            "name": name.text,
            "restaurant_id": selectedRes.value.id,
            "category_id": selectedCategory.value.id,
            "price": price.text,
            "description": description.text,
            "img": await dio.MultipartFile.fromFile(selectedImage.value.path,
                filename: selectedImage.value.name),
          }));

      if (response.statusCode == 200) {
        debugPrint("response  $response");
        Get.back();
        homeController.getMeals();
        addHasError(false);
        addLoading(false);
      } else {
        debugPrint("error else $response");

        addLoading(false);
        addHasError(true);
        addError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      addLoading(false);
      addHasError(true);
      addError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  deleteMeal(mealId) async {
    try {
      deleteMealLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}delete_meal', data: {"meal_id": mealId});

      if (response.statusCode == 200 && response.data['message'] != null) {
        debugPrint("response  $response");
        Get.back();
        Get.back();
        Future.delayed(
          Duration(seconds: 1),
          () => homeController.getMeals(),
        );
        deleteMealHasError(false);
        deleteMealLoading(false);
      } else {
        debugPrint("error else $response");

        deleteMealLoading(false);
        deleteMealHasError(true);
        deleteMealError(response.data["error"] != null
            ? "You can't delete an item which has been in order and the order is not DONE yet!"
            : "Something went wrong!");
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(deleteMealError.value),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      debugPrint("error catch $e");
      deleteMealLoading(false);
      deleteMealHasError(true);
      deleteMealError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,));
    }
  }

  addMealToFav(int mealId) async {
    try {
      addToFavMealId(mealId);
      addToFavLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}add_favourite', data: {
        'meal_id': mealId,
        "user_id": localPreferences.getUser()!.value.id
      });

      if (response.statusCode == 200) {
        addToFavMealId(-1);
        MealModel favMeal =
            homeController.meals.singleWhere((element) => element.id == mealId);
        var favMealIndex = homeController.meals.indexOf(favMeal);
        favMeal.favourite = true;
        homeController.meals.removeAt(favMealIndex);
        homeController.meals.insert(favMealIndex, favMeal);
        addToFavHasError(false);
        addToFavLoading(false);
      } else {
        debugPrint("error else $response");
        addToFavMealId(-1);
        addToFavLoading(false);
        addToFavHasError(true);
        addToFavError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      addToFavMealId(-1);
      addToFavLoading(false);
      addToFavHasError(true);
      addToFavError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  removeMealFromFav(int mealId, {source}) async {
    try {
      addToFavMealId(mealId);
      removeFavLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}delete_favourite', data: {
        'meal_id': mealId,
        "user_id": localPreferences.getUser()!.value.id
      });

      if (response.statusCode == 200) {
        addToFavMealId(-1);
        MealModel favMeal =
            homeController.meals.singleWhere((element) => element.id == mealId);
        var favMealIndex = homeController.meals.indexOf(favMeal);
        favMeal.favourite = false;
        homeController.meals.removeAt(favMealIndex);
        homeController.meals.insert(favMealIndex, favMeal);
        if (source == "FP")
          favMeals.removeWhere((element) => element.id == mealId);
        removeFavHasError(false);
        removeFavLoading(false);
      } else {
        debugPrint("error else $response");
        addToFavMealId(-1);
        removeFavLoading(false);
        removeFavHasError(true);
        removeFavError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      addToFavMealId(-1);
      removeFavLoading(false);
      removeFavHasError(true);
      removeFavError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getFavMeals() async {
    try {
      favMealsLoading(true);
      final response = await DioSingleton().dioInstance.get(
          '${API}show_favourite_by_user_id',
          data: {'user_id': localPreferences.getUser()!.value.id});

      if (response.statusCode == 200) {
        var mealsList = <MealModel>[];
        for (var meal in response.data["response"]) {
          mealsList.add(MealModel.fromJsonFav(meal));
        }
        favMeals(mealsList);
        favMealsHasError(false);
        favMealsLoading(false);
      } else {
        debugPrint("error else $response");

        favMealsLoading(false);
        favMealsHasError(true);
        favMealsError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      favMealsLoading(false);
      favMealsHasError(true);
      favMealsError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void clear() {
    name.clear();
    price.clear();
    category.clear();
    description.clear();
    selectedImage(XFile(""));
  }

  searchMeal(String text) async {
    try {
      searchMealsLoading(true);
      final response =
          await DioSingleton().dioInstance.post('${API}meal_search', data: {
        "meal_name": text,
        "user_id": localPreferences.getUser()!.value.id,
      });

      if (response.statusCode == 200) {
        debugPrint("response $response");
        var mealList = <MealModel>[];
        for (var meal in response.data["response"]) {
          mealList.add(MealModel.fromJson(meal));
        }
        searchMealsList(mealList);
        searchMealsHasError(false);
        searchMealsLoading(false);
      } else {
        debugPrint("error else $response");

        searchMealsLoading(false);
        searchMealsHasError(true);
        searchMealsError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      searchMealsLoading(false);
      searchMealsHasError(true);
      searchMealsError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void addCategory() async {
    try {
      addCategoryLoading(true);
      final response =
          await DioSingleton().dioInstance.post('${API}add-category', data: {
        "name": category.text,
      });

      if (response.statusCode == 200) {
        debugPrint("response $response");
        addCategoryHasError(false);
        addCategoryLoading(false);
        Get.back();
        getCategories();
      } else {
        debugPrint("error else $response");

        addCategoryLoading(false);
        addCategoryHasError(true);
        addCategoryError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      addCategoryLoading(false);
      addCategoryHasError(true);
      addCategoryError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
