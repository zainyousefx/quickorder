import 'package:dio/dio.dart';
import '/model/order.dart';
import '/model/owner.dart';

class RestaurantModel {
  int? id;
  int? ownerId;
  String name;
  String location;
  String? description;
  OwnerModel? owner;
  String? image;
  double? rating;
  MultipartFile? imageFile;
  String? createdAt;
  String? updatedAt;
  List<Order>? resOrders = [];

  RestaurantModel(this.id, this.name, this.location, this.rating, this.description,
      this.image, this.owner, this.createdAt, this.updatedAt);

  RestaurantModel.fromMeal(this.id, this.name, this.location);

  RestaurantModel.add(this.name, this.description, this.location, this.ownerId,this.imageFile);

  setResOrders(resOrders)=> this.resOrders = resOrders;

  factory RestaurantModel.fromJson(json) => RestaurantModel(
      json['id'] ?? 0,
      json['name'],
      json['location'],
      json['rating'] != null ? double.parse(json['rating'].toString()) : 0.0,
      json['description'] ?? "",
      json['image'] != null ? json['image']["url"] : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlMyzfmXp2bWMGCMLw2JC4uXpXR1qEGTCBvw&s",
      json['owner'] != null
          ? OwnerModel.fromJson(json['owner'])
          : OwnerModel(-1, "name", "email"),
      json['created_at'] ?? "",
      json['updated_at'] ?? "");

  factory RestaurantModel.fromMealJson(json) =>
      RestaurantModel.fromMeal(json['id'] ?? 0, json['name'], json['location']);

  toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "description": description,
        if (ownerId != null) "owner_id": ownerId,
        if (image != null) "image_url": image,
        if (imageFile != null) "img": imageFile,
        if (owner != null) "owner": owner!.toJson(),
      };
}
