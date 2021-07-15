import 'package:flutter/material.dart';

import 'package:mobile/utils/CustomColors.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function()? onPress;
  final Color color, textColor;
  final double width;
  final double height;

  const RoundedButton({
    // Key key,
    this.text = '',
    required this.onPress,
    this.color = CustomColors.purple,
    this.textColor = CustomColors.white,
    this.width = double.infinity,
    this.height = double.infinity,
  }); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            this.color,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          // fixedSize: MaterialStateProperty.all<Size>(
          //   Size(this.width, this.height),
          // ),
        ),
        child: Text(
          this.text,
          style: TextStyle(color: this.textColor),
        ),
        onPressed: onPress,
      ),
    );
  }
}
