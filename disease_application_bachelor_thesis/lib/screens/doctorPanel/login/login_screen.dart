import 'package:disease_application_bachelor_thesis/routing/app_navigator.dart';
import 'package:disease_application_bachelor_thesis/services/auth_service.dart';
import 'package:disease_application_bachelor_thesis/utils/app_variables.dart';
import 'package:disease_application_bachelor_thesis/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
          stringTitle: "Login",
          route: Routes.home,
        ),
        body: FlutterLogin(
          logo: const AssetImage('assets/images/login.png'),
          title: 'Please login to continue',
          theme: LoginTheme(
            switchAuthTextColor: AppVariables.lightBlue,
            primaryColor: Colors.white,
            accentColor: AppVariables.lightBlue,
            errorColor: AppVariables.lightBlue,
            footerBackgroundColor: AppVariables.lightBlue,
            bodyStyle: const TextStyle(color: Colors.black),
            titleStyle: const TextStyle(color: Colors.black, fontSize: 24),
            buttonTheme: LoginButtonTheme(
              backgroundColor: AppVariables.lightBlue,
            ),
            inputTheme: InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: AppVariables.lightBlue, width: 1.0),
              ),
            ),
            footerTextStyle: const TextStyle(color: Colors.black),
            cardTheme: CardTheme(
              elevation: 0,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
          ),
          onLogin: AuthService.instance.signIn,
          onSignup: AuthService.instance.registration,
          onConfirmRecover: AuthService.instance.resetPassword,
          onSubmitAnimationCompleted: (() {
            Navigator.of(context).pop();
            AppNavigator.push(Routes.doctorPanel);
          }),
          onRecoverPassword: (_) => Future(() => null),
          messages: LoginMessages(
            userHint: 'E-Mail',
            passwordHint: 'Password',
            confirmPasswordHint: 'Confirm',
            loginButton: 'LOG IN',
            signupButton: 'REGISTER',
            forgotPasswordButton: 'Forgot Password',
            recoverPasswordButton: 'Send restore code',
            goBackButton: 'GO BACK',
            confirmPasswordError: 'Passwords don\'t match',
            recoverPasswordDescription: 'Please enter your E-Mail',
            recoverPasswordSuccess: 'Password rescued successfully',
          ),
        )

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Expanded(
        //       child: ListView(
        //         padding: EdgeInsets.all(20.0),
        //         children: <Widget>[
        //           const Padding(
        //             padding: EdgeInsets.all(10),
        //             child: TextField(
        //               decoration: InputDecoration(
        //                   border: OutlineInputBorder(),
        //                   labelText: 'E-Mail',
        //                   hintText: 'Enter your E-Mail'),
        //             ),
        //           ),
        //           const Padding(
        //             padding: EdgeInsets.all(10),
        //             child: TextField(
        //               obscureText: true,
        //               decoration: InputDecoration(
        //                   border: OutlineInputBorder(),
        //                   labelText: 'Password',
        //                   hintText: 'Enter your password'),
        //             ),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               //TODO FORGOT PASSWORD SCREEN GOES HERE
        //             },
        //             child: const Text(
        //               'Forgot Password',
        //               style: TextStyle(color: Colors.blue, fontSize: 15),
        //             ),
        //           ),
        //           CustomButton(() {}, 'Login'),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
