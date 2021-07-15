import 'package:flutter/material.dart';

import 'package:mobile/utils/CustomColors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText, labelText, errorMessage;
  final double? width, height;
  final Function(String)? onChanged, onFieldSubmitted;
  final bool obscureText, autofocus, required;
  final TextInputAction textInputAction;
  final IconButton? suffixIcon;

  const RoundedInputField({
    //   Key key,
    this.hintText,
    this.labelText,
    this.errorMessage = 'Field cannot be empty',
    this.width,
    this.height,
    this.onChanged,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.autofocus = false,
    this.required = true,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
  }); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: this.obscureText,
        decoration: InputDecoration(
          hintText: this.hintText,
          labelText: this.labelText,
          border: InputBorder.none,
          suffixIcon: this.suffixIcon,
        ),
        validator: (value) {
          // if (this.required && (value == null || value.isEmpty)) {
          //   return this.errorMessage;
          // }
          return null;
        },
        onChanged: this.onChanged,
        onFieldSubmitted: this.onFieldSubmitted,
        autofocus: this.autofocus,
        textInputAction: this.textInputAction,

      ),
      width: this.width,
      height: this.height,
    );
  }
}
