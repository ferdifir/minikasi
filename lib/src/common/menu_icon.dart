import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class MenuIcon extends StatelessWidget {
  final String firstIcon;
  final String firstTitle;
  void Function()? firsOnTap;
  final GlobalKey<State<StatefulWidget>> firstKey;
  final String firstDescription;
  final String secondIcon;
  final String secondTitle;
  void Function()? secondOnTap;
  final double secondWidth;
  final GlobalKey<State<StatefulWidget>> secondKey;
  final String secondDescription;

  MenuIcon({
    Key? key,
    required this.firstIcon,
    required this.firstTitle,
    this.firsOnTap,
    required this.firstKey,
    required this.firstDescription,
    required this.secondIcon,
    required this.secondTitle,
    this.secondOnTap,
    this.secondWidth = 100,
    required this.secondKey,
    required this.secondDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Showcase(
          key: firstKey,
          description: firstDescription,
          child: InkWell(
            onTap: firsOnTap,
            child: Column(children: [
              SizedBox(
                width: 100,
                child: Image.asset(
                  firstIcon,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                firstTitle,
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
        ),
        Showcase(
          key: secondKey,
          description: secondDescription,
          child: InkWell(
            onTap: secondOnTap,
            child: Column(children: [
              SizedBox(
                width: secondWidth,
                child: Image.asset(
                  secondIcon,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                secondTitle,
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
