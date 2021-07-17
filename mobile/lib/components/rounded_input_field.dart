import 'package:flutter/material.dart';

import 'package:mobile/utils/CustomColors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatefulWidget {
  final String? hintText, labelText, errorMessage;
  final Color? labelColor;
  final double? width, height;
  final Function(String)? onChanged, onFieldSubmitted;
  final bool enabled, obscureText, autofocus, skipTraversal, required;
  final TextInputAction textInputAction;
  final IconButton? suffixIcon;
  final double order;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.labelText,
    this.labelColor,
    this.errorMessage = 'Field cannot be empty',
    this.width,
    this.height,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.obscureText = false,
    this.autofocus = false,
    this.skipTraversal = false,
    this.required = true,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.order = -1,
  }); // : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      skipTraversal: widget.skipTraversal,
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RoundedInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    focusNode.skipTraversal = widget.skipTraversal;
  }

  @override
  Widget build(BuildContext context) {
    FocusOrder order = NumericFocusOrder(widget.order);
    return FocusTraversalOrder(
      order: order,
      child: TextFieldContainer(
        child: TextFormField(
          enabled: widget.enabled,
          focusNode: this.focusNode,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: widget.labelColor,
            ),
            hintText: widget.hintText,
            labelText: widget.labelText,
            border: InputBorder.none,
            suffixIcon: widget.suffixIcon,
          ),
          validator: (value) {
            // return null;
            if (widget.required && (value == null || value.isEmpty)) {
              return widget.errorMessage;
            }
            return null;
          },
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
        ),
        width: widget.width,
        height: widget.height,
      ),
    );
  }
}
