import 'package:flutter/material.dart';

import 'package:mobile/utils/CustomColors.dart';
import 'package:mobile/utils/global_data.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final Color color, textColor;
  final double width;
  final double height;

  const RoundedButton({
    Key? key,
    this.text = '',
    required this.onPressed,
    this.color = CustomColors.purple,
    this.textColor = CustomColors.white,
    this.width = double.infinity,
    this.height = double.infinity,
  }); // : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _colorTween = ColorTween(
      begin: CustomColors.purple,
      end: CustomColors.green,
    ).animate(_animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (GlobalData.accountType == 1)
      _animationController.forward();
    else
      _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Container(
        width: widget.width,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              _colorTween.value,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor,
              fontSize: 20,
            ),
          ),
          onPressed: widget.onPressed,
        ),
      ),
    );
  }
}
