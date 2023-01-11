import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
   final void Function()? onPressed;
   final String stringText;

  CustomButton(this.onPressed, this.stringText);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll<Color>(AppVariables.lightBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        stringText,
      ),
    );
  }
}
