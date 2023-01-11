import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdviceScreen extends StatefulWidget {
  const AdviceScreen({super.key});

  @override
  State<AdviceScreen> createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        stringTitle: "Advices",
        route: Routes.home,
      ),
      body: FutureBuilder<List<Advice>>(
        future: DatabaseService.instance.retrieveAdvices(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            // Check the status here
            return Center(child: CircularProgressIndicator());
          }
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            primary: false,
            shrinkWrap: true,
            children: List<Widget>.generate(
              snapshot.data.length, // same length as the data
              (index) => Text(
                snapshot
                    .data[index].name, // Use the fullName property of each item
              ),
            ),
          );
        },
      ),
    );
  }
}
