import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '/controller/home/home_controller.dart';
import '/controller/meal/meal_controller.dart';
import '/controller/restaurant/restaurant_controller.dart';
import '/core/constants/constants.dart';
import '/model/category.dart';
import '/view/widgets/add_meal_sheet.dart';
import '/view/widgets/add_restaurant_sheet.dart';
import '/view/widgets/restaurant_item.dart';

import '../../core/binding/local_preferences.dart';
import '../widgets/food_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeController = Get.find();
  MealController mealController = Get.find();
  RestaurantController restaurantController = Get.find();
  LocalPreferences localPreferences = Get.find();
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    homeController.getMeals();
    homeController.getRestaurants();
    mealController.getCategories();
    if(localPreferences.getUser()!.value.type == 1) restaurantController.getResByOwner();
    homeController.scrollController(ScrollController());
    homeController.scrollController.value.addListener(() {
      if (homeController.scrollController.value.positions.isNotEmpty) {
        if(homeController.scrollController.value.position
            .userScrollDirection ==
            ScrollDirection.reverse) {
          homeController.hideNav(true);
          homeController.hideNav.refresh();
        } else {
          homeController.hideNav(false);
          homeController.hideNav.refresh();
        }
        debugPrint(
            " test ${homeController.scrollController.value.position.userScrollDirection}");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("${localPreferences.getUser()!.value.type}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldState,
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: RefreshIndicator(
          onRefresh: () async{
            homeController.getMeals();
            homeController.getRestaurants();
            mealController.getCategories();
          },
          child: SingleChildScrollView(
            controller: homeController.scrollController.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => debugPrint("homeController.hideNav.value ${homeController.hideNav.value}"),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Food App',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: mainBTNColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                restaurants(),
                dishes()
              ],
            ),
          ),
        ),
      ),
    );
  }

  restaurants() {
    return Obx(() => SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Restaurants',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: localPreferences.getUser()!.value.type == 1,
                      child: IconButton(
                        onPressed: () =>
                            scaffoldState.currentState?.showBottomSheet(
                          (context) => AddRestaurantSheet(),
                          backgroundColor: Colors.transparent,
                        ),
                        icon: Icon(
                          Icons.add,
                          color: mainColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 200,
                child: homeController.restaurantLoading.value
                    ? itemsShimmerHorizontal()
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Hero(
                          tag: "HPR${homeController.restaurantList[index].id}",
                          child: RestaurantItem(
                              homeController.restaurantList[index]),
                        ),
                        itemCount: homeController.restaurantList.length,
                      ),
              ),
            ],
          ),
        ));
  }

  dishes() {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Main Dishes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Obx(() => Visibility(
                      visible: localPreferences.getUser()!.value.type == 1,
                      child: IconButton(
                        onPressed: () =>
                            scaffoldState.currentState?.showBottomSheet(
                          (context) => AddMealSheet(),
                          backgroundColor: Colors.transparent,
                        ),
                        icon: Icon(
                          Icons.add,
                          color: mainColor,
                        ),
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: mealController.categories.length,
                  itemBuilder: (context, index) => Obx(() => GestureDetector(
                        onTap: () {
                          if (mealController.selectedCategoryFilter.value.id ==
                              mealController.categories[index].id) {
                            mealController
                                .selectedCategoryFilter(Category(-1, ""));
                            homeController.getMeals();
                          } else {
                            mealController.selectedCategoryFilter(
                                mealController.categories[index]);
                            homeController.getMealsByCategory();
                          }
                        },
                        child: Card(
                          color:
                              mealController.selectedCategoryFilter.value.id ==
                                      mealController.categories[index].id
                                  ? mainColor
                                  : null,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0,right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if(mealController.selectedCategoryFilter.value.id ==
                                      mealController.categories[index].id)
                                    Icon(Icons.done,color: Colors.white,size: 16),
                                  Text(
                                    mealController.categories[index].name,
                                    style: TextStyle(
                                        color: mealController.selectedCategoryFilter
                                                    .value.id ==
                                                mealController.categories[index].id
                                            ? Colors.white
                                            : null),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ),
            homeController.mealsLoading.value
                ? itemsShimmer()
                : homeController.mealsHasError.value
                    ? showError(homeController.mealsError.value)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemCount: homeController.meals.length,
                        itemBuilder: (context, index) => Hero(
                          tag: 'HPM${homeController.meals[index].id}',
                          child: FoodItem(homeController.meals[index], "HP"),
                        ),
                      ),
          ],
        ));
  }

  @override
  void dispose() {
    homeController.scrollController.value.dispose();
    super.dispose();
  }
}
