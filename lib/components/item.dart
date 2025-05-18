import 'package:calendar/components/index.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  // This widget is the root of your application.
  final String title;
  final VoidCallback tap;
  final IconData? icon;

  const Item({
    super.key,
    required this.title,
    required this.tap,
    this.icon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 0,
      child: ListTile(
        title: Common.text(title),
        onTap: tap,
        leading: Icon(icon),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
