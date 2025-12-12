import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/controller/home/home_controller.dart';
import '/core/binding/local_preferences.dart';
import '/model/restaurant_model.dart';
import '../../core/connection/dio_remote.dart';
import '../../core/constants/constants.dart';

class RestaurantController extends GetxController {
  LocalPreferences localPreferences = Get.find();
  HomeController homeController = Get.find();

  var resByOwnerList = <RestaurantModel>[].obs;
  var resSearchList = <RestaurantModel>[].obs;

  var name = TextEditingController();
  var description = TextEditingController();
  var location = TextEditingController();
  var selectedImage = XFile("").obs;

  var loading = false.obs;
  var addResHasError = false.obs;
  var addResError = "".obs;

  var resByOwnerLoading = false.obs;
  var resByOwnerHasError = false.obs;
  var resByOwnerError = "".obs;

  var ratingLoading = false.obs;
  var ratingHasError = false.obs;
  var ratingError = "".obs;

  var resSearchLoading = false.obs;
  var resSearchHasError = false.obs;
  var resSearchError = "".obs;

  var image = "".obs;

  addRes() async {
    try {
      loading(true);
      final response =
          await DioSingleton().dioInstance.post('${API}add_restaurant',
              data: dio.FormData.fromMap({
                "name": name.text,
                "location": location.text,
                "description": description.text,
                "owner_id": localPreferences.getUser()!.value.id,
                if (selectedImage.value.path.isNotEmpty)
                  "img": await dio.MultipartFile.fromFile(
                      selectedImage.value.path,
                      filename: selectedImage.value.name),
              }));

      if (response.statusCode == 200) {
        selectedImage(XFile(""));
        addResHasError(false);
        loading(false);
        Get.back();
        homeController.getRestaurants();
      } else {
        debugPrint("error else $response");

        loading(false);
        addResHasError(true);
        addResError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      loading(false);
      addResHasError(true);
      addResError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  getResByOwner() async {
    try {
      resByOwnerLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .get('${API}show_restaurant_by_ownerId', data: {
        "owner_id": localPreferences.getUser()!.value.id,
      });

      if (response.statusCode == 200) {
        debugPrint("response $response");
        var resList = <RestaurantModel>[];
        for (var restaurant in response.data["response"]) {
          resList.add(RestaurantModel.fromJson(restaurant));
        }
        resByOwnerList(resList);
        resByOwnerHasError(false);
        resByOwnerLoading(false);
      } else {
        debugPrint("error else $response");

        resByOwnerLoading(false);
        resByOwnerHasError(true);
        resByOwnerError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      resByOwnerLoading(false);
      resByOwnerHasError(true);
      resByOwnerError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  searchRes(String text) async {
    try {
      resSearchLoading(true);
      final response = await DioSingleton()
          .dioInstance
          .post('${API}restaurant_search', data: {
        "restaurant_name": text,
      });

      if (response.statusCode == 200) {
        debugPrint("response $response");
        var resList = <RestaurantModel>[];
        for (var restaurant in response.data["response"]) {
          resList.add(RestaurantModel.fromJson(restaurant));
        }
        resSearchList(resList);
        resSearchHasError(false);
        resSearchLoading(false);
      } else {
        debugPrint("error else $response");

        resSearchLoading(false);
        resSearchHasError(true);
        resSearchError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      resSearchLoading(false);
      resSearchHasError(true);
      resSearchError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  addRatingRes(List<RestaurantModel> restaurants, ratings) async {
    try {
      ratingLoading(true);
      final response =
          await DioSingleton().dioInstance.post('${API}rating', data: {
        "rating": restaurants
            .map((item) => {
                  "restaurant_id": item.id,
                  "rating": ratings[restaurants.indexOf(item)],
                })
            .toList()
      });

      if (response.statusCode == 200) {
        debugPrint("response $response");
        ratingHasError(false);
        ratingLoading(false);
        Get.back();
      } else {
        debugPrint("error else $response");

        ratingLoading(false);
        ratingHasError(true);
        ratingError(response.data["message"]);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text(response.data["message"])));
      }
    } catch (e) {
      debugPrint("error catch $e");
      loading(false);
      addResHasError(true);
      addResError(e.toString());

      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
