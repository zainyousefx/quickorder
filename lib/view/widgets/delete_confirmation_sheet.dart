import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/controller/meal/meal_controller.dart';
import '/core/constants/constants.dart';

class DeleteConfirmationSheet extends StatefulWidget {
  final int mealId;
  const DeleteConfirmationSheet({super.key,required this.mealId});

  @override
  State<DeleteConfirmationSheet> createState() =>
      _DeleteConfirmationSheetState();
}

class _DeleteConfirmationSheetState extends State<DeleteConfirmationSheet> {
  late Size size;

  HomeController homeController = Get.find();
  MealController mealController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
                      "Confirmation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Are you sure you want to delete this item?",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: ()=>  mealController.deleteMeal(widget.mealId),
                            child: mealController.deleteMealLoading.value
                                ? const CircularProgressIndicator(
                                    strokeWidth: 2,
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
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
    mealController.clear();
    super.dispose();
  }
}
