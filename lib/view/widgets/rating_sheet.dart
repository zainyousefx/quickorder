import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/constants/constants.dart';
import '/model/restaurant_model.dart';

class RatingSheet extends StatefulWidget {
  final List<RestaurantModel> restaurants;

  const RatingSheet({super.key, required this.restaurants});

  @override
  State<RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<RatingSheet> {
  late Size size;

  HomeController homeController = Get.find();
  RestaurantController restaurantController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var ratings = [].obs;

  @override
  void initState() {
    widget.restaurants.map((e) => ratings.add(0.0)).toList();
    Future.delayed(Duration(milliseconds: 350), () {
      homeController.isSheetOpened(true);
      homeController.hideNav(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: size.width / 4,
                        child: Divider(
                          thickness: 3,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Rate",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: size.height / 4,
                      child: ListView.builder(
                        itemCount: widget.restaurants.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(widget.restaurants[index].name),
                          subtitle: Obx(() => StarRating(
                                rating: ratings[index].toDouble(),
                                onRatingChanged: (rating) {
                                  ratings[index] = rating;
                                  ratings.refresh();
                                },
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() => TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: mainBTNColor),
                          onPressed: () {
                            restaurantController.addRatingRes(
                              widget.restaurants,
                              ratings,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 4,
                                right: MediaQuery.of(context).size.width / 4),
                            child: restaurantController.ratingLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "RATE",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Future.delayed(Duration(microseconds: 100), () {
      homeController.isSheetOpened(false);
      homeController.hideNav(false);
    });
    super.dispose();
  }
}
