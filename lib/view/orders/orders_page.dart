import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/order/order_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/model/order.dart';
import '/view/orders/shopping_cart_page.dart';
import '/view/widgets/change_order_status_sheet.dart';
import '/view/widgets/rating_sheet.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  LocalPreferences localPreferences = Get.find();
  OrderController orderController = Get.find();
  RestaurantController restaurantController = Get.find();
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (localPreferences.getUser()!.value.type == 1) {
      restaurantController.getResByOwner();
    } else {
      orderController.getOrdersByUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text("Orders",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Visibility(
                visible: localPreferences.getUser()!.value.type == 2,
                child: IconButton(
                  onPressed: () => Get.to(() => ShoppingCartPage()),
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: mainColor,
                  ),
                ),
              )
            ],
          ),
          if (localPreferences.getUser()!.value.type == 1)
            Obx(() => restaurantController.resByOwnerLoading.value
                ? itemsShimmer()
                : restaurantController.resByOwnerHasError.value
                    ? showError(restaurantController.resByOwnerError.value)
                    : restaurantController.resByOwnerList.isEmpty
                        ? showEmpty()
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 80.0),
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  restaurantController.getResByOwner();
                                },
                                child: ListView.separated(
                                    itemBuilder: (context, index) =>
                                        resByOwnerItem(index),
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    itemCount: restaurantController
                                        .resByOwnerList.length),
                              ),
                            ),
                          )),
          if (localPreferences.getUser()!.value.type == 2)
            Obx(() => orderController.ordersByUserLoading.value
                ? itemsShimmer()
                : orderController.ordersByUserList.isEmpty
                    ? showEmpty()
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            orderController.getOrdersByUser();
                          },
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 75),
                              itemBuilder: (context, index) => orderWithMeals(
                                  orderController.ordersByUserList[index]),
                              itemCount:
                                  orderController.ordersByUserList.length),
                        ),
                      )),
        ],
      ),
    );
  }

  resByOwnerItem(int index) {
    return Obx(() => ExpansionTile(
          onExpansionChanged: (value) {
            debugPrint("value  $value");
            if (value) {
              orderController.getOrdersByRes(
                  restaurantController.resByOwnerList[index].id, index);
            }
          },
          tilePadding: const EdgeInsets.all(8.0),
          childrenPadding: const EdgeInsets.all(8.0),
          leading: PhysicalModel(
            color: Colors.transparent,
            shape: BoxShape.circle,
            elevation: 4,
            child: ClipOval(
              child: Image.network(
                restaurantController.resByOwnerList[index].image!,
                height: 50,
                width: 50,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s",
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ),
          title: Text(restaurantController.resByOwnerList[index].name),
          children: orderController.ordersByResLoading.value
              ? [itemsShimmer()]
              : restaurantController.resByOwnerList[index].resOrders!.isEmpty
                  ? []
                  : restaurantController.resByOwnerList[index].resOrders!
                      .map(
                        (item) => orderItem(item),
                      )
                      .toList(),
        ));
  }

  ListTile orderItem(Order item) {
    return ListTile(
      title: Text("Order #${item.orderID}", style: TextStyle(color: mainColor)),
      trailing: GestureDetector(
        onTap: () {
          if (item.status != "done" && item.status != "cancel") {
            scaffoldState.currentState?.showBottomSheet(
              (context) => ChangeOrderStatusSheet(
                status: item.status,
                orderId: item.orderID,
                order: item,
              ),
              backgroundColor: Colors.transparent,
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.status.toUpperCase(),
              style: TextStyle(
                  color: item.status == "pending"
                      ? Colors.deepOrange
                      : item.status == "in progress"
                          ? Colors.grey
                          : item.status == "ready"
                              ? Colors.amber
                              : item.status == "cancel"
                                  ? Colors.red
                                  : Colors.teal),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text("${item.meal!.name}  "),
              Text(
                "X${item.num} ",
                style: TextStyle(fontSize: 12, color: mainLightColor),
              ),
            ],
          ),
          Text("${int.parse(item.meal!.price) * item.num}",
              style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  orderWithMeals(Order item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ExpansionTile(
          onExpansionChanged: (value) {
            debugPrint("value  $value");
            if (item.status == "ready") {
              orderController.type(4);
              orderController.changeStatus(item, 1);
            }
          },
          tilePadding: const EdgeInsets.all(12.0),
          childrenPadding: const EdgeInsets.all(12.0),
          title: Text("Order #${item.orderID}",
              style: TextStyle(color: mainColor)),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("${item.meal!.name}  "),
                    Text(
                      "X${item.num} ",
                      style: TextStyle(fontSize: 12, color: mainLightColor),
                    ),
                  ],
                ),
                Text("${int.parse(item.meal!.price) * item.num}",
                    style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              if (item.status == "ready") {
                orderController.type(4);
                orderController.changeStatus(item, 1,
                    scaffoldState: scaffoldState);
              }
            },
            child: Column(
              children: [
                Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                      color: item.status == "pending"
                          ? Colors.deepOrange
                          : item.status == "in progress"
                              ? Colors.grey
                              : item.status == "ready"
                                  ? Colors.amber
                                  : item.status == "cancel"
                                      ? Colors.red
                                      : Colors.teal),
                ),
                SizedBox(
                  height: 10,
                ),
                if (item.status == "ready")
                  Text(
                    "Click if received",
                    style: TextStyle(color: mainBTNColor),
                  )
              ],
            ),
          ),
          children: item.meals
              .map(
                (item) => ListTile(
                  title: Text(item.name),
                  trailing:
                      Text(item.price, style: TextStyle(color: Colors.red)),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
