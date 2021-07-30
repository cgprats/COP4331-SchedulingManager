import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/utils/global_data.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_button.dart';


class NotesCard extends StatefulWidget {
  final Map<String, String> clientInfo;
  final double? width, height;

  const NotesCard({
    required this.clientInfo,
    this.width,
    this.height,
  });

  @override
  _NotesCardState createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.width,

    );
  }
}

// return new
// AlertDialog
// (
// title: const Text('
// Notes Example
// '
// )
// ,
// content: new
// SingleChildScrollView
// (
// child: Column
// (
// mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment
//     .start,children: <
// Widget>[
// Row
// (
// children: [
// Text
// ('Example Title
// '
// ,
// style: TextStyle
// (
// color: CustomColors.white,fontWeight: FontWeight.bold,)
// ,
// )
// ,
// Text
// ('2021-07-23
// '
// ,
// style: TextStyle
// (
// color: CustomColors.white,fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ],
// )
// ,
// )
// ,
// actions: <
// Widget>[
// new
// FlatButton
// (
// onPressed: () {
// Navigator.of(context).pop();
// },
// textColor: Theme.of(context).
// primaryColor,child: const Text('
// Close
// '
// )
// ,
// )
// ,
// ]
// ,
// scrollable: true
// ,
// );
// }