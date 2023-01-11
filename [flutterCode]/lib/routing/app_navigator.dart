import 'package:disease_application_bachelor_thesis/main.dart';
import 'package:disease_application_bachelor_thesis/routing/fade_route.dart';
import 'package:disease_application_bachelor_thesis/screens/advices/advice_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/details/detail_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/diagnoses/diagnoses_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/doctor_panel_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/doctorPanel/login/login_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/home/home_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/survey/survey_screen.dart';
import 'package:disease_application_bachelor_thesis/screens/survey/survey_screen_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Routes { survey, home, advices, doctorPanel, detailScreen, diagnosesList }

class _Paths {
  static const String survey = '/';
  static const String home = '/home';
  static const String advices = '/home/advices';
  static const String doctorPanel = '/home/doctorPanel';
  static const String detailScreen = '/home/detailScreen';
  static const String diagnosesList = '/home/items';

  static const Map<Routes, String> _pathMap = {
    Routes.home: _Paths.home,
    Routes.survey: _Paths.survey,
    Routes.advices: _Paths.advices,
    Routes.doctorPanel: _Paths.doctorPanel,
    Routes.detailScreen: _Paths.detailScreen,
    Routes.diagnosesList: _Paths.diagnosesList
  };

  static String of(Routes route) => _pathMap[route] ?? survey;
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Paths.survey:
        return FadeRoute(page: SurveyScreenFlutter());

      case _Paths.advices:
        return FadeRoute(page: AdviceScreen());

      case _Paths.doctorPanel:
        return FadeRoute(
          page: FirebaseAuth.instance.currentUser != null
              ? DoctorPanelScreen(title: "DoctorPanel")
              : LoginScreen(),
        );

      case _Paths.detailScreen:
        return FadeRoute(page: DetailScreen(null));

      case _Paths.diagnosesList:
        return FadeRoute(page: DiagnosesScreen());

      case _Paths.home:
      default:
        return FadeRoute(page: HomeScreen());
    }
  }

  static Future? push<T>(Routes route, [T? arguments]) =>
      state?.pushNamed(_Paths.of(route), arguments: arguments);

  static Future? replaceWith<T>(Routes route, [T? arguments]) =>
      state?.pushReplacementNamed(_Paths.of(route), arguments: arguments);

  static void pop() => state?.pop();

  static NavigatorState? get state => navigatorKey.currentState;
}
