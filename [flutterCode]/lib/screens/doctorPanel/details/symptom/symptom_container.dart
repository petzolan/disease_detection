import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SymptomContainer extends StatefulWidget {
  Symptom symptom;

  SymptomContainer(this.symptom);

  @override
  State<SymptomContainer> createState() => _SymptomContainerState();
}

class _SymptomContainerState extends State<SymptomContainer> {
  _buildFabItems() {
    return [
      FabItemData(
        'Update Symptom',
        Icons.save,
        onPress: () => {
          setState(() {
            DatabaseService.instance.updateSymptom(widget.symptom);
          })
        },
      ),
      FabItemData(
        'Delete Symptom',
        Icons.delete,
        onPress: () => {
          setState(() {
            DatabaseService.instance.deleteSymptom(widget.symptom);
          })
        },
      ),
    ];
  }

  double _currentSliderValue = 1;
  @override
  void initState() {
    // TODO: implement initState
    _currentSliderValue = widget.symptom.defaultWeight.toDouble();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FabMenu(_buildFabItems()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.symptom.symptoms.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        const Text(
                          "Proposed Symptoms of the Symptom:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: ListView(
                          shrinkWrap: true,
                          children: widget.symptom.symptoms
                              .map((e) => ListTile(
                                    dense: true,
                                    title: Text(
                                      e.replaceAll("_", " "),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ))
                              .toList(),
                        ))
                      ],
                    ),
                  )
                : const Text("No Symptoms selected yet."),
            const SizedBox(
              height: 10,
            ),
            CustomButton(_showAllSymptoms, "Add other Symptoms"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Default Weight of the Symptom:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
                value: _currentSliderValue,
                max: 100,
                divisions: 20,
                thumbColor: AppVariables.lightBlue,
                activeColor: AppVariables.lightBlue,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    widget.symptom.defaultWeight = _currentSliderValue / 100;
                  });
                }),
          ],
        ),
      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  _showAllSymptoms() async {
    var data = await DatabaseService.instance.retrieveSymptoms();
    List<MultiSelectItem<String>> symNames = [];

    for (var element in data) {
      symNames.add(MultiSelectItem(element.name, element.name));
    }
    List<String> symptoms = [];
    widget.symptom.symptoms.forEach(
      (element) {
        String e = capitalize(element.replaceAll("_", " "));
        symptoms.add(e);
      },
    );
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog<String>(
            items: symNames,
            initialValue: symptoms,
            onConfirm: (values) {
              setState(() {
                widget.symptom.symptoms = values;
              });
            },
          );
        });
  }
}
