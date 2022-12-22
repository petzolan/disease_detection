import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BodyPartContainer extends StatefulWidget {
  BodyPart bodyPart;

  BodyPartContainer(this.bodyPart);

  @override
  State<BodyPartContainer> createState() => _BodyPartContainerState();
}

class _BodyPartContainerState extends State<BodyPartContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.bodyPart.symptoms.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Column(
                    children: [
                      const Text(
                        "The symptom is often associated with these symptoms:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: ListView(
                        shrinkWrap: true,
                        children: widget.bodyPart.symptoms
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
        ),
        CustomButton(_showAllSymptoms, "Add other Symptoms"),
      ],
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
    widget.bodyPart.symptoms.forEach(
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
                widget.bodyPart.symptoms = values;
              });
            },
          );
        });
  }
}
