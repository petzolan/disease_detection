import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/models/types.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/advices/advice_add_dialog.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/detail_screen.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_menu.dart';
import 'package:flutter/material.dart';

class DoctorPanelScreen extends StatefulWidget {
  const DoctorPanelScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DoctorPanelScreen> createState() => _DoctorPanelScreenState();
}

class _DoctorPanelScreenState extends State<DoctorPanelScreen> {
  Future<List<dynamic>>? list;
  List<dynamic>? retrievedList;
  int _index = 0;
  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    list = DatabaseService.instance.retrieveBodyParts();
    retrievedList = await DatabaseService.instance.retrieveBodyParts();
  }

  Future<void> _changeCategory(int pIndex) async {
    switch (pIndex) {
      case 0:
        {
          list = DatabaseService.instance.retrieveBodyParts();
          retrievedList = await DatabaseService.instance.retrieveBodyParts();
        }
        break;

      case 1:
        {
          list = DatabaseService.instance.retrieveSymptoms();
          retrievedList = await DatabaseService.instance.retrieveSymptoms();
        }
        break;
      case 2:
        {
          list = DatabaseService.instance.retrieveDisease();
          retrievedList = await DatabaseService.instance.retrieveDisease();
        }
        break;

      case 3:
        {
          list = DatabaseService.instance.retrieveAdvices();
          retrievedList = await DatabaseService.instance.retrieveAdvices();
        }
        break;
      default:
        {
          list = DatabaseService.instance.retrieveBodyParts();
          retrievedList = await DatabaseService.instance.retrieveBodyParts();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBarWidget(
          stringTitle: "Doctor Panel",
          route: Routes.home,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              label: "Body Parts",
              icon: Icon(Icons.settings_accessibility),
            ),
            BottomNavigationBarItem(
              label: "Symptoms",
              icon: Icon(Icons.person_search_outlined),
            ),
            BottomNavigationBarItem(
              label: "Diseases",
              icon: Icon(Icons.personal_injury),
            ),
            BottomNavigationBarItem(
              label: "Advices",
              icon: Icon(Icons.tips_and_updates),
            )
          ],
          backgroundColor: AppVariables.lightBlue,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: AppVariables.lightBlue,
          unselectedItemColor: Colors.grey,
          currentIndex: _index,
          onTap: (int i) {
            setState(() {
              _index = i;
              _changeCategory(i);
            });
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: list,
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrievedList!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0)),
                        child: ListTile(
                          tileColor: AppVariables.lightBlue.withOpacity(0.6),
                          onTap: () => Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  DetailScreen(retrievedList![index]),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          title: Text(
                            retrievedList![index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: (retrievedList![index] is Disease ||
                                  retrievedList![index] is Advice)
                              ? Text(
                                  "${retrievedList![index].description.toString()}")
                              : Text(""),
                          trailing: const Icon(Icons.edit),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        floatingActionButton: FabMenu(_buildFabItems()));
  }

  _buildFabItems() {
    return [
      FabItemData(
        'Add new Symptom',
        Icons.add,
        onPress: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdviceAddDialog(Types.symptom);
            },
          )
        },
      ),
      FabItemData(
        'Add new Disease',
        Icons.add,
        onPress: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdviceAddDialog(Types.disease);
            },
          )
        },
      ),
      FabItemData(
        'Add new Body Part',
        Icons.add,
        onPress: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdviceAddDialog(Types.bodyPart);
            },
          )
        },
      ),
      FabItemData(
        'Add new Advice',
        Icons.add,
        onPress: () => {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdviceAddDialog(Types.advice);
            },
          )
        },
      ),
    ];
  }
}
