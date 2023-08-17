import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/Provider/sign_in_provider.dart';
import 'package:flutter_auth/Screens/login_screen.dart';
import 'package:flutter_auth/Screens/product_details.dart';
import 'package:flutter_auth/models/data_model.dart';
import 'package:flutter_auth/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  Future getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _getData();
  }

  DataModel? dataFromAPI;

  _getData() async {
    try {
      String url = "https://dummyjson.com/products";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = DataModel.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<SignInProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Center(
            child: Text(
              "${sp.email}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.grey,
            ),
            onPressed: () {
              showDialog(
                  builder: (context) {
                    return AlertDialog(
                        title: const Text("Logout"),
                        content: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.1, // Adjust the value as needed
                          ),
                          child: Column(children: [
                            const Text("Do you Really want to logout?"),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                      child: const Text("Logout"),
                                      onPressed: () {
                                        sp.userSignout();
                                        nextScreen(
                                            context, const LoginScreen());
                                      })
                                ])
                          ]),
                        ));
                  },
                  context: context);
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    dataFromAPI!.products[index].thumbnail,
                    width: 100,
                  ),
                  title: Text(dataFromAPI!.products[index].title.toString()),
                  subtitle: Text(
                    "\$${dataFromAPI!.products[index].price.toString()}",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // TODO:

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                                product: dataFromAPI!.products[index],
                              )),
                    );
                  }, // Navigate to detail page
                );
              },
              itemCount: dataFromAPI!.products.length,
            ),
    );
  }
}
