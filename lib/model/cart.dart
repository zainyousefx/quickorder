import 'package:get/get.dart';
import '/core/binding/local_preferences.dart';
import '/model/restaurant_model.dart';

class Cart {
  int? id;
  int restaurantId;
  int mealId;
  int num;
  String name;
  String restaurantName;
  String? image;
  String price;

  Cart(this.id, this.restaurantId, this.mealId, this.num, this.name,
      this.restaurantName, this.image, this.price);

  Cart.cart(this.restaurantId, this.mealId, this.num, this.name,
      this.restaurantName, this.price, this.image);

  factory Cart.fromJson(json) => Cart(
        json['id'],
        json['restaurant_id'],
        json['meal_id'],
        json['num'],
        json['name'],
        json['restaurantName'],
        json['description'] ?? "",
        json['image_url'] ??
            "https://t3.ftcdn.net/jpg/06/53/02/64/360_F_653026495_ZmK9aF4vLIbScED62p6BlzrluL0Q9IJo.jpg",
      );

  factory Cart.fromJsonCart(json) => Cart.cart(
        json['restaurant_id'],
        json['meal_id'],
        json['num'],
        json['name'],
        json['restaurantName'],
        json['price'],
        json['image'],
      );

  toJson() => {
        "id": id,
        "restaurant_id": restaurantId,
        "name": name,
        "image_url": image,
        "price": price,
      };

  static LocalPreferences localPreferences = Get.find();

  static toJsonCart(Cart cartItem) => {
        "user_id": localPreferences.getUser()!.value.id,
        "restaurant_id": cartItem.restaurantId,
        "name": cartItem.name,
        "meal_id": cartItem.mealId,
        "restaurantName": cartItem.restaurantName,
        "num": cartItem.num,
        "price": cartItem.price,
        "image": cartItem.image,
      };
}
