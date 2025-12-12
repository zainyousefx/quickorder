import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/core/binding/local_preferences.dart';
import '/core/constants/constants.dart';
import '/view/category/view_category.dart';
import '/view/favovorites/favorites_page.dart';
import '/view/home/home_page.dart';
import '/view/orders/orders_page.dart';
import '/view/profile/profile_page.dart';
import '/view/search/search.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  HomeController homeController = Get.find();
  LocalPreferences localPreferences = Get.find();

  var pages = [
    HomePage(),
    OrdersPage(),
    ProfilePage(),
  ];
  var pageIndex = 0.obs;

  @override
  void initState() {
    if (localPreferences.getUser()!.value.type == 1) {
      pages = [
        HomePage(),
        ViewCategory(),
        OrdersPage(),
        ProfilePage(),
      ];
    } else {
      pages = [
        HomePage(),
        OrdersPage(),
        Search(),
        FavoritesPage(),
        ProfilePage(),
      ];
    }
    debugPrint("homeController  $homeController");
    homeController.scrollController.value.addListener(() {
      debugPrint(
          "testsss   ${homeController.scrollController.value.positions}");
      if (homeController.scrollController.value.positions.isNotEmpty) {
        debugPrint(
            " test ${homeController.scrollController.value.position.userScrollDirection}");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          pages[pageIndex.value],
          Obx(() => Visibility(
                visible: !homeController.hideNav.value,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: localPreferences.getUser()!.value.type == 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                navItem("Home", Icons.home_outlined, 0),
                                navItem("Category", Icons.category_rounded, 1),
                                navItem("Order", Icons.list_outlined, 2),
                                navItem("Profile", Icons.person_outline, 3),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                navItem("Home", Icons.home_outlined, 0),
                                navItem("Order", Icons.list_outlined, 1),
                                navItem("Search", Icons.search_rounded, 2),
                                navItem("Favorites", Icons.favorite_rounded, 3),
                                navItem("Profile", Icons.person_outline, 4),
                              ],
                            ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  navItem(text, icon, index) {
    return GestureDetector(
      onTap: () => pageIndex(index),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: pageIndex.value == index ? mainColor : Colors.grey,
            ),
            if (pageIndex.value == index)
              Text(
                text,
                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
