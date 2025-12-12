import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/core/constants/constants.dart';
import '/view/widgets/food_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  MealController mealController = Get.find();

  @override
  void initState() {
    mealController.getFavMeals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => mealController.getFavMeals(),
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Favorites",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 20,
              ),
              Obx(
                () => mealController.favMealsLoading.value
                    ? itemsShimmer()
                    : mealController.favMealsHasError.value
                        ? showError(mealController.favMealsError.value)
                        : mealController.favMeals.isEmpty
                            ? showEmpty()
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: mealController.favMeals.length,
                                itemBuilder: (context, index) => Hero(
                                  tag:
                                      'FPM${mealController.favMeals[index].id}',
                                  child: FoodItem(
                                      mealController.favMeals[index], "FP"),
                                ),
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
