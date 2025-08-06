import 'package:flutter/material.dart';

class NavigationTileComponent extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final String routeName;
  final Object? arguments;

  const NavigationTileComponent({
    super.key,
    required this.title,
    required this.icon,
    required this.routeName,
    this.iconColor,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? colorScheme.secondary),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      },
    );
  }
}
