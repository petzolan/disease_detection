import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/routing/categories/category.dart';
import 'package:flutter/material.dart';

const List<Category> categories = [
  Category(name: 'Diagnoses', color: Colors.blueGrey, route: Routes.diagnosesList),
  Category(name: 'Advices', color: Colors.blueGrey, route: Routes.advices),
  Category(name: 'Doctor Panel', color: Colors.blueGrey, route: Routes.doctorPanel),
];
