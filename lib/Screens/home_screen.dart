import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/sign_in_provider.dart';
import 'package:flutter_auth/Screens/login_screen.dart';
import 'package:flutter_auth/utils/next_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getData() async {
    final sp = context.watch<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.grey,
            ),
            onPressed: () {
              sp.userSignout();
              nextScreen(context, const LoginScreen());
            },
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            backgroundImage: NetworkImage("${sp.imageurl}"),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
          //     child: ElevatedButton(
          //   onPressed: () {
          //     sp.userSignout();
          //     nextScreen(context, const LoginScreen());
          //   },
          //   child: Text('SIGNOUT'),
          // )
          ),
    );
  }
}
