import 'dart:async';
import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/advices/advice_container.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/body_parts/body_part_container.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/diseases/disease_container.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/symptom/symptom_container.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DetailScreen extends StatefulWidget {
  dynamic item;

  DetailScreen(this.item);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        stringTitle: widget.item.name,
        route: Routes.doctorPanel,
      ),
      body: _getItemWidget(),
    );
  }

  _getItemWidget() {
    switch (widget.item.runtimeType) {
      case BodyPart:
        return BodyPartContainer(widget.item);
      case Symptom:
        return SymptomContainer(widget.item);
      case Disease:
        return DiseaseContainer(widget.item);
      case Advice:
        return AdviceContainer(widget.item);
      default:
    }
  }
}
