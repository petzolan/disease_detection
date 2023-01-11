import 'package:disease_application_bachelor_thesis/screens/survey/survey_screen.dart';
import 'package:disease_application_bachelor_thesis/utils/app_images.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/routing/categories/categories.dart';
import 'package:disease_application_bachelor_thesis/routing/categories/category.dart';
import 'package:disease_application_bachelor_thesis/widgets/category_card.dart';
import 'package:disease_application_bachelor_thesis/widgets/custom_button.dart';
import 'package:disease_application_bachelor_thesis/widgets/dotted_background.dart';
import 'package:flutter/material.dart';

class HeaderCardContent extends StatelessWidget {
  
  void _onSelectCategory(Category category) {
    AppNavigator.push(category.route);
  }

  static const double _fractionWidth = 0.25;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.9;

    return SafeArea(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: DottedBackground(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTitle(context),
              _buildCategories(context),
              const Text(
                "For more informations regarding the bachelor thesis, please scroll down.",
                style: TextStyle(fontSize: 10, color: Colors.grey),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints.expand(),
        padding: EdgeInsets.all(28),
        alignment: Alignment.bottomLeft,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: AppImages.logo,
                width: MediaQuery.of(context).size.width * _fractionWidth,
                height: MediaQuery.of(context).size.width * _fractionWidth,
                color: Colors.grey.shade300,
              ),
              const Text(
                'Hey, how are you feeling today?',
                style: TextStyle(
                  fontSize: 22,
                  height: 1.4,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Let\'s check in with your health.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ElevatedButton(
                onPressed: () => {
                  AppNavigator.push(Routes.survey)
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
                child: Text(
                  "Start new Diagnosis",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(28, 42, 28, 62),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: CategoryCard(
            categories[index],
            onPress: () => _onSelectCategory(categories[index]),
          ),
        );
      },
    );
  }
}
