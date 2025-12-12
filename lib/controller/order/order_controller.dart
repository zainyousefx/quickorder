import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/connection/dio_remote.dart';
import '/core/constants/constants.dart';
import '/model/cart.dart';
import '/model/meal_model.dart';
import '/model/restaurant_model.dart';
import '../../model/order.dart';
import '../../view/widgets/rating_sheet.dart';

class OrderController extends GetxController {
  var itemCount = 0.obs;
  var total = 0.obs;
  var type = 0.obs;

  var isOpen = false;

  var cartItems = <Cart>[].obs;
  var ordersByResList = <List<Order>>[].obs;
  var ordersByUserList = <Order>[].obs;

  var addOrderLoading = false.obs;
  var addOrderHasError = false.obs;
  var addOrderError = "".obs;

  var ordersByResLoading = false.obs;
  var ordersByResHasError = false.obs;
  var ordersByResError = "".obs;

  var ordersByUserLoading = false.obs;
  var ordersByUserHasError = false.obs;
  var ordersByUserError = "".obs;

  var changeStatusLoading = false.obs;
  var changeStatusHasError = false.obs;
  var changeStatusError = "".obs;

  LocalPreferences localPreferences = Get.find();
  RestaurantController restaurantController = Get.find();

  getTypeFromStatus(String status) {
    switch (status) {
      case "pending":
        return 1;
      case "in progress":
        return 2;
      case "ready":
        return 3;
      case "done":
        return 4;
      case "cancel":
        return 5;
      default:
        return 0;
    }
  }

  getStatusFromType(int type) {
    switch (type) {
      case 1:
        return "pending";
      case 2:
        return "in progress";
      case 3:
        return "ready";
      case 4:
        return "done";
      case 5:
        return "cancel";
      default:
        return "";
    }
  }

  getCartItems() {
    total(0);
    cartItems([]);
    cartItems(localPreferences.getCartItems());
    for (var item in cartItems) {
      debugPrint("item.price ${item.price}   item.num  ${item.num}");
      total(total.value + (int.parse(item.price) * item.num));
    }
  }

  addOrder() async {
    try {
      addOrderLoading(true);

      final response =
          await DioSingleton().dioInstance.post('${API}order', data: {
        "order": localPreferences
            .getCartItems()!
            .map<Map<String, dynamic>>((item) => Cart.toJsonCart(item))
            .toList()
      });

      if (response.statusCode == 200) {
        debugPrint("response  $response");
        Get.back();
        localPreferences.clearCart();
        addOrderHasError(false);
        addOrderLoading(false);
      } else {
        debugPrint("error else $response");

        addOrderLoading(false);
        addOrderHasError(true);
        addOrderError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      addOrderLoading(false);
      addOrderHasError(true);
      addOrderError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getOrdersByRes(restaurantId, int index) async {
    try {
      ordersByResLoading(true);
      debugPrint("restaurant_id  $restaurantId,");

      final response = await DioSingleton()
          .dioInstance
          .get('${API}show_orders_by_restaurant_id', data: {
        "restaurant_id": restaurantId,
      });
      if (response.statusCode == 200) {
        var orderList = <Order>[];
        for (var order in response.data["response"]) {
          orderList.add(Order.fromJson(order));
        }
        restaurantController.resByOwnerList[index].setResOrders(orderList);
        ordersByResHasError(false);
        ordersByResLoading(false);
      } else {
        debugPrint("error else $response");

        ordersByResLoading(false);
        ordersByResHasError(true);
        ordersByResError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      ordersByResLoading(false);
      ordersByResHasError(true);
      ordersByResError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getOrdersByUser() async {
    try {
      ordersByUserLoading(true);

      final response = await DioSingleton()
          .dioInstance
          .get('${API}show_orders_by_user_id', data: {
        "user_id": localPreferences.getUser()!.value.id,
      });
      if (response.statusCode == 200) {
        debugPrint("response $response");
        var orderList = <Order>[];
        var mealsList = <MealModel>[];
        var resList = <RestaurantModel>[];
        var lastOrderId = -1;
        for (int i = 0; i < response.data["response"].length; i++) {
          var order = Order.fromJson(response.data["response"][i]);
          if (lastOrderId == -1) {
            lastOrderId = order.orderID;
            mealsList.add(order.meal!);
            resList.add(order.restaurant!);
            order.setMeals(mealsList);
            orderList.add(order);
            continue;
          }
          if (lastOrderId == order.orderID) {
            mealsList.add(order.meal!);
            var existRes = resList.singleWhere(
                (element) => element.id == order.restaurant!.id,
                orElse: () => RestaurantModel.fromMeal(-1, "", ""));
            if (existRes.id == -1) resList.add(order.restaurant!);
            orderList.last.setMeals(mealsList);
            orderList.last.setRes(resList);
            continue;
          }
          if (lastOrderId != order.orderID) {
            mealsList = [];
            resList = [];
            lastOrderId = order.orderID;
            mealsList.add(order.meal!);
            resList.add(order.restaurant!);
            order.setMeals(mealsList);
            order.setRes(resList);
            orderList.add(order);
            continue;
          }
        }
        ordersByUserList(orderList);
        ordersByUserHasError(false);
        ordersByUserLoading(false);
      } else {
        debugPrint("error else $response");

        ordersByUserLoading(false);
        ordersByUserHasError(true);
        ordersByUserError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      ordersByUserLoading(false);
      ordersByUserHasError(true);
      ordersByUserError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  changeStatus(Order order, source, {scaffoldState}) async {
    //source 1 customer - 2 res owner
    try {
      changeStatusLoading(true);

      final response = await DioSingleton()
          .dioInstance
          .post('${API}change-status', data: {
        "new_status": getStatusFromType(type.value),
        "orderID": order.orderID
      });
      if (response.statusCode == 200) {
        debugPrint("response $response  ");
        changeStatusHasError(false);
        changeStatusLoading(false);
        type(0);

        if (source == 1) {
          if (scaffoldState != null) {
            scaffoldState.currentState!.showBottomSheet(
              (context) => RatingSheet(restaurants: order.res),
              backgroundColor: Colors.transparent,
            );
          }
          getOrdersByUser();
        } else {
          Get.back();
          restaurantController.getResByOwner();
        }
      } else {
        debugPrint("error else $response");

        changeStatusLoading(false);
        changeStatusHasError(true);
        changeStatusError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      changeStatusLoading(false);
      changeStatusHasError(true);
      changeStatusError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
