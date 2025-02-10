import 'package:chattly/credentials/login.dart';
import 'package:chattly/models/auth.dart';
import 'package:chattly/services/routes.dart';
import 'package:chattly/widgets/material_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Routes _routes = new Routes();
  final Buttons _buttons = new Buttons();
  final List<String> _titles = ["User Profile","Delivery Address","Track Orders","Change Password","Notifications"];
  final List<String> _icons = ["edit_profile","delivery_address","tracking","change_password","notification"];
  bool _isNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(1000),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage("https://freesvg.org/img/abstract-user-flat-4.png")
                          )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("${authModel.loggedUser!["firstname"]} ${authModel.loggedUser!["lastname"]}",style: TextStyle(fontSize: 16,fontFamily: "semibold"),maxLines: 1, overflow: TextOverflow.ellipsis,),
                    SizedBox(
                      height: 5,
                    ),
                    Text(authModel.loggedUser!["email"],style: TextStyle(color: Colors.grey,fontFamily: "medium"),),
                  ],
                ),
                _buttons.button(text: "Logout", ontap: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  authModel.loggedUser = null;
                  _routes.navigator_pushreplacement(context, Login());
                },)
              ],
            ),
          ),
        )
    );
  }
}

