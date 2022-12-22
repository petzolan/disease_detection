import 'dart:convert';

import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/models/user_symptom.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/services/convert_service.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/services/diagnose_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
// import 'package:survey_kit/survey_kit.dart';

class SurveyScreenFlutter extends StatefulWidget {
  @override
  _SurveyScreenFlutterState createState() => _SurveyScreenFlutterState();
}

class _SurveyScreenFlutterState extends State<SurveyScreenFlutter> {
  List<Question> _initalQuestions = [];
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  List<MultiSelectItem<String>> allSymptomsOfBodyPart = [
    MultiSelectItem("There are no Symptoms for this Body Part.",
        "There are no Symptoms for this Body Part.")
  ];
  List<String> selectedSymptoms = [];
  List<MultiSelectItem<String>> propsedSymptomsOfSymptom = [];

  List<MultiSelectItem<String>> allbodyParts = [];
  List<String> selectedBodyParts = [];
  List<String> selectedProposedSymptoms = [];

  List<MultiSelectItem<String>> allDiseases = [];
  List<String> selectedDiseases = [];
  List<Symptom> allSymptoms = [];
  List<UserSymptom> userSymptoms = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  _getData() async {
    allSymptomsOfBodyPart = await ConvertService.instance.getAllSymptoms();
    allDiseases = await ConvertService.instance.getAllDiseases();
    allbodyParts = await ConvertService.instance.getAllBodyParts();
    setState(() {});
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    print(selectedBodyParts.length);
    if (selectedBodyParts.length != 1) {
      const snackBar = SnackBar(
        content: Text('Please select exactly one Location.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() => _currentStep = step);
    }
  }

  _setBodyLocationSymptoms() async {
    BodyPart bodyPart = await DatabaseService.instance.getBodyPart(
      selectedBodyParts.first,
    );
    setState(() {
      allSymptomsOfBodyPart =
          ConvertService.instance.convertSymptoms(bodyPart.symptoms);
    });
  }

  _setPropesSymptoms() async {
    List<Symptom> symptoms = await DatabaseService.instance.getSymptoms(
      selectedSymptoms,
    );

    for (var element in symptoms) {
      propsedSymptomsOfSymptom
          .addAll(ConvertService.instance.convertSymptoms(element.symptoms));
      List<Symptom> proposed =
          await DatabaseService.instance.getSymptoms(element.symptoms);
    }

    setState(() {
      propsedSymptomsOfSymptom = propsedSymptomsOfSymptom.toSet().toList();
      // allSymptoms = selectedSymptoms.ll(propsedSymptomsOfSymptom);
    });
  }

  _setAllSymptoms() async {
    List<Symptom> symptoms = await DatabaseService.instance.getSymptoms(
      selectedSymptoms,
    );
    List<Symptom> proposed = await DatabaseService.instance.getSymptoms(
      selectedProposedSymptoms,
    );
    setState(() {
      allSymptoms.addAll(symptoms);
      allSymptoms.addAll(proposed);
      _generateUserSymptoms();
    });
  }

  _generateUserSymptoms() {
    setState(() {
      for (var element in allSymptoms) {
        userSymptoms.add(UserSymptom(
          SymptomIntensity.medium,
          NovelityFactor.veryNew,
          element,
        ));
      }
    });
  }

  continued() {
    if (selectedBodyParts.length != 1 && _currentStep == 1) {
      const snackBar = SnackBar(
        content: Text('Please select exactly one Location.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (_currentStep == 1) {
        setState(() {
          _setBodyLocationSymptoms();
        });
      }
      if (_currentStep == 2) {
        setState(() {
          _setPropesSymptoms();
        });
      }
      if (_currentStep == 3) {
        setState(() {
          _setAllSymptoms();
        });
      }
      _currentStep < 7 ? setState(() => _currentStep += 1) : null;
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        stringTitle: "New Diagnose",
        route: Routes.home,
      ),
      body: Container(
        color: Colors.white,
        child: Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppVariables.lightBlue,
                ),
          ),
          child: Stepper(
            type: stepperType,
            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: [
              Step(
                title: const Text('Welcome!'),
                content: const Text("Let\'s find out what you got!"),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Location of the Symptoms'),
                subtitle: const Text(
                  "Please select the body Part you are experiencing your symptoms on.",
                ),
                content: MultiSelectChipField<String>(
                  items: allbodyParts,
                  icon: Icon(Icons.check),
                  headerColor: AppVariables.lightBlue,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppVariables.lightBlue,
                    ),
                  ),
                  selectedChipColor: AppVariables.lightBlue.withOpacity(0.5),
                  title: const Text("Body Parts"),
                  textStyle: const TextStyle(color: Colors.black),
                  chipColor: AppVariables.lightBlue.withOpacity(0.1),
                  onTap: (values) {
                    setState(() {
                      selectedBodyParts = values;
                    });
                  },
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Select Symptoms'),
                subtitle: const Text(
                  "Please select the symptoms.",
                ),
                content: MultiSelectChipField<String>(
                  items: allSymptomsOfBodyPart,
                  icon: Icon(Icons.check),
                  headerColor: AppVariables.lightBlue,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppVariables.lightBlue,
                    ),
                  ),
                  selectedChipColor: AppVariables.lightBlue.withOpacity(0.5),
                  title: const Text("Symptoms"),
                  textStyle: const TextStyle(color: Colors.black),
                  chipColor: AppVariables.lightBlue.withOpacity(0.1),
                  onTap: (values) {
                    setState(() {
                      selectedSymptoms = values;
                    });
                  },
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Proposed Symptoms'),
                subtitle: const Text("Do you also have any of those Symptoms?"),
                content: MultiSelectChipField<String>(
                  items: propsedSymptomsOfSymptom,
                  icon: Icon(Icons.check),
                  headerColor: AppVariables.lightBlue,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppVariables.lightBlue,
                    ),
                  ),
                  selectedChipColor: AppVariables.lightBlue.withOpacity(0.5),
                  title: const Text("Proposed Symptoms"),
                  textStyle: const TextStyle(color: Colors.black),
                  chipColor: AppVariables.lightBlue.withOpacity(0.1),
                  onTap: (values) {
                    setState(() {
                      selectedProposedSymptoms = values;
                    });
                  },
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Rating the Symptoms'),
                subtitle:
                    const Text("Let\'s get more details about your Symptoms."),
                content: Column(
                    children: userSymptoms.map((e) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Symptom: " + e.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text("How intense would you describe the symptom?"),
                      const SizedBox(
                        height: 10,
                      ),
                      ToggleSwitch(
                        cornerRadius: 8.0,
                        activeBgColors: [
                          [AppVariables.lightBlue.withOpacity(0.5)],
                          [AppVariables.lightBlue.withOpacity(0.75)],
                          [AppVariables.lightBlue],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 1,
                        totalSwitches: 3,
                        labels: ["low", "medium", "high"],
                        radiusStyle: true,
                        onToggle: (index) {
                          switch (index) {
                            case 0:
                              e.symptomIntensity = SymptomIntensity.low;
                              break;
                            case 1:
                              e.symptomIntensity = SymptomIntensity.medium;
                              break;
                            case 2:
                              e.symptomIntensity = SymptomIntensity.high;
                              break;
                          }
                          print(e.symptomIntensity.value);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("How long do you already have the Symptom?"),
                      const SizedBox(
                        height: 10,
                      ),
                      ToggleSwitch(
                        cornerRadius: 8.0,
                        activeBgColors: [
                          [AppVariables.lightBlue.withOpacity(0.75)],
                          [AppVariables.lightBlue],
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        initialLabelIndex: 1,
                        totalSwitches: 2,
                        labels: ["old", "new"],
                        radiusStyle: true,
                        onToggle: (index) {
                          switch (index) {
                            case 0:
                              e.novelityFactor = NovelityFactor.old;
                              break;
                            case 1:
                              e.novelityFactor = NovelityFactor.veryNew;
                              break;
                          }
                        },
                      ),
                    ],
                  );
                }).toList()),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: const Text('Get Diagnose'),
                content: Column(
                  children: [
                    const Text("Let\'s calculate the Diseases!"),
                    ElevatedButton(
                      onPressed: (() {

                        DiagnoseService.instance
                            .calculateWordMatchPercentageSIMPLE(userSymptoms);

                        const snackBar = SnackBar(
                          content: Text('Finished'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        ;
                      }),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            AppVariables.lightBlue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Get Disease",
                      ),
                    )
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
