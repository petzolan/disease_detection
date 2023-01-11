import 'dart:math';

import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_menu.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class DiseaseContainer extends StatefulWidget {
  Disease disease;

  DiseaseContainer(this.disease);

  @override
  State<DiseaseContainer> createState() => _DiseaseContainerState();
}

class _DiseaseContainerState extends State<DiseaseContainer> {
  bool _treatmentIsEnabled = false;
  bool _descriptionIsEnabled = false;
  final _random = new Random();
  TextEditingController _treatmentController = TextEditingController(text: "");
  TextEditingController _descriptionController =
      TextEditingController(text: "");
  @override
  void initState() {
    super.initState();
    _treatmentController =
        TextEditingController(text: widget.disease.treatment);
    _descriptionController =
        TextEditingController(text: widget.disease.description);
  }

  _buildFabItems() {
    return [
      FabItemData(
        'Update Disease',
        Icons.save,
        onPress: () => {
          setState(() {
            widget.disease.description = _descriptionController.value.text;
            widget.disease.treatment = _treatmentController.value.text;
            DatabaseService.instance.updateDisease(widget.disease);
          })
        },
      ),
      FabItemData(
        'Delete Disease',
        Icons.delete,
        onPress: () => {
          setState(() {
            DatabaseService.instance.deleteDisease(widget.disease);
          })
        },
      ),
    ];
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  _showAllSymptoms() async {
    var data = await DatabaseService.instance.retrieveSymptoms();
    List<MultiSelectItem<String>> symNames = [];

    for (var element in data) {
      symNames.add(MultiSelectItem(element.name, element.name));
    }
    List<String> symptoms = [];
    widget.disease.symptoms.keys.forEach(
      (element) {
        String e = capitalize(element.replaceAll("_", " "));
        symptoms.add(e);
      },
    );

    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          print(symptoms);
          return MultiSelectDialog<String>(
            items: symNames,
            initialValue: symptoms,
            onConfirm: (values) {
              setState(() {
                print(values);
                widget.disease.symptoms = {
                  for (var element in values)
                    element: doubleInRange(
                      _random,
                      0.0,
                      3.0,
                    ),
                };
              });
            },
          );
        });
  }

  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;
  _createTextField(String pHeading, TextEditingController pEditingController,
      bool pEditBool) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pHeading,
            style: TextStyle(
              color: AppVariables.lightBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: const TextStyle(fontSize: 14),
                  controller: pEditingController,
                  enabled: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      pEditBool = true;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FabMenu(_buildFabItems()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _createTextField(
              "Description",
              _descriptionController,
              _descriptionIsEnabled,
            ),
            widget.disease.symptoms.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        const Text(
                          "The Disease is often associated with these symptoms:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: Scrollbar(
                            child: ListView(
                              shrinkWrap: true,
                              children: widget.disease.symptoms.keys
                                  .map((e) => ListTile(
                                        dense: true,
                                        title: Text(e.replaceAll("_", " ")),
                                      ))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 15,
            ),
            CustomButton(_showAllSymptoms, "Add other Symptoms"),
            _createTextField(
              "Treatment",
              _treatmentController,
              _treatmentIsEnabled,
            ),
          ],
        ),
      ),
    );
  }
}
