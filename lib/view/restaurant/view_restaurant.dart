import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/model/restaurant_model.dart';
import '/view/widgets/food_item.dart';

import '../../core/constants/constants.dart';

class ViewRestaurantPage extends StatefulWidget {
  RestaurantModel restaurantModel;

  ViewRestaurantPage(this.restaurantModel, {super.key});

  @override
  State<ViewRestaurantPage> createState() => _ViewRestaurantPageState();
}

class _ViewRestaurantPageState extends State<ViewRestaurantPage> {
  late RestaurantModel restaurantModel;
  MealController mealController = Get.find();
  RestaurantController restaurantController = Get.find();

  @override
  void initState() {
    restaurantModel = widget.restaurantModel;
    mealController.getMealsByRes(restaurantModel.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          color: mainLightColor,
          width: size.width,
          child: Column(
            children: [
              Hero(
                tag: 'HPR${restaurantModel.id}',
                child: Container(
                  height: size.height / 4,
                  width: size.width / 1.9,
                  margin: EdgeInsets.only(top: size.height / 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network(restaurantModel.image!).image,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Text(
                restaurantModel.name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.restaurant, color: mainColor),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      restaurantModel.description ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Icon(Icons.location_on_outlined, color: mainColor),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      restaurantModel.location ?? "",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              StarRating(
                rating: restaurantModel.rating!.toDouble(),
                onRatingChanged: (rating) {},
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Expanded(
                child: Obx(
                  () => Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 16),
                          child: Text(
                            "Dishes",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                            child: mealController.mealsLoading.value
                                ? itemsShimmer()
                                : GridView.builder(
                                    itemCount: mealController.meals.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) =>
                                            FoodItem(
                                                mealController.meals[index],
                                                "VRes"),
                                  ))
                      ],
                    ),
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
