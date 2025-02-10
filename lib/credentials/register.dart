import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:chattly/credentials/login.dart';
import 'package:chattly/functions/loaders.dart';
import 'package:chattly/services/apis/auth.dart';
import 'package:chattly/utils/snackbars/snackbar_message.dart';
import 'package:flutter/material.dart';
import '../services/routes.dart';
import '../utils/palettes.dart';
import '../widgets/material_button.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _fname = new TextEditingController();
  final TextEditingController _lname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  final Buttons _buttons = new Buttons();
  final Routes _routes = new Routes();
  final ScreenLoaders _screenLoaders = new ScreenLoaders();
  final SnackbarMessage _snackbarMessage = new SnackbarMessage();
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
                    width: 280,
                    height: 280,
                    image: AssetImage("assets/logos/logo3_transparent.png"),
                  ),
                  Text("CREATE NEW ACCOUNT!",style: TextStyle(fontFamily: "bold",fontSize: 18),),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    child: TextField(
                      controller: _fname,
                      decoration: InputDecoration(
                        hintText: "Firstname",
                        hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(1000)
                    ),
                    child: TextField(
                      controller: _lname,
                      decoration: InputDecoration(
                        hintText: "Lastname",
                        hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                        isDense: false,
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
                  _buttons.button(text: "Register", ontap: (){
                    if(_email.text.isEmpty || _fname.text.isEmpty || _lname.text.isEmpty || _pass.text.isEmpty){
                      _snackbarMessage.snackbarMessage(context, message: "All fields are required", is_error: true);
                    }else{
                      // var appleInBytes = utf8.encode(_pass.text);
                      // Digest value = sha256.convert(appleInBytes);
                      _screenLoaders.functionLoader(context);
                      authServices.register(details: {
                        "firstname": _fname.text,
                        "lastname": _lname.text,
                        "email": _email.text,
                        "password": _pass.text,
                        "created_at": "${DateTime.now()}",
                      }).whenComplete((){
                        Navigator.of(context).pop(null);
                        _snackbarMessage.snackbarMessage(context, message: "Account has successfully created!");
                        _routes.navigator_push(context, Login());
                      });
                    }
                  },radius: 1000, isValidate: true),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Already have an account?",style: TextStyle(fontFamily: "medium"),),
                      TextButton(
                        child: Text("Login",style: TextStyle(fontFamily: "semibold",color: palettes.primary)),
                        onPressed: (){
                          _routes.navigator_push(context, Login());
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
