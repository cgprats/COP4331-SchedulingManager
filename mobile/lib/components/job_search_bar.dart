import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';
import 'package:mobile/components/custom_scaffold.dart';

class JobSearchBar extends StatefulWidget {
  @override
  _JobSearchBarState createState() => _JobSearchBarState();
}

class _JobSearchBarState extends State<JobSearchBar>
    with TickerProviderStateMixin {
  bool _showFilters = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Size _searchBarSize = Size(0,0);
  GlobalKey _searchBarKey = GlobalKey();
  GlobalKey _filterMenu = GlobalKey();

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
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: CustomColors.orange,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.filter_alt,
                    color: CustomColors.orange,
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
                //Container(
                // child: PopupMenuButton(
                //   icon: Icon(
                //     Icons.filter_alt,
                //     color: CustomColors.orange,
                //   ),
                //   itemBuilder: (BuildContext context) => <PopupMenuEntry<menu>>[
                //     const PopupMenuItem<menu>(
                //       value: menu.notes,
                //       child: Text('Notes'),
                //     ),
                //   ],
                // ),
                // ),
              ),
            ],
          ),
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            axisAlignment: -1,
            child: Center(
              child: Container(
                height: 100,
                width: _searchBarSize.width - _searchBarSize.height,
                key: _filterMenu,
                decoration: BoxDecoration(
                  color: CustomColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
