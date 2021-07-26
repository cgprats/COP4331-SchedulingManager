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
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Table(
          columnWidths: const <int,
              TableColumnWidth>{
            0: FractionColumnWidth(0.40),
          },
          children: <TableRow>[
            TableRow(
              children: <TableCell>[
                TableCell(
                  child: Container(
                    height: 30,
                    child: Text(
                      'Name:',
                      style: TextStyle(
                        color: CustomColors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 30,
                    child: Text(
                      GlobalData.firstName! + ' ' + GlobalData.lastName!,
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <TableCell>[
                TableCell(
                  child: Container(
                    height: 30,
                    padding:
                    EdgeInsets.only(top: 2.5),
                    child: Text(
                      'Email:',
                      style: TextStyle(
                        color: CustomColors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 30,
                    padding:
                    EdgeInsets.only(top: 2.5),
                    child: Text(
                      GlobalData.email!,
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: <TableCell>[
                TableCell(
                  child: Container(
                    height: 30,
                    padding:
                    EdgeInsets.only(top: 2.5),
                    child: Text(
                      'Phone:',
                      style: TextStyle(
                        color: CustomColors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    height: 30,
                    padding:
                    EdgeInsets.only(top: 2.5),
                    child: Text(
                      GlobalData.phone!,
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}