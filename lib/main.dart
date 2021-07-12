import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_login_model/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

const loginBoxName = "loginBox";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>(loginBoxName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();

  late Box<UserModel> userBox;
  bool isLoggedIn = false;
  String id = '';

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserModel>(loginBoxName);
    autoLogIn2();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   autoLogIn2();
  // }

  Future<void> autoLogIn2() async {
    var box = Hive.box('loginBox');
    String userId = box.get('id');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        id = userId;
      });
      return;
    }
  }

  Future<Null> logout2() async {
    var box = Hive.box('loginBox');
    box.delete('id');
    setState(() {
      id = '';
      isLoggedIn = false;
    });
  }

  Future<Null> loginUser2() async {
    var box = Hive.box('loginBox');

    box.put('id', 'Paul@gmail.com');

    setState(() {
      id = nameController.text;
      isLoggedIn = true;
    });

    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Login Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !isLoggedIn
                ? TextField(
                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Please enter your name'))
                : Text('You are logged in as $id'),
            SizedBox(height: 10.0),
            RaisedButton(
              onPressed: () {
                isLoggedIn ? logout2() : loginUser2();
              },
              child: isLoggedIn ? Text('Logout') : Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}