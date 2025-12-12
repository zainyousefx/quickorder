import 'package:get/get.dart';
import '/core/binding/local_preferences.dart';
import '/model/meal_model.dart';
import '/model/restaurant_model.dart';
import '/model/user_model.dart';

class Order {
  int? id;
  int restaurantId;
  int orderID;
  int num;
  int time;
  String status;
  String createdAt;
  String updatedAt;
  UserModel? user;
  RestaurantModel? restaurant;
  MealModel? meal;
  List<MealModel> meals;
  List<RestaurantModel> res;

  Order(this.id, this.restaurantId, this.orderID, this.num, this.time, this.status,
      this.createdAt, this.updatedAt, this.user, this.restaurant, this.meal, this.meals, this.res);

  setMeals(List<MealModel> meals)=> this.meals = meals;
  setRes(List<RestaurantModel> res)=> this.res = res;

  factory Order.fromJson(json) => Order(
    json['id'],
    json['restaurant_id'],
    json['orderID'],
    json['num'],
    json['time'] ?? 0,
    json['status'],
    json['created_at'],
    json['updated_at'],
    json['user'] != null ? UserModel.fromJson(json['user']) : null,
    json['restaurant'] != null ? RestaurantModel.fromJson(json['restaurant']) : null,
    json['meal'] != null ? MealModel.fromOrderJson(json['meal'], json['restaurant']) : null,
    [],
    [],
  );

  toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "orderID": orderID,
    "num": num,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user!.toJson(),
    "restaurant": restaurant!.toJson(),
    // "meal": meal!.toJson(),
  };

}
