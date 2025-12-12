import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/controller/meal/meal_controller.dart';
import '/core/constants/constants.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
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
                          "Add Category",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            controller: mealController.category,
                            validator: (value) {
                              if (value!.trim().isEmpty)
                                return "Can't be empty";
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Category",
                                labelText: "Category",
                                contentPadding: const EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: mainBTNColor),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                mealController.addCategory();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4,
                                  right: MediaQuery.of(context).size.width / 4),
                              child: mealController.addCategoryLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
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
