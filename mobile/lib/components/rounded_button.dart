import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final Color color, textColor;
  final double? width;
  final double? fontSize;
  final EdgeInsetsGeometry padding;

  const RoundedButton({
    Key? key,
    this.text = '',
    required this.onPressed,
    this.color = CustomColors.purple,
    this.textColor = CustomColors.white,
    this.width,
    this.fontSize,
    this.padding = EdgeInsets.zero,
  }); // : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            widget.padding,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            widget.color,
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.textColor,
            fontSize: widget.fontSize,
          ),
        ),
        onPressed: widget.onPressed,
      ),
    );
  }
}
