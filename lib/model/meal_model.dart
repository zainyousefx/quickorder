import '/model/category.dart';
import '/model/restaurant_model.dart';

class MealModel {
  int id;
  int restaurantId;
  String name;
  String description;
  String image;
  String price;
  bool? favourite;
  Category? category;
  RestaurantModel? restaurantModel;

  MealModel(this.id, this.restaurantId, this.name, this.description, this.image,
      this.price, this.restaurantModel, this.category, this.favourite);

  MealModel.fromRestaurant(this.id, this.restaurantId, this.name,
      this.description, this.image, this.price);

  factory MealModel.fromJson(json) => MealModel(
      json['id'],
      json['restaurant_id'],
      json['name'],
      json['description'] ?? "",
      json['image'] != null
          ? (json['image']["url"] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s")
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s",
      json['price'],
      RestaurantModel.fromJson(json['restaurant']),
      json['category'] != null ? Category.fromJson(json['category']) : null,
      json['favourite'] ?? false
  );

  factory MealModel.fromOrderJson(json,restaurant) => MealModel(
      json['id'],
      restaurant != null ? RestaurantModel.fromJson(restaurant).id! : -1,
      json['name'],
      json['description'] ?? "",
      json['image'] != null
          ? (json['image']["url"] ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s")
          : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s",
      json['price'],
      restaurant != null ? RestaurantModel.fromJson(restaurant) : null,
      json['category'] != null ? Category.fromJson(json['category']) : null,
      json['favourite'] ?? false
  );


  factory MealModel.fromJsonRes(json) => MealModel.fromRestaurant(
      json['id'],
      json['restaurant_id'],
      json['name'],
      json['description'] ?? "",
      json['image_url'] ??
          "https://t3.ftcdn.net/jpg/06/53/02/64/360_F_653026495_ZmK9aF4vLIbScED62p6BlzrluL0Q9IJo.jpg",
      json['price']);

  factory MealModel.fromJsonFav(json) => MealModel(
      json['meal']['id'],
      -1,
      json['meal']['name'],
      json['meal']['description'] ?? "",
      json['image']['url'] ??
          "https://t3.ftcdn.net/jpg/06/53/02/64/360_F_653026495_ZmK9aF4vLIbScED62p6BlzrluL0Q9IJo.jpg",
      json['meal']['price'],
      json['restaurant'] != null ? RestaurantModel.fromMealJson(json['restaurant']) : null,
      json['category'] != null ? Category.fromJson(json['category']) : null,
      true
  );

  toJson() => {
        "id": id,
        "restaurant_id": restaurantId,
        "name": name,
        "description": description,
        "image_url": image,
        "price": price,
        if (restaurantModel != null) "restaurant": restaurantModel!.toJson(),
      };
}
