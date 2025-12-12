import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/constants/constants.dart';
import '/view/widgets/food_item.dart';
import '/view/widgets/restaurant_item.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  RestaurantController restaurantController = Get.find();
  MealController mealController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var type = 1.obs;
  var search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainBTNColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    controller: search,
                    validator: (value) {
                      if (value!.trim().isEmpty) return "Can't be empty";
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: "Search",
                        labelText: "Search",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search_rounded),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (type.value == 1) {
                                restaurantController.searchRes(search.text);
                              } else {
                                mealController.searchMeal(search.text);
                              }
                            }
                          },
                        ),
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('By Restaurant ',
                          style: TextStyle(
                            color: mainBTNColor,
                            fontSize: 14,
                          )),
                      Radio(
                        value: 1,
                        groupValue: type.value,
                        onChanged: (int? value) => type(value),
                      ),
                      Text(
                        'By Meal',
                        style: TextStyle(
                          color: mainBTNColor,
                          fontSize: 14,
                        ),
                      ),
                      Radio(
                        value: 2,
                        groupValue: type.value,
                        onChanged: (int? value) => type(value),
                      ),
                    ],
                  ),
                ),
                if (type.value == 1) resResult(),
                if (type.value == 2) mealResult(),
              ],
            )),
      ),
    );
  }

  mealResult() {
    return Expanded(
      child: (Obx(() => mealController.searchMealsLoading.value
          ? itemsShimmer()
          : mealController.searchMealsHasError.value
              ? showError(mealController.searchMealsError.value)
              : mealController.searchMealsList.isEmpty
                  ? showEmpty()
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 75),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: mealController.searchMealsList.length,
                      itemBuilder: (context, index) => Hero(
                        tag: 'SPM${mealController.searchMealsList[index].id}',
                        child: FoodItem(
                            mealController.searchMealsList[index], "SP"),
                      ),
                    ))),
    );
  }

  resResult() {
    return Expanded(
      child: (Obx(() => restaurantController.resSearchLoading.value
          ? itemsShimmer()
          : restaurantController.resSearchHasError.value
              ? showError(restaurantController.resSearchError.value)
              : restaurantController.resSearchList.isEmpty
                  ? showEmpty()
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: restaurantController.resSearchList.length,
                      itemBuilder: (context, index) => Hero(
                        tag:
                            "HPR${restaurantController.resSearchList[index].id}",
                        child: RestaurantItem(
                            restaurantController.resSearchList[index]),
                      ),
                    ))),
    );
  }
}
