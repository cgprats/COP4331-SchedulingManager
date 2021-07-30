import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';
import 'package:mobile/screens/job_listings_screen.dart';

class JobSearchBar extends StatefulWidget {
  final GlobalKey<JobListingsScreenState> jobScreenKey;

  const JobSearchBar({
    required this.jobScreenKey,
  });

  @override
  _JobSearchBarState createState() => _JobSearchBarState();
}

class _JobSearchBarState extends State<JobSearchBar>
    with TickerProviderStateMixin {
  bool _showFilters = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Size _searchBarSize = Size(0, 0);
  GlobalKey _searchBarKey = GlobalKey();
  GlobalKey _filterMenu = GlobalKey();
  String _input = '';
  DateTime? _startDate, _endDate;
  bool _showSignedUpJobs = false;
  bool _showNotSignedUpJobs = false;
  bool _showCompleted = true;
  bool _showUncompleted = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context,
      {bool isStartDate = false}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100, 12, 12),
    );
    if (pickedDate != null)
      setState(() {
        if (isStartDate)
          this._startDate = pickedDate;
        else
          this._endDate = pickedDate;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: RoundedInputField(
                    key: _searchBarKey,
                    hintText: 'Search...',
                    margin: EdgeInsets.zero,
                    onChanged: (value) {
                      this._input = value;
                    },
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) {
                      _search();
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: CustomColors.orange,
                      ),
                      onPressed: _search,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.filter_alt,
                    color: CustomColors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      this._showFilters = !this._showFilters;
                      if (this._showFilters)
                        _animationController.forward();
                      else
                        _animationController.reverse();
                      _searchBarSize = _searchBarKey.currentContext!.size!;
                    });
                  },
                ),
              ),
            ],
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(15),
                // height: 100,
                width: _searchBarSize.width - _searchBarSize.height,
                key: _filterMenu,
                decoration: BoxDecoration(
                  color: CustomColors.black,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Start Date:',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            label: Text(
                              this._startDate == null
                                  ? 'beginning'
                                  : _formatDate1(this._startDate!),
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_today,
                              color: CustomColors.orange,
                            ),
                            style: ButtonStyle(
                              alignment: Alignment.centerLeft,
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.zero,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                CustomColors.orange.withAlpha(75),
                              ),
                            ),
                            onPressed: () {
                              this._selectDate(
                                context,
                                isStartDate: true,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'End Date:',
                            style: TextStyle(
                              color: CustomColors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: OutlinedButton.icon(
                            label: Text(
                              this._endDate == null
                                  ? 'end'
                                  : _formatDate1(this._endDate!),
                              style: TextStyle(
                                color: CustomColors.white,
                              ),
                            ),
                            icon: Icon(
                              Icons.calendar_today,
                              color: CustomColors.orange,
                            ),
                            style: ButtonStyle(
                              alignment: Alignment.centerLeft,
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.zero,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                CustomColors.orange.withAlpha(75),
                              ),
                            ),
                            onPressed: () {
                              this._selectDate(
                                context,
                                isStartDate: false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Show Jobs That:',
                          style: TextStyle(
                            color: CustomColors.white,
                          ),
                        ),
                      ],
                    ),
                    Table(
                      columnWidths: <int, TableColumnWidth>{
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(3),
                      },
                      children: <TableRow>[
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                              child: Container(),
                            ),
                            TableCell(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: Checkbox.width + 5,
                                    width: Checkbox.width + 5,
                                    child: Checkbox(
                                      value: this._showCompleted,
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                        CustomColors.orange,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this._showCompleted = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Are Completed',
                                    style: TextStyle(
                                      color: CustomColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                              child: Container(),
                            ),
                            TableCell(
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: Checkbox.width + 5,
                                    width: Checkbox.width + 5,
                                    child: Checkbox(
                                      value: this._showUncompleted,
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                        CustomColors.orange,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this._showUncompleted = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Text(
                                    'Are Not Completed',
                                    style: TextStyle(
                                      color: CustomColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                              child: Visibility(
                                visible: GlobalData.accountType == 0,
                                child: Container(),
                              ),
                            ),
                            TableCell(
                              child: Visibility(
                                visible: GlobalData.accountType == 0,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: Checkbox.width + 5,
                                      width: Checkbox.width + 5,
                                      child: Checkbox(
                                        value: this._showSignedUpJobs,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                          CustomColors.orange,
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            this._showSignedUpJobs = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      "I'm Signed Up For",
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: <TableCell>[
                            TableCell(
                              child: Visibility(
                                visible: GlobalData.accountType == 0,
                                child: Container(),
                              ),
                            ),
                            TableCell(
                              child: Visibility(
                                visible: GlobalData.accountType == 0,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      height: Checkbox.width + 5,
                                      width: Checkbox.width + 5,
                                      child: Checkbox(
                                        value: this._showNotSignedUpJobs,
                                        fillColor:
                                            MaterialStateProperty.all<Color>(
                                          CustomColors.orange,
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            this._showNotSignedUpJobs = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      "I'm Not Signed Up For",
                                      style: TextStyle(
                                        color: CustomColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
    Map _payload = Map();
    _payload['input'] = this._input;
    _payload['companyCode'] = GlobalData.companyCode;
    _payload['email'] = GlobalData.email;
    _payload['showMine'] = this._showSignedUpJobs;
    _payload['showCompleted'] = this._showCompleted;
    _payload['start'] = _formatDate2(this._startDate);
    _payload['end'] = _formatDate2(this._endDate);
    widget.jobScreenKey.currentState!.searchJobs(_payload);
  }

  String _formatDate1(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _formatDate2(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
