import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '/model/restaurant_model.dart';
import '/view/restaurant/view_restaurant.dart';

import '../../core/constants/constants.dart';

class RestaurantItem extends StatefulWidget {
  final RestaurantModel restaurantModel;

  const RestaurantItem(this.restaurantModel, {super.key});

  @override
  State<RestaurantItem> createState() => _RestaurantItemState();
}

class _RestaurantItemState extends State<RestaurantItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: ()=> Get.to(()=> ViewRestaurantPage(widget.restaurantModel)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.restaurantModel.image!,
                  width: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "assets/images/food.png",
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Text(
                widget.restaurantModel.name,
                style: TextStyle(
                    color: mainColor, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,color: mainLightColor,size: 16,),
                  SizedBox(width: 5,),
                  Text(
                    widget.restaurantModel.location,
                    style: TextStyle(
                        color: Colors.grey.shade700, fontSize: 12,),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
