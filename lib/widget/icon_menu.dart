import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  MenuIcon({
    Key? key,
    required this.firstIcon,
    required this.firstTitle,
    this.firsOnTap,
    required this.secondIcon,
    required this.secondTitle,
    this.secondOnTap,
  }) : super(key: key);

  final IconData firstIcon;
  final String firstTitle;
  void Function()? firsOnTap;
  final IconData secondIcon;
  final String secondTitle;
  void Function()? secondOnTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: firsOnTap,
          child: Column(children: [
            Icon(
              firstIcon,
              size: 100,
              color: Colors.blue,
            ),
            Text(
              firstTitle,
              style: const TextStyle(fontSize: 20),
            ),
          ]),
        ),
        InkWell(
          onTap: secondOnTap,
          child: Column(children: [
            Icon(
              secondIcon,
              size: 100,
              color: Colors.blue,
            ),
            Text(
              secondTitle,
              style: const TextStyle(fontSize: 20),
            ),
          ]),
        ),
      ],
    );
  }
}
