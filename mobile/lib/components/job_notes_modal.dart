import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card_container.dart';
import 'package:mobile/screens/job_listings_screen.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class JobNotes extends StatelessWidget {
  final String jobId;

  // final GlobalKey<JobNotesState> key = GlobalKey<JobNotesState>();

  JobNotes({
    required this.jobId,
  }); // : super(key: key);

  // JobNotesState createState() => JobNotesState();
// }
//
// class JobNotesState extends State<JobNotes> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _JobNotesTitle(),
      titlePadding: EdgeInsets.zero,
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _JobNotesBody(
            jobId: this.jobId,
            // jobNotesKey: widget.key!,
          );
        },
      ),
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        _JobNotesActions(jobId: this.jobId),
      ],
      backgroundColor: CustomColors.grey,
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _JobNotesTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: CustomColors.orange,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Job Notes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CustomColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JobNotesBody extends StatefulWidget {
  final String jobId;

  // final Key jobNotesKey;

  _JobNotesBody({
    // required this.jobNotesKey,
    required this.jobId,
  });

  @override
  _JobNotesBodyState createState() => _JobNotesBodyState();
}

class _JobNotesBodyState extends State<_JobNotesBody> {
  GlobalKey<FormState> _formKey = GlobalKey();
  List<Widget> _notes = [];

  @override
  void initState() {
    super.initState();
    _searchNotes(
      {
        'fooid': widget.jobId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _notes,
    );
  }

  void _addNote(Map _payload) {
    if (_payload['firstName'] == null ||
        _payload['lastName'] == null ||
        _payload['date'] == null ||
        _payload['note'] == null) return;
    setState(
      () {
        _notes.add(
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${_payload['firstName']} ${_payload['lastName']}',
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _payload['date'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: CustomColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _payload['note'],
                  style: TextStyle(
                    color: CustomColors.white,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate1(DateTime dateTime) {
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  void _searchNotes(Map _payload) async {
    print('searchNotes!');
    String dir = '/searchNotes';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      setState(
        () {
          print('searchNotes successful!');
          for (var note in jsonObj['notes']) {
            _addNote(note);
          }
        },
      );
    }
  }
}

class _JobNotesActions extends StatefulWidget {
  final String jobId;

  _JobNotesActions({
    required this.jobId,
  });

  @override
  _JobNotesActionsState createState() => _JobNotesActionsState();
}

class _JobNotesActionsState extends State<_JobNotesActions>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _curve;
  late Animation<double> _textFieldAnimation, _cancelButtonAnimation;
  bool _isAddingNote = false;
  GlobalKey _textFieldKey = GlobalKey();
  double _textFieldWidth = 0.0;
  double? _buttonHeight;
  String? _noteText;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _textFieldAnimation = Tween(begin: 0.0, end: 1.0).animate(_curve);
    _cancelButtonAnimation = Tween(begin: 0.0, end: 0.5).animate(_curve);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizeTransition(
          sizeFactor: _textFieldAnimation,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: RoundedInputField(
            key: _textFieldKey,
            enabled: this._isAddingNote,
            labelText: 'Note',
            labelColor: CustomColors.orange,
            onChanged: (value) {
              _noteText = value;
            },
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            return Row(
              children: <Widget>[
                RoundedButton(
                  text: 'Cancel',
                  width: _textFieldWidth * _cancelButtonAnimation.value,
                  height: _buttonHeight,
                  padding: EdgeInsets.all(10),
                  color: CustomColors.orange,
                  onPressed: () {
                    setState(
                      () {
                        if (this._isAddingNote) {
                          this._isAddingNote = false;
                          _animationController.reverse();
                        }
                      },
                    );
                  },
                ),
                Expanded(
                  child: RoundedButton(
                    text: 'Add Note',
                    padding: EdgeInsets.all(10),
                    color: CustomColors.orange,
                    onPressed: () {
                      setState(
                        () {
                          if (this._isAddingNote) {
                            _addnote(
                              {
                                'fooid': widget.jobId,
                                'email': GlobalData.email,
                                'fn': GlobalData.firstName,
                                'ln': GlobalData.lastName,
                                'date': _formatDate2(DateTime.now()),
                                'title': '',
                                'note': _noteText,
                              },
                            );
                            this._isAddingNote = false;
                            _animationController.reverse();
                            Navigator.pop(context);
                          } else {
                            this._isAddingNote = true;
                            _animationController.forward();
                          }
                          _textFieldWidth =
                              _textFieldKey.currentContext!.size!.width;
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _addnote(Map _payload) async {
    print('addnote!');
    String dir = '/addnote';
    String ret = await API.getJson(dir, _payload);
    print(ret);
    var jsonObj = json.decode(ret);
    print(jsonObj);
    if (ret.isEmpty) {
      print('oh no :(');
    } else {
      print('addnote successful!');
    }
  }

  String _formatDate2(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
