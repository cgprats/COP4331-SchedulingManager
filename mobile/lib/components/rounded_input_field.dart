import 'package:flutter/material.dart';

import 'package:large_project/utils/CustomColors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final double? width;
  final double? height;
  final Function(String)? onChanged;
  final bool autofocus;

  const RoundedInputField({
    //Key key,
    this.hintText,
    this.labelText,
    this.width,
    this.height,
    this.onChanged,
    this.autofocus = false,
  }); //: super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        decoration: InputDecoration(
          hintText: this.hintText,
          labelText: this.labelText,
          border: InputBorder.none,
        ),
        onChanged: this.onChanged,
        autofocus: this.autofocus,
      ),
      width: this.width,
      height: this.height,
    );
  }
}
