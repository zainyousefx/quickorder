import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/home/home_controller.dart';
import '/controller/meal/meal_controller.dart';
import '/model/category.dart';
import '/model/restaurant_model.dart';

import '../../controller/restaurant/restaurant_controller.dart';
import '../../core/constants/constants.dart';

class AddMealSheet extends StatefulWidget {
  const AddMealSheet({super.key});

  @override
  State<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends State<AddMealSheet> {
  late Size size;
  RestaurantController restaurantController = Get.find();
  MealController mealController = Get.find();
  HomeController homeController = Get.find();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    restaurantController.getResByOwner();
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      "Add Meal",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(() => Stack(
                          children: [
                            ClipOval(
                              child: mealController
                                      .selectedImage.value.path.isEmpty
                                  ? Image.asset(
                                      "assets/images/profile.png",
                                      height: 100,
                                    )
                                  : Image.file(
                                      File(
                                        mealController.selectedImage.value.path,
                                      ),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Positioned(
                                left: MediaQuery.of(context).size.width / 6.8,
                                top: MediaQuery.of(context).size.width / 7,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: mainColor,
                                    ),
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image =
                                          await picker.pickImage(
                                              source: ImageSource.gallery);
                                      mealController.selectedImage(image);
                                      // restaurantController
                                      //     .uploadImage(File(image!.path));
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ))),
                            Positioned(
                                left: MediaQuery.of(context).size.width / 6.8,
                                bottom: MediaQuery.of(context).size.width / 7,
                                child: IconButton(
                                    style: IconButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        iconSize: 20),
                                    onPressed: () async {
                                      mealController.selectedImage(XFile(""));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ))),
                          ],
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height /2,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              TextFormField(
                                controller: mealController.name,
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return "Can't be empty";
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Name",
                                    labelText: "Name",
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30))),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              TextFormField(
                                controller: mealController.description,
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return "Can't be empty";
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Description",
                                    labelText: "Description",
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30))),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              selectCategory(),
                              const SizedBox(
                                height: 14,
                              ),
                              selectRestaurant(),
                              const SizedBox(
                                height: 14,
                              ),
                              TextFormField(
                                controller: mealController.price,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.trim().isEmpty)
                                    return "Can't be empty";
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "Price",
                                    labelText: "Price",
                                    contentPadding: const EdgeInsets.all(8),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30))),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Obx(
                                () => TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: mainBTNColor),
                                  onPressed: () {
                                    if(mealController.selectedImage.value.path.isEmpty){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please pick an image!")));
                                    }else
                                    if (formKey.currentState!.validate()) {
                                      mealController.addMeal();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width / 4,
                                        right: MediaQuery.of(context).size.width /
                                            4),
                                    child: mealController.addLoading.value
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "ADD",
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                              )
                            ],
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

  selectCategory() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey)),
            child: DropdownButton<int>(
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.only(left: 4, right: 4),
              isExpanded: true,
              underline: Container(),
              value: mealController.selectedCategory.value.id == -1
                  ? null
                  : mealController.selectedCategory.value.id,
              items: mealController.categories.map((Category value) {
                return DropdownMenuItem<int>(
                  value: value.id,
                  child: Text(
                    value.name,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              hint: Text(
                "Select Category",
                style: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) => mealController.selectedCategory(
                  mealController.categories.singleWhere(
                      (element) => element.id == value,
                      orElse: () => Category(-1, ""))),
            ),
          ),
        ));
  }

  selectRestaurant() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey)),
            child: DropdownButton<int>(
              borderRadius: BorderRadius.circular(20),
              padding: EdgeInsets.only(left: 4, right: 4),
              isExpanded: true,
              underline: Container(),
              value: mealController.selectedRes.value.id == -1
                  ? null
                  : mealController.selectedRes.value.id,
              items: restaurantController.resByOwnerList
                  .map((RestaurantModel value) {
                return DropdownMenuItem<int>(
                  value: value.id,
                  child: Text(
                    value.name,
                    style: TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              hint: Text(
                "Select Restaurant",
                style: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) => mealController.selectedRes(
                  restaurantController.resByOwnerList.singleWhere(
                      (element) => element.id == value,
                      orElse: () =>
                          RestaurantModel(-1, "", "",0, "", "", null, "", ""))),
            ),
          ),
        ));
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
