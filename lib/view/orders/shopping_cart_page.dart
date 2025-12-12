import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/order/order_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  LocalPreferences localPreferences = Get.find();
  OrderController orderController = Get.find();

  @override
  void initState() {
    orderController.getCartItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shopping Cart",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: mainBTNColor)),
                IconButton(
                    onPressed: () {
                      if (localPreferences.getCartItems()!.isNotEmpty) {
                        localPreferences.clearCart();
                        orderController.getCartItems();
                      } else {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                            const SnackBar(
                                content: Text("There's no items to delete")));
                      }
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ))
              ],
            ),
          ),
          Obx(() => Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) => SizedBox(
                          height: 130,
                          child: Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      orderController.cartItems[index].image!,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                orderController
                                                    .cartItems[index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                orderController
                                                    .cartItems[index].price,
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: Divider(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.restaurant_outlined,
                                            color: mainColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            orderController.cartItems[index]
                                                .restaurantName,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.numbers_outlined,
                                            color: mainColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            orderController.cartItems[index].num
                                                .toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: orderController.cartItems.length),
              ))
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton.extended(
            backgroundColor: mainLightColor,
            onPressed: () {
              if (localPreferences.getCartItems() != null && localPreferences.getCartItems()!.isNotEmpty) {
                orderController.addOrder();
              } else {
                ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Please add items to your cart first!")));
              }
            },
            label: orderController.addOrderLoading.value
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Text("Total  "),
                      Text("${orderController.total}",
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
            icon: orderController.addOrderLoading.value
                ? null
                : Icon(
                    Icons.send_outlined,
                  ),
          )),
    );
  }
}
