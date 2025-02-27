import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/theme/theme.dart';

class InputTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final VoidCallback?
      onTrailingIconTap; // Add an optional callback for trailing icon tap

  const InputTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
    this.onTrailingIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: BlaTextStyles.body,
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(trailingIcon),
        color: BlaColors.primary,
      ),
      onTap: onTap,
    );
  }
}
