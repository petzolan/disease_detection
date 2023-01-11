import 'package:disease_application_bachelor_thesis/models/types.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/services/convert_service.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AdviceAddDialog extends StatefulWidget {
  Types type;

  AdviceAddDialog(this.type);

  @override
  State<AdviceAddDialog> createState() => _AdviceAddDialogState();
}

class _AdviceAddDialogState extends State<AdviceAddDialog> {
  final _formKey = GlobalKey<FormState>();

  List<MultiSelectItem<String>> allSymptoms = [];
  List<String> selectedSymptoms = [];

  List<MultiSelectItem<String>> allbodyParts = [];
  List<String> selectedBodyParts = [];

  List<MultiSelectItem<String>> allDiseases = [];
  List<String> selectedDiseases = [];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _treatmentController = TextEditingController();
  double _currentSliderValue = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  _getData() async {
    allSymptoms = await ConvertService.instance.getAllSymptoms();
    allDiseases = await ConvertService.instance.getAllDiseases();
    allbodyParts = await ConvertService.instance.getAllBodyParts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        stringTitle: "Add new Data",
        route: Routes.doctorPanel,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  // The validator receives the text that the user has entered.
                  decoration: const InputDecoration(
                    icon: Icon(Icons.abc),
                    hintText: "Name",
                    labelText: "Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                (widget.type != Types.bodyPart && widget.type != Types.symptom)
                    ? TextFormField(
                        controller: _descriptionController,
                        // The validator receives the text that the user has entered.
                        decoration: const InputDecoration(
                          icon: Icon(Icons.text_fields),
                          hintText: "Description",
                          labelText: "Description",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )
                    : Container(),

                (widget.type == Types.disease)
                    ? TextFormField(
                        controller: _treatmentController,
                        // The validator receives the text that the user has entered.
                        decoration: const InputDecoration(
                          icon: Icon(Icons.shutter_speed_sharp),
                          hintText: "Treatment",
                          labelText: "Treatment",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 25,
                ),
                // FIELD FOR SYMPTOMS ONLY WHEN ADVICE OR SYMPTOM OR DISEASE
                MultiSelectChipField<String>(
                  items: allSymptoms,
                  icon: Icon(Icons.check),
                  headerColor: AppVariables.lightBlue,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppVariables.lightBlue,
                    ),
                  ),
                  selectedChipColor: AppVariables.lightBlue.withOpacity(0.5),
                  title: Text("Select Symptoms"),
                  textStyle: TextStyle(color: Colors.black),
                  chipColor: AppVariables.lightBlue.withOpacity(0.1),
                  onTap: (values) {
                    selectedSymptoms = values;
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                (widget.type == Types.advice)
                    ? MultiSelectChipField<String>(
                        items: allDiseases,
                        icon: Icon(Icons.check),
                        headerColor: AppVariables.lightBlue,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppVariables.lightBlue,
                          ),
                        ),
                        selectedChipColor:
                            AppVariables.lightBlue.withOpacity(0.5),
                        title: Text("Select Diseases for the Advice"),
                        textStyle: TextStyle(color: Colors.black),
                        chipColor: AppVariables.lightBlue.withOpacity(0.1),
                        onTap: (values) {
                          selectedDiseases = values;
                        },
                      )
                    : Container(),
                const SizedBox(
                  height: 25,
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
                      });
                    }),
                _getSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getSubmitButton() {
    switch (widget.type) {
      case Types.advice:
        return ElevatedButton(
          onPressed: () => {
            ConvertService.instance.addNewAdviceToDatabase(
              context,
              _nameController.text,
              _descriptionController.text,
              selectedSymptoms,
              selectedDiseases,
            )
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppVariables.lightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text(
            "Save Advice",
          ),
        );
      case Types.symptom:
        return ElevatedButton(
          onPressed: () => {
            ConvertService.instance.addNewSymptomToDatabase(
              context,
              _nameController.text,
              _currentSliderValue.toInt(),
              selectedSymptoms,
              selectedBodyParts,
            )
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppVariables.lightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text(
            "Save Symptom",
          ),
        );
      case Types.disease:
        return ElevatedButton(
          onPressed: () => {
            ConvertService.instance.addNewDiseaseToDatabase(
              context,
              _nameController.text,
              _descriptionController.text,
              _treatmentController.text,
              selectedSymptoms,
            )
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppVariables.lightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text(
            "Save Disease",
          ),
        );
      case Types.bodyPart:
        return ElevatedButton(
          onPressed: () => {
            ConvertService.instance.addNewBodyPartToDatabase(
              context,
              _nameController.text,
              selectedSymptoms,
            )
          },
          style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll<Color>(AppVariables.lightBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          child: const Text(
            "Save Body Part",
          ),
        );
    }
  }
}
