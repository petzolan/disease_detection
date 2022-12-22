import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatelessWidget {
  InformationScreen({super.key});
  final Uri _url = Uri.parse('https://github.com/petzolan/disease_detection');

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "This application was developed for a bachelor thesis of a student of the Technische Hochschule Ingolstadt.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "Until now, all of the medical data is based on data from the ApiMedic-API.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "The project's ultimate objective is the successful creation of a mobile application that enables users to receive a diagnosis based on the symptoms they reported, even if they were unable to schedule an appointment with a doctor, due to busy practices, or did not have the opportunity to see one, due to lack of time or long waiting times. This diagnosis is made after successful data gathering regarding the user's symptoms and a subsequent determination of the possible diseases. Another goal of the application is that the database can be expanded by doctors, whereby a verification possibility must be provided. They should be provided with the possibility to add either disease-related data or pieces of advice regarding diseases and illnesses for users.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              "The detailed information of how all of this was achieved can be found in the GitHub-Repositroy linked in the button below.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            // private atm

            CustomButton(_launchUrl, 'Go to GitHub'),

            const SizedBox(
              height: 25,
            ),
            const Text(
              "Special thanks are going out to Professor Doctor Apel who made the whole project possible and Jenny Hofbauer who kept me sane during the writing phase.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
