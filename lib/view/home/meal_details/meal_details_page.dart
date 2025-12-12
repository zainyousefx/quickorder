import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/controller/order/order_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/model/cart.dart';
import '/model/meal_model.dart';
import '/model/restaurant_model.dart';
import '/view/widgets/delete_confirmation_sheet.dart';

class MealDetailsPage extends StatefulWidget {
  final MealModel meal;
  final String source;

  const MealDetailsPage(this.meal, this.source, {super.key});

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  late MealModel meal;
  var itemCount = 0.obs;
  var loading = false.obs;
  OrderController orderController = Get.find();
  MealController mealController = Get.find();
  LocalPreferences localPreferences = Get.find();
  RestaurantController restaurantController = Get.find();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    meal = widget.meal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("${widget.source}M${meal.id}");

    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldState,
      body: Center(
        child: Container(
          color: mainLightColor,
          width: size.width,
          child: Column(
            children: [
              Hero(
                tag: "${widget.source}M${meal.id}",
                child: Container(
                  height: size.height / 4,
                  width: size.width / 1.5,
                  margin: EdgeInsets.only(top: size.height / 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network(meal.image).image,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Text(
                meal.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.restaurant,
                    color: Colors.white70,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    meal.restaurantModel!.name ?? "",
                    style: TextStyle(color: mainColor, fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "\$ ${meal.price ?? ""}",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height / 30,
              ),
              Expanded(
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    width: size.width,
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(fontSize: 22),
                                ),
                                Visibility(
                                  visible: restaurantController.resByOwnerList
                                          .singleWhere(
                                            (element) =>
                                                element.id ==
                                                meal.restaurantModel!.id,
                                            orElse: () =>
                                                RestaurantModel.fromMeal(
                                                    -1, "", ""),
                                          )
                                          .id !=
                                      -1,
                                  child: IconButton(
                                    onPressed: () => scaffoldState.currentState
                                        ?.showBottomSheet(
                                      (context) => DeleteConfirmationSheet(
                                        mealId: meal.id,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(meal.description)),
                            ),
                          ],
                        ),
                        //--------------
                        Visibility(
                          visible: localPreferences.getUser()!.value.type == 2,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () =>
                                          itemCount(itemCount.value + 1),
                                      style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                              color: Colors.teal)),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.teal,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Obx(() => Text("${itemCount.value}")),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    OutlinedButton(
                                        onPressed: () {
                                          if (itemCount.value > 0) {
                                            itemCount(itemCount.value - 1);
                                          }
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loading.value
                                    ? const SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 1),
                                      )
                                    : TextButton(
                                        onPressed: () async {
                                          if (itemCount.value > 0) {
                                            loading(true);

                                            var added = await localPreferences
                                                .setCartItem(Cart.cart(
                                                    meal.restaurantId,
                                                    meal.id,
                                                    itemCount.value,
                                                    meal.name,
                                                    meal.restaurantModel!.name,
                                                    meal.price,
                                                    meal.image));
                                            if (added) {
                                              itemCount(0);
                                              ScaffoldMessenger.of(Get.context!)
                                                  .showSnackBar(const SnackBar(
                                                      backgroundColor:
                                                          Colors.teal,
                                                      content: Text(
                                                          "Added to cart successfully!")));
                                            } else {
                                              showError(
                                                  "Something went wrong!");
                                            }
                                            loading(false);
                                          } else {
                                            ScaffoldMessenger.of(Get.context!)
                                                .showSnackBar(const SnackBar(
                                                    backgroundColor: Colors.red,
                                                    content: Text(
                                                        "Please Select number of item you want to order!")));
                                          }
                                        },
                                        child: const Text(
                                          "Add to cart",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: TextButton.styleFrom(
                                            backgroundColor: mainColor,
                                            fixedSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                30)),
                                      ),
                              ),
                            ],
                          ),
                        )
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
