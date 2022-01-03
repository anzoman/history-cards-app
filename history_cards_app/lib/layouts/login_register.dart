import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:history_cards_app/controllers/authentication.dart';
import 'package:history_cards_app/controllers/storage.dart';
import 'package:history_cards_app/controllers/survey.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/layouts/navigation_home_screen.dart';
import 'package:history_cards_app/models/User.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen() {
    globals.authentication = Authentication();
    globals.dataStorage = DataStorage();
    globals.survey = Survey();
    globals.currentUser = null;
    globals.survey.jsonSurveySteps = [];
    globals.survey.questionIndex = 0;
  }

  Duration get loginTime => Duration(milliseconds: 3000);

  Future<String> _onLogin(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    bool authSuccess = await globals.authentication.login(data.name, data.password);
    User user = await globals.dataStorage.login(data.name);
    return Future.delayed(loginTime).then((_) {
      if (!authSuccess) {
        return 'Wrong email or password!';
      }
      globals.currentUser = user;
      return null;
    });
  }

  Future<String> _onRegister(SignupData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    bool authSuccess = await globals.authentication.register(data.name, data.password);
    User user = await globals.dataStorage.register(User(data.name, data.name, data.name, "", 0, 0));
    return Future.delayed(loginTime).then((_) {
      if (!authSuccess) {
        return 'Email exists or password is too weak!';
      }
      _onLogin(LoginData(name: data.name, password: data.password));
      return null;
    });
  }

  Future<String> _recoverPassword(String name) async {
    print('Name: $name');
    final Email email = Email(
      body: 'Vaše geslo je: lalala',
      subject: 'Pozabljeno geslo',
      recipients: ['$name'],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'VSTOPI!',
      onLogin: _onLogin,
      onSignup: _onRegister,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NavigationHomeScreen(),
        ));
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: () async {
            String username = await globals.authentication.signInWithGoogle();
            if (username != null) {
              bool usernameExists = await globals.dataStorage.usernameExists(username);
              User user = null;
              if (!usernameExists) {
                user = await globals.dataStorage.register(User(username, username, username, "", 0, 0));
              } else {
                user = await globals.dataStorage.login(username);
              }
              globals.currentUser = user;
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => NavigationHomeScreen(),
              ));
            } else {
              return 'Google sign in failed!';
            }
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.linkedinIn,
          label: 'LinkedIN',
          callback: () async {
            debugPrint('start linkdin sign in');
            await Future.delayed(loginTime);
            debugPrint('stop linkdin sign in');
            return null;
          },
        ),
        LoginProvider(
          icon: FontAwesomeIcons.githubAlt,
          label: 'GitHub',
          callback: () async {
            debugPrint('start github sign in');
            await Future.delayed(loginTime);
            debugPrint('stop github sign in');
            return null;
          },
        ),
      ],
      onRecoverPassword: _recoverPassword,
      messages: LoginMessages(
          userHint: 'Email',
          passwordHint: 'Geslo',
          confirmPasswordHint: 'Potrdi geslo',
          loginButton: 'PRIJAVA',
          signupButton: 'REGISTRACIJA',
          forgotPasswordButton: 'Pozabljeno geslo',
          recoverPasswordButton: 'POMOČ',
          goBackButton: 'NAZAJ',
          recoverPasswordDescription: "Vpišite svoj email in poslali vam bomo napotke.",
          recoverPasswordIntro: "Pozabljeno geslo?",
          recoverPasswordSuccess: "Email je bil uspešno poslan!",
          confirmPasswordError: 'Gesli se ne ujemata!',
          providersTitleFirst: "prijaviš se lahko tudi z"),
    );
  }
}
