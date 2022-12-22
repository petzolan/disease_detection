import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  String stringTitle;
  final double height;
  final Routes route;

  AppBarWidget({
    required this.stringTitle,
    required this.route,
    this.height = kToolbarHeight,
  });

  Size get preferredSize => Size.fromHeight(height);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      centerTitle: true,
      automaticallyImplyLeading: true,
      title: Text(
        stringTitle,
        style: TextStyle(shadows: [AppVariables.textShadow]),
      ),
      elevation: 0.0,
      backgroundColor: AppVariables.lightBlue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          AppNavigator.push(route);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }
}
