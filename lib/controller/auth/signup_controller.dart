import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/model/user_model.dart';
import '/view/home/bottom_navigation.dart';
import '../../core/binding/local_preferences.dart';
import '../../core/connection/dio_remote.dart';
import '../../core/constants/constants.dart';

class SignUpController extends GetxController {
  LocalPreferences localPreferences = Get.find();

  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var confirmPassword = TextEditingController();
  var type = 1.obs;

  var loading = false.obs;
  var hasError = false.obs;
  var hidePassword = true.obs;

  createAccount() async {
    try {
      loading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}register',
              data: UserModel.register(
                      name.text, email.text, type.value, password.text)
                  .toRegisterJson())
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
        loading(false);
        hasError(true);
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
          response.data["message"],
          maxLines: 3,
        )));
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
