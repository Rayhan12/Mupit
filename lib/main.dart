
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mupit/Color_Ex.dart';
import 'package:mupit/Services/auth.dart';
import 'package:mupit/UI/Home.dart';
import 'package:mupit/UI/Sign_In.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(new MaterialApp(
    home: FutureBuilder(
      future: AuthMethod().getCurrentUser(),
      builder: (context , AsyncSnapshot<dynamic>snapshot){
        if(snapshot.hasData)
          {
            return Home();
          }
        else
          {
            return SignIn();
          }
      },
    ),
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      // primaryColor: Ex_Color.primary,
      // accentColor: Ex_Color.secondary,
      // primarySwatch: Ex_Color.primary,
      // scaffoldBackgroundColor: Ex_Color.background
    ),

  ));
}

