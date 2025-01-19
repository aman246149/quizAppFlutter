import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/hspace.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.actionText, this.onActionTap});

  final String? actionText;
  final Function()? onActionTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Icon(Icons.arrow_back),
      ),
      actions: [
        GestureDetector(
          onTap: onActionTap,
          child: Text(actionText ?? ""),
        ),
        Hspace(24)
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
