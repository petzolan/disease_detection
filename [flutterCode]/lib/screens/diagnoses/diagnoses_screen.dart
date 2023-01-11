import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_menu.dart';
import 'package:flutter/material.dart';

class DiagnosesScreen extends StatefulWidget {
  const DiagnosesScreen({super.key});

  @override
  State<DiagnosesScreen> createState() => _DiagnosesScreenState();
}

class _DiagnosesScreenState extends State<DiagnosesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FabMenu(_buildFabItems()),
      appBar: AppBarWidget(
        stringTitle: "Diagnoses",
        route: Routes.home,
      ),
    );
  }

  _buildFabItems() {
    return [
      FabItemData(
        'Update Disease',
        Icons.save,
        onPress: () => {},
      ),
      FabItemData(
        'Delete Disease',
        Icons.delete,
        onPress: () => {},
      ),
    ];
  }
}
