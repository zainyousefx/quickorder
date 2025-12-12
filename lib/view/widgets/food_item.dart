import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/model/meal_model.dart';
import '/view/home/meal_details/meal_details_page.dart';

class FoodItem extends StatefulWidget {
  final MealModel meal;
  final String source;

  const FoodItem(this.meal, this.source, {super.key});

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  MealController mealController = Get.find();
  LocalPreferences localPreferences = Get.find();

  @override
  Widget build(BuildContext context) {
    debugPrint("${widget.source}M${widget.meal.id}");
    return GestureDetector(
      onTap: () => Get.to(MealDetailsPage(widget.meal, widget.source)),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: NetworkImage(widget.meal.image),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  debugPrint("NetworkImage exception $exception");
                },
                alignment: Alignment.center),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 50,
              width: 200,
              child: Card(
                color: mainLightColor,
                margin: EdgeInsets.zero,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.meal.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.meal.category!.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: localPreferences.getUser()!.value.type == 2,
                        child: Obx(
                          () => mealController.addToFavMealId.value ==
                                  widget.meal.id
                              ? iconShimmer()
                              : IconButton(
                                  onPressed: () {
                                    if (!widget.meal.favourite!) {
                                      mealController
                                          .addMealToFav(widget.meal.id);
                                    } else {
                                      mealController
                                          .removeMealFromFav(widget.meal.id,source: widget.source);
                                    }
                                  },
                                  icon: Icon(
                                    widget.meal.favourite!
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: Colors.white70,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
