import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/internet_provider.dart';
import 'package:flutter_auth/Provider/sign_in_provider.dart';
import 'package:flutter_auth/Screens/home_screen.dart';
import 'package:flutter_auth/utils/snack_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utils/config.dart';
import '../utils/next_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController facebookController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40, right: 40, top: 90, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image: AssetImage(Config.app_icon),
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Well come to Flutter Auth API APP",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Text(
                        "Authentication with Provider",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      )
                    ],
                  )),
              //rounded button
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundedLoadingButton(
                    controller: googleController,
                    successColor: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    onPressed: () {
                      handlingGoogleSign();
                    },
                    child: const Wrap(
                      children: [
                        Icon(
                          FontAwesomeIcons.google,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign in with Google',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      ],
                    ),
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RoundedLoadingButton(
                    controller: facebookController,
                    successColor: Colors.blue,
                    width: MediaQuery.of(context).size.width * 0.80,
                    elevation: 0,
                    borderRadius: 25,
                    onPressed: () {
                      handleFacebookAuth();
                      print('facebook clicked');
                    },
                    child: const Wrap(
                      children: [
                        Icon(
                          FontAwesomeIcons.facebook,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Sign in with FaceBook',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white),
                        )
                      ],
                    ),
                    color: Colors.blue,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //handling google signin

  Future handlingGoogleSign() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your internet Connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.red),
                googleController.reset()
              }
            else
              {
                // checking weather user exsisting or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    // user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignin();
                            })));
                  } else {
                    // user doest not exists
                    sp.saveDataToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              googleController.success();
                              handleAfterSignin();
                            })));
                  }
                })
              }
          });
    }
    // internet provider
  }

  //handling facebook signin

  Future handleFacebookAuth() async {
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, "Check your internet Connection", Colors.blue);
      facebookController.reset();
    } else {
      await sp.signInWithFacebook().then((value) => {
            if (sp.hasError == true)
              {
                openSnackbar(context, sp.errorCode, Colors.blue),
                facebookController.reset()
              }
            else
              {
                // checking weather user exsisting or not
                sp.checkUserExists().then((value) async {
                  if (value == true) {
                    // user exists
                    await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              facebookController.success();
                              handleAfterSignin();
                            })));
                  } else {
                    // user doest not exists
                    sp.saveDataToFirestore().then((value) => sp
                        .saveDataToSharedPreferences()
                        .then((value) => sp.setSignIn().then((value) {
                              facebookController.success();
                              handleAfterSignin();
                            })));
                  }
                })
              }
          });
    }
    // internet provider
  }

  //handel after signin
  handleAfterSignin() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, const HomeScreen());
    });
  }
}
