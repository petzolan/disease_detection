import 'dart:math';

import 'package:disease_application_bachelor_thesis/firebase_options.dart';
import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     FirebaseAuth.instance.signOut();
    return MaterialApp(
      color: Colors.white,
      title: 'Symptom Checker',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateRoute: AppNavigator.onGenerateRoute,
      builder: (context, child) {
        if (child == null) return SizedBox.shrink();

        final data = MediaQuery.of(context);
        final smallestSize = min(data.size.width, data.size.height);
        final textScaleFactor = min(smallestSize / 30, 1.0);

        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: child,
        );
      },
    );
  }
}
