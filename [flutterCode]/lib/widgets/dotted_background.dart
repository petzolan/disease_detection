import 'package:disease_application_bachelor_thesis/utils/app_images.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:flutter/material.dart';

class DottedBackground extends StatelessWidget {
  static const double _fractionWidth = 0.664;

  final Widget child;
  final Widget? floatingActionButton;

  const DottedBackground({
    Key? key,
    required this.child,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: Image(
              image: AppImages.dotted,
              width: MediaQuery.of(context).size.width * _fractionWidth,
              height: MediaQuery.of(context).size.width * _fractionWidth,
              color: AppVariables.lightBlue,
            ),
          ),
          child,
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
