import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final Function()? refresh;
  const AppErrorWidget(this.message, {this.refresh, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Ionicons.alert_circle_outline,
          color: Colors.orange,
          size: 24,
        ),
        SizedBox(
          height: 12,
        ),
        Text(message),
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
