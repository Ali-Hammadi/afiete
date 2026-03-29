import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomFindDoctorsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomFindDoctorsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Find specialist", style: AppStyles.headingMedium),
      centerTitle: true,
    );
  }
}
