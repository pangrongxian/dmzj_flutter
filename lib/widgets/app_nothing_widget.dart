import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AppNothingWidget extends StatelessWidget {
  final Function()? refresh;
  const AppNothingWidget({this.refresh, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Ionicons.cafe_outline,
          color: Colors.grey,
          size: 24,
        ),
        SizedBox(
          height: 12,
        ),
        Text("这里好像还什么都没有啊~"),
        SizedBox(
          height: 12,
        ),
        TextButton(
          onPressed: refresh,
          child: Text("重试"),
        ),
      ],
    );
  }
}
