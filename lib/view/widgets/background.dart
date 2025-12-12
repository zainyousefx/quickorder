import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  final Widget widget;

  const BackGround({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/food.png"),
                fit: BoxFit.cover,
                alignment: Alignment.center),
          ),
        ),
        widget
      ],
    );
  }
}
