import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/utils/global_data.dart';
import 'package:mobile/utils/get_api.dart';
import 'package:mobile/utils/custom_colors.dart';
import 'package:mobile/routes/routes.dart';
import 'package:mobile/components/rounded_input_field.dart';
import 'package:mobile/components/rounded_button.dart';
import 'package:mobile/components/job_card.dart';

class CustomScaffold extends StatefulWidget {
  final Widget? body;
  final String? title;
  final Color? appBarColor, backgroundColor;
  final bool doAnimation;
  final Duration duration;

  CustomScaffold({
    this.body,
    this.title,
    this.appBarColor,
    this.backgroundColor,
    this.doAnimation = false,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold>
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
      begin: CustomColors.orange,
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
    return Scaffold(
      appBar: customAppBar(),
      body: widget.body,
      backgroundColor: widget.backgroundColor,
      endDrawer: Drawer(
        child: Container(
          color: CustomColors.orange,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(
                  'WORKHORSE',
                  style: TextStyle(color: CustomColors.white, fontSize: 24),
                ),
                // trailing: Image(
                //   image: AssetImage('assets/logo.png'),
                // ),
              ),
              if (GlobalData.verified == true) ...[
                ListTile(
                  title: Text(
                    'Job Listings',
                    style: TextStyle(color: CustomColors.white),
                  ),
                  trailing: Icon(
                    Icons.work,
                    color: CustomColors.white,
                  ),
                  onTap: () {
                    String _route = Routes.JOBLISTINGSSCREEN;
                    Navigator.pop(context);
                    if (ModalRoute.of(context)!.settings.name != _route)
                      Navigator.pushNamed(context, _route);
                  },
                ),
                ListTile(
                  title: Text(
                    'Employee Search',
                    style: TextStyle(color: CustomColors.white),
                  ),
                  trailing: Icon(
                    Icons.groups,
                    color: CustomColors.white,
                  ),
                  onTap: () {
                    String _route = Routes.EMPLOYEESEARCHSCREEN;
                    Navigator.pop(context);
                    if (ModalRoute.of(context)!.settings.name != _route)
                      Navigator.pushNamed(context, _route);
                  },
                ),
                ListTile(
                    title: Text(
                      'Manage Account',
                      style: TextStyle(
                        color: CustomColors.white,
                      ),
                    ),
                    trailing: Icon(
                      Icons.account_box,
                      color: CustomColors.white,
                    ),
                    onTap: () {
                      String _route = Routes.MANAGEACCOUNTSCREEN;
                      Navigator.pop(context);
                      if (ModalRoute.of(context)!.settings.name != _route)
                        Navigator.pushNamed(context, _route);
                    }),
              ] else ...[
                ListTile(
                  title: Text(
                    'Sign In',
                    style: TextStyle(color: CustomColors.white),
                  ),
                  trailing: Icon(
                    Icons.login,
                    color: CustomColors.white,
                  ),
                  onTap: () {
                    String _route = Routes.LOGINSCREEN;
                    Navigator.pop(context);
                    if (ModalRoute.of(context)!.settings.name != _route)
                      Navigator.pushNamed(context, _route);
                  },
                ),
                ListTile(
                  title: Text(
                    'Sign Up',
                    style: TextStyle(color: CustomColors.white),
                  ),
                  trailing: Icon(
                    Icons.how_to_reg,
                    color: CustomColors.white,
                  ),
                  onTap: () {
                    String _route = Routes.SIGNUPSCREEN;
                    Navigator.pop(context);
                    if (ModalRoute.of(context)!.settings.name != _route)
                      Navigator.pushNamed(context, _route);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget customAppBar({Color? color, bool? animate}) {
    if (color == null) color = widget.appBarColor;
    if (animate == null) animate = widget.doAnimation;
    if (animate)
      return PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: AnimatedBuilder(
          animation: _colorTween,
          builder: (context, child) => customAppBar(
            color: _colorTween.value,
            animate: false,
          ),
        ),
      );
    return AppBar(
      leading: Image(
        image: AssetImage('assets/logo.png'),
      ),
      title: Text(
        '${widget.title}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: CustomColors.white,
          fontSize: 26,
        ),
      ),
      centerTitle: true,
      backgroundColor: color,
    );
  }
}
