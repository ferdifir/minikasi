import 'package:flutter/material.dart';

class ListMenu extends StatelessWidget {
  ListMenu({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}
