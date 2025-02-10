import 'package:chattly/credentials/register.dart';
import 'package:chattly/utils/palettes.dart';
import 'package:chattly/views/landing.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../functions/loaders.dart';
import '../services/apis/auth.dart';
import '../services/routes.dart';
import '../utils/snackbars/snackbar_message.dart';
import '../widgets/material_button.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();
  bool _isPassword = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Image(
                    width: 320,
                    height: 320,
                    image: AssetImage("assets/logos/logo2_transparent.png"),
                  ),
                  Text("WELCOME BACK!",style: TextStyle(fontFamily: "bold",fontSize: 18,letterSpacing: 3),),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Keep your data safe",style: TextStyle(fontFamily: "regular"),),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(1000)
                    ),
                    child: TextField(
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20,right: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    child: TextField(
                      controller: _pass,
                      obscureText: !_isPassword,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: _isPassword ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                          onPressed: (){
                            setState(() {
                              _isPassword = !_isPassword;
                            });
                          },
                        )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _buttons.button(text: "Login", ontap: (){
                    if(_email.text.isEmpty || _pass.text.isEmpty){
                      _snackbarMessage.snackbarMessage(context, message: "All fields are required", is_error: true);
                    }else{
                      _screenLoaders.functionLoader(context);
                      DatabaseReference ref = FirebaseDatabase.instance.ref('users/');
                      ref.onValue.listen((DatabaseEvent event) async{
                        var temp = event.snapshot.value;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if(temp.toString().contains("email: ${_email.text}") && temp.toString().contains("password: ${_pass.text}")){
                          prefs.setString('email', _email.text);
                          prefs.setString('password', _pass.text);
                          authServices.getUser(email: _email.text).whenComplete((){
                            _routes.navigator_pushreplacement(context, Landing());
                          });
                        }else{
                          Navigator.of(context).pop(null);
                          _snackbarMessage.snackbarMessage(context, message: "Invalid credentials!", is_error: true);
                        }
                      });
                    }
                  },radius: 1000, isValidate: true),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Don't have an account?",style: TextStyle(fontFamily: "medium"),),
                      TextButton(
                        child: Text("Register",style: TextStyle(fontFamily: "semibold",color: palettes.primary)),
                        onPressed: (){
                          _routes.navigator_push(context, Register());
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
