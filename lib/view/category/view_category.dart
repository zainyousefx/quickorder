import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controller/meal/meal_controller.dart';
import '/core/constants/constants.dart';
import '/view/widgets/add_category_sheet.dart';

class ViewCategory extends StatefulWidget {
  const ViewCategory({super.key});

  @override
  State<ViewCategory> createState() => _ViewCategoryState();
}

class _ViewCategoryState extends State<ViewCategory> {
  MealController mealController = Get.find();
  final scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    mealController.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: mainBTNColor),
                ),
                IconButton(onPressed: () => scaffoldState.currentState?.showBottomSheet(
                      (context) => AddCategorySheet(),
                  backgroundColor: Colors.transparent,
                ), icon: Icon(Icons.add))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  mealController.getCategories();
                },
                child: Obx(() => mealController.categoryLoading.value
                    ? itemsShimmer()
                    : mealController.categoryHasError.value
                        ? showError(mealController.categoryError.value)
                        : mealController.categories.isEmpty
                            ? showEmpty()
                            : ListView.builder(
                  itemCount: mealController.categories.length,
                                itemBuilder: (BuildContext context, int index) => Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ListTile(
                                      title: Text(mealController.categories[index].name),
                                    ),
                                  ),
                                ),
                              ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
