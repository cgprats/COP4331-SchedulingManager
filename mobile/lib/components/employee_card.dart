import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';

class EmployeeCard extends StatefulWidget {
  final Map<String, String> clientInfo;
  final double? width, height;
  const EmployeeCard({
    required this.clientInfo,
    this.width,
    this.height,
  });

  @override
  _EmployeeCardState createState() => _EmployeeCardState();
}

class _EmployeeCardState extends State<EmployeeCard> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.width,

    );
  }
}