import 'dart:ui';

import 'package:chattly/credentials/login.dart';
import 'package:chattly/services/routes.dart';
import 'package:chattly/views/landing.dart';
import 'package:chattly/widgets/material_button.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitHeight,
            image: NetworkImage("https://img.freepik.com/premium-vector/social-networks-dating-apps-vector-seamless-pattern_341076-469.jpg?semt=ais_hybrid")
          )
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Image(
                      image: AssetImage("assets/images/welcome2.png"),
                    ),
                  ),
                ),
              )
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text("Enjoy the new experience of chating with friends and family",style: TextStyle(fontFamily: "semibold",fontSize: 16),textAlign: TextAlign.center,),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Connect people with you love for free",style: TextStyle(fontFamily: "regular"),),
                    Spacer(),
                    _buttons.button(text: "Get Started", ontap: (){
                      _routes.navigator_pushreplacement(context, Login());
                    },radius: 1000, isValidate: true),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
