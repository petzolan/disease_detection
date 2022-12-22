import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AdviceContainer extends StatefulWidget {
  Advice advice;
  AdviceContainer(this.advice);

  @override
  State<AdviceContainer> createState() => _AdviceContainerState();
}

class _AdviceContainerState extends State<AdviceContainer> {
  @override
  Widget build(BuildContext context) {
    _buildFabItems() {
      return [
        FabItemData(
          'Update Symptom',
          Icons.save,
          onPress: () => {
            setState(() {
              DatabaseService.instance.updateAdvice(widget.advice);
            })
          },
        ),
        FabItemData(
          'Delete Symptom',
          Icons.delete,
          onPress: () => {
            setState(() {
              DatabaseService.instance.deleteAdvice(widget.advice);
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
      widget.advice.symptoms.forEach(
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
                  widget.advice.symptoms = values;
                });
              },
            );
          });
    }

    _showAllDiseases() async {
      var data = await DatabaseService.instance.retrieveSymptoms();
      List<MultiSelectItem<String>> disNames = [];

      for (var element in data) {
        disNames.add(MultiSelectItem(element.name, element.name));
      }
      List<String> diseases = [];
      widget.advice.diseases.forEach(
        (element) {
          String e = capitalize(element.replaceAll("_", " "));
          diseases.add(e);
        },
      );
      showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            print(diseases);
            return MultiSelectDialog<String>(
              items: disNames,
              initialValue: diseases,
              onConfirm: (values) {
                setState(() {
                  print(values);
                  widget.advice.diseases = values;
                });
              },
            );
          });
    }

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

    return Scaffold(
      floatingActionButton: FabMenu(_buildFabItems()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.advice.symptoms.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        const Text(
                          "Advice helps with those Symptoms:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: widget.advice.symptoms
                                .map((e) => ListTile(
                                      dense: true,
                                      title: Text(
                                        e.replaceAll("_", " "),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text("No Symptoms selected yet."),
            CustomButton(_showAllSymptoms, "Add other Symptoms"),
            widget.advice.diseases.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        const Text(
                          "Advice helps with those Diseases:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: widget.advice.diseases
                                .map((e) => ListTile(
                                      dense: true,
                                      title: Text(
                                        e.replaceAll("_", " "),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text("No Symptoms selected yet."),
            CustomButton(_showAllDiseases, "Add other Diseases"),
          ],
        ),
      ),
    );
  }
}
