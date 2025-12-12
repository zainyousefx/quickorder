import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user_model.dart';
import 'local_storage.dart';

class LocalPreferences extends LocalStorage {
  SharedPreferences instance;

  LocalPreferences(this.instance);

  @override
  Rx<UserModel>? getUser() {
    try {
      String? userStr = instance.getString("user");
      debugPrint("Saved user $userStr");
      var user =
          userStr == null ? null : UserModel.fromJson(json.decode(userStr));

      return user!.obs;
    } catch (e, t) {
      debugPrint('Fetch local user $e');
      return null;
    }
  }

  @override
  setUser(UserModel? user) async {
    if (user == null) {
      instance.remove("user");
      clearCart();
    } else {
      if (await instance.setString("user", json.encode(user.toJson()))) {
        debugPrint("saved");
      } else {
        debugPrint("not saved");
      }
    }
  }

  @override
  List<Cart>? getCartItems() {
    try {
      String? cartItems = instance.getString("CartItems");
      if (cartItems != null) {
        debugPrint("Saved cartItems $cartItems");

        return (json.decode(cartItems) as List<dynamic>)
            .map<Cart>((item) => Cart.fromJsonCart(item))
            .toList();
      }
      return [];
    } catch (e, t) {
      debugPrint('Fetch local user $e');
      return [];
    }
  }

  @override
  setCartItem(Cart cartItem) async {
    List<Cart>? cartItems = getCartItems();
    cartItems ??= [];
    cartItems.add(cartItem);
    if (await instance.setString(
        "CartItems",
        json.encode(
          cartItems
              .map<Map<String, dynamic>>(
                  (cartItem) => Cart.toJsonCart(cartItem))
              .toList(),
        ))) {
      debugPrint("saved");
      return true;
    } else {
      debugPrint("not saved");
      return false;
    }
  }

  @override
  clearCart() => instance.remove("CartItems");
}
