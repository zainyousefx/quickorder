import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/binding/local_preferences.dart';
import '/core/connection/dio_remote.dart';
import '/core/constants/constants.dart';
import '/model/user_model.dart';
import '/view/home/bottom_navigation.dart';

class LoginController extends GetxController {
  LocalPreferences localPreferences = Get.find();
  Rx<UserModel?> user = UserModel(-1, "", "", -1, "").obs;

  var email = TextEditingController();
  var password = TextEditingController();

  var loading = false.obs;
  var hasError = false.obs;
  var hidePassword = true.obs;

  login() async {
    try {
      loading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}login',
              data: UserModel.login(email.text, password.text).toLoginJson())
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(
          response.data["user"][0],
        );
        localPreferences.setUser(user);
        hasError(false);
        Get.offAll(() => BottomNavigation());
        return user;
      } else {
        debugPrint("error else $response");

        loading(false);
        hasError(true);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } on DioException catch (e) {
      debugPrint("DioException error catch ${e.response}");
      loading(false);
      hasError(true);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(e.response.toString()),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      debugPrint("error catch $e");
      loading(false);
      hasError(true);
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
