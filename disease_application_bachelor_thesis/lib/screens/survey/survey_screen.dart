import 'dart:convert';

import 'package:disease_application_bachelor_thesis/services/convert_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/survey_kit.dart';

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: FutureBuilder<Task>(
            future: getSampleTask(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                final task = snapshot.data!;
                return SurveyKit(
                  onResult: (SurveyResult result) {
                    Map<String, dynamic> queryResultToJson(
                        SurveyResult result) {
                      return <String, dynamic>{
                        "finishReason": result.finishReason.name,
                        "steps": result.results
                            .map((step) => <String, dynamic>{
                                  "id": step.id?.id,
                                  "startDate": step.startDate.toIso8601String(),
                                  "endDate": step.endDate.toIso8601String(),
                                  "results": step.results
                                      .map((r) => <String, dynamic>{
                                            "id": r.id?.id,
                                            "result": r.result is BooleanResult
                                                ? ((r.result
                                                            as BooleanResult) ==
                                                        BooleanResult.POSITIVE
                                                    ? true
                                                    : (r.result as BooleanResult) ==
                                                            BooleanResult
                                                                .NEGATIVE
                                                        ? false
                                                        : null)
                                                : r.result is TimeOfDay
                                                    ? '${(r.result as TimeOfDay).hour}:${(r.result as TimeOfDay).minute}'
                                                    : r.result is DateTime
                                                        ? (r.result as DateTime)
                                                            .toIso8601String()
                                                        : r.result,
                                            "startDate":
                                                r.startDate.toIso8601String(),
                                            "endDate":
                                                r.endDate.toIso8601String(),
                                            "valueIdentifier":
                                                r.valueIdentifier,
                                          })
                                      .toList()
                                })
                            .toList()
                      };
                    }

                    print(
                      queryResultToJson(
                        result,
                      ),
                    );
                    Navigator.pushNamed(context, '/home');
                  },
                  task: task,
                  localizations: {
                    'cancel': 'Cancel',
                    'next': 'Next',
                  },
                  themeData: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSwatch(
                      primarySwatch: Colors.lightBlue,
                    ).copyWith(
                      onPrimary: Colors.white,
                    ),
                    primaryColor: Colors.black,
                    backgroundColor: Colors.white,
                    appBarTheme: AppBarTheme(
                      color: AppVariables.lightBlue,
                      iconTheme: IconThemeData(
                        color: AppVariables.lightBlue,
                      ),
                      titleTextStyle: TextStyle(
                        color: AppVariables.lightBlue,
                      ),
                    ),
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.button?.copyWith(
                                color: Colors.cyan,
                              ),
                        ),
                      ),
                    ),
                    textTheme: const TextTheme(
                      headline2: TextStyle(
                        fontSize: 28.0,
                        color: Colors.black,
                      ),
                      headline5: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                      bodyText2: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                      subtitle1: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),
                    ),
                    inputDecorationTheme: const InputDecorationTheme(
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  surveyProgressbarConfiguration: SurveyProgressConfiguration(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              return const CircularProgressIndicator.adaptive();
            },
          ),
        ),
      ),
    );
  }

  Future<Task> getSampleTask() async {
    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Let\'s check in on you!',
          text: 'Get ready to analyse your symptoms.',
          buttonText: 'Start Diagnosis',
        ),
        QuestionStep(
          title: 'Symptoms',
          text:
              'Please select the Symptoms you\'re currently having trouble with.',
          isOptional: false,
          answerFormat: MultipleChoiceAnswerFormat(
            textChoices:
                await ConvertService.instance.convertSymptomsToSurveyElement(),
          ),
        ),
      ],
    );

    return Future.value(task);
  }

  Future<Task> getJsonTask() async {
    final taskJson = await rootBundle.loadString('assets/example_json.json');
    final taskMap = json.decode(taskJson);

    return Task.fromJson(taskMap);
  }
}
