import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:mupit/Services/auth.dart';
import 'package:mupit/UI/Home.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void Go_to_Home(BuildContext context)
  {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage("Assets/Images/bg2.jpg"),
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: size.height * 0.3,
            left: size.width * 0.5 - 80,
            child: InkWell(
              onTap: () {
                AuthMethod().SignInWithGoogle(context);
              },

              child: ClayContainer(
                width: 160,
                height: 50,
                borderRadius: 30,
                depth: 20,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(0xfff7f7f7),
                          width: 2,
                          style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("Assets/Images/google.png")),
                      Text("Sign In" ,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 17,
                        fontWeight: FontWeight.w500
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
