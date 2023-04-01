

import 'package:flutter/material.dart';

class StylishAppBar extends StatelessWidget with PreferredSizeWidget {
  const StylishAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 244, 246),
        title: Image.asset(
          'assets/images/stylish_app_bar.png',
          fit: BoxFit.contain,
          height: AppBar().preferredSize.height / 2,
        ),
        centerTitle: true,
        elevation: 1);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}