import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/home/home_controller.dart';

import '../../controller/restaurant/restaurant_controller.dart';
import '../../core/constants/constants.dart';

class AddRestaurantSheet extends StatefulWidget {
  const AddRestaurantSheet({super.key});

  @override
  State<AddRestaurantSheet> createState() => _AddRestaurantSheetState();
}

class _AddRestaurantSheetState extends State<AddRestaurantSheet> {
  late Size size;
  RestaurantController restaurantController = Get.find();
  HomeController homeController = Get.find();
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      width: size.width / 4,
                      child: Divider(
                        thickness: 3,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Add Restaurant",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(()=>Stack(
                    children: [
                      ClipOval(
                        child: restaurantController
                                .selectedImage.value.path.isEmpty
                            ? Image.asset(
                                "assets/images/profile.png",
                                height: 100,
                              )
                            : Image.file(
                                File(
                                  restaurantController
                                      .selectedImage.value.path,
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
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                restaurantController.selectedImage(image);
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
                                iconSize: 20
                              ),
                              onPressed: () async {
                                restaurantController.selectedImage(XFile(""));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ))),
                    ],
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: restaurantController.name,
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
                            height: 10,
                          ),
                          TextFormField(
                            controller: restaurantController.description,
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
                            height: 10,
                          ),
                          TextFormField(
                            controller: restaurantController.location,
                            validator: (value) {
                              if (value!.trim().isEmpty)
                                return "Can't be empty";
                              return null;
                            },
                            decoration: InputDecoration(
                                hintText: "Location",
                                labelText: "Location",
                                contentPadding: const EdgeInsets.all(8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Obx(
                            () => TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: mainBTNColor),
                              onPressed: () {
                                if(restaurantController.selectedImage.value.path.isEmpty){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please pick an image!")));
                                }else
                                if (formKey.currentState!.validate()) {
                                  restaurantController.addRes();
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width / 4,
                                    right:
                                        MediaQuery.of(context).size.width / 4),
                                child: restaurantController.loading.value
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
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
