import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Color mainColor = const Color(0xFF006262);
Color mainLightColor = const Color(0x9B35B0B0);
Color mainBTNColor = const Color(0xFF0E7979);

String API = 'baseAPI';

itemsShimmer() {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 5.0, right: MediaQuery.of(Get.context!).size.width / 2),
            child: Card(
              child: SizedBox(
                width: 20,
                height: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Divider(),
          ),
          //-----
          Padding(
            padding: EdgeInsets.only(
                left: 5.0, right: MediaQuery.of(Get.context!).size.width / 2),
            child: Card(
              child: SizedBox(
                width: 20,
                height: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Divider(),
          ),
          //-----
          Padding(
            padding: EdgeInsets.only(
                left: 5.0, right: MediaQuery.of(Get.context!).size.width / 2),
            child: Card(
              child: SizedBox(
                width: 20,
                height: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Divider(),
          ),
          //-----
          Padding(
            padding: EdgeInsets.only(
                left: 5.0, right: MediaQuery.of(Get.context!).size.width / 2),
            child: Card(
              child: SizedBox(
                width: 20,
                height: 50,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0),
            child: Divider(),
          ),
          //-----
        ],
      ));
}

iconShimmer(){
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
     child: Padding(
       padding: const EdgeInsets.all(12.0),
       child: Icon(Icons.favorite_rounded),
     ),
  );
}

itemsShimmerHorizontal() {
  return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20,bottom: 20,left: 8,right: 8),
            child: ClipOval(child: Container(color: Colors.grey,height: 30,width: 150,)),
          ),
          //-----
          Padding(
            padding: EdgeInsets.only(top: 20,bottom: 20,left: 8,right: 8),
            child: ClipOval(child: Container(color: Colors.grey,height: 30,width: 150,)),
          ),
          //----
          Padding(
            padding: EdgeInsets.only(top: 20,bottom: 20,left: 8,right: 8),
            child: ClipOval(child: Container(color: Colors.grey,height: 30,width: 150,)),
          ),

        ],
      ));
}

showError(String value) {
  return Center(
    child: ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: Image.asset(
              "assets/images/error.png",
            ),
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Text(
              "Error ${value.contains("null") ? "Something went wrong" : value}",
              maxLines: 3,
              style: TextStyle(color: Colors.grey),
            )),
      ],
    ),
  );
}

showEmpty() {
  return Center(
    child: ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: AspectRatio(
            aspectRatio: 1.8,
            child: Image.asset(
              "assets/images/empty.png",
            ),
          ),
        ),
      ],
    ),
  );
}
