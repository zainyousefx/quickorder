import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/controller/order/order_controller.dart';
import '/core/constants/constants.dart';
import '/model/order.dart';

class ChangeOrderStatusSheet extends StatefulWidget {
  final String status;
  final int orderId;
  final Order order;

  const ChangeOrderStatusSheet(
      {super.key, required this.status, required this.orderId, required this.order});

  @override
  State<ChangeOrderStatusSheet> createState() => _ChangeOrderStatusSheetState();
}

class _ChangeOrderStatusSheetState extends State<ChangeOrderStatusSheet> {
  late Size size;

  HomeController homeController = Get.find();
  OrderController orderController = Get.find();

  @override
  void initState() {
    orderController.type(orderController.getTypeFromStatus(widget.status));
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Obx(() => Column(
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
                          "Change Status",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: 1,
                              groupValue: orderController.type.value,
                              onChanged: (int? value) {
                                orderController.type(value);
                              },
                            ),
                            Text(
                              'Pending      ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: 2,
                              groupValue: orderController.type.value,
                              onChanged: (int? value) {
                                orderController.type(value);
                              },
                            ),
                            Text(
                              'In Progress',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio(
                              value: 3,
                              groupValue: orderController.type.value,
                              onChanged: (int? value) {
                                orderController.type(value);
                              },
                            ),
                            Text(
                              'Ready         ',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: mainBTNColor),
                            onPressed: () {
                              if (orderController.type.value !=
                                  orderController
                                      .getTypeFromStatus(widget.status)) {
                                orderController.changeStatus(widget.order, 2);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            "Please don't choose same status")));
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4,
                                  right: MediaQuery.of(context).size.width / 4),
                              child: orderController.type.value != 5 && orderController.changeStatusLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "UPDATE",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.red,),
                            onPressed: () {
                              orderController.type(5);
                              orderController.changeStatus(widget.order, 5);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 4,
                                  right: MediaQuery.of(context).size.width / 4),
                              child: orderController.type.value == 5 && orderController.changeStatusLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "CANCEL",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
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
