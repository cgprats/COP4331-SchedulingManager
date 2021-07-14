import 'package:flutter/material.dart';

import 'package:mobile/utils/CustomColors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final Color color;
  final double? width;
  final double? height;

  const TextFieldContainer({
    //Key key,
    required this.child,
    this.color = CustomColors.white,
    this.width,
    this.height,
  }); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: child,
    );
  }
}
