import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BorderCard extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const BorderCard({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color:
              Get.isDarkMode ? Colors.transparent : Colors.grey.withOpacity(.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }
}
