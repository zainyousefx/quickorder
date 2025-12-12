
import '/model/cart.dart';
import '/model/order.dart';

import '../../model/user_model.dart';

abstract class LocalStorage{
  getUser();
  setUser(UserModel user);
  getCartItems();
  setCartItem(Cart cartItem);
  clearCart();
}