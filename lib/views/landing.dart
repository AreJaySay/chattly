import 'package:chattly/services/apis/auth.dart';
import 'package:chattly/utils/palettes.dart';
import 'package:chattly/views/contacts/contacts.dart';
import 'package:chattly/views/home/home.dart';
import 'package:chattly/views/profile/profile.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<Widget> _pages = [Contacts(), Home(), Profile()];
  int _index = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {
          setState(() {
            _index = 1;
          });
        },
        child: Image(
          image: AssetImage("assets/logos/logo3_transparent.png"),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        height: 60,
        shape: const CircularNotchedRectangle(),
        color: palettes.secondary,
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Image(
                width: 23,
                height: 23,
                color: _index == 0 ? Colors.white : Colors.grey,
                image: AssetImage("assets/icons/contacts.png"),
              ),
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
            ),
            IconButton(
              icon: Image(
                width: 23,
                height: 23,
                color: _index == 2 ? Colors.white : Colors.grey,
                image: AssetImage("assets/icons/user.png"),
              ),
              onPressed: () {
                setState(() {
                  _index = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
