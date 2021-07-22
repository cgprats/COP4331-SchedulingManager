import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/components/rounded_button.dart';

class AnimatedRoundedButton extends StatefulWidget {
  final String text;
  final Function()? onPressed;
  final Color color, textColor;
  final double? width;
  final double? fontSize;
  final EdgeInsetsGeometry padding;
  final Duration duration;

  const AnimatedRoundedButton({
    Key? key,
    this.text = '',
    required this.onPressed,
    this.color = CustomColors.purple,
    this.textColor = CustomColors.white,
    this.width,
    this.fontSize,
    this.padding = EdgeInsets.zero,
    required this.duration,
  }); // : super(key: key);

  @override
  _AnimatedRoundedButtonState createState() => _AnimatedRoundedButtonState();
}

class _AnimatedRoundedButtonState extends State<AnimatedRoundedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
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
      builder: (context, child) => RoundedButton(
        key: widget.key,
        text: widget.text,
        onPressed: widget.onPressed,
        color: _colorTween.value,
        textColor: widget.textColor,
        width: widget.width,
        fontSize: widget.fontSize,
        padding: widget.padding,
      ),
    );
  }
}
