import 'package:chattly/credentials/login.dart';
import 'package:chattly/services/apis/auth.dart';
import 'package:chattly/services/routes.dart';
import 'package:chattly/utils/palettes.dart';
import 'package:chattly/views/landing.dart';
import 'package:chattly/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBd27d4bZiPHQJySGawhEWcu3M_LAeAQNk",
      appId: "1:18644924514:android:276a158abfbf5c7aa3793b",
      databaseURL: 'https://chattly-6e9e0-default-rtdb.firebaseio.com',
      messagingSenderId: "18644924514",
      projectId: "chattly-6e9e0",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Chattly',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Routes _routes = new Routes();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 1), () async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email').toString();
      String pass = prefs.getString('password').toString();
      if(email != "" && pass != ""){
        DatabaseReference ref = FirebaseDatabase.instance.ref('users/');
        ref.onValue.listen((DatabaseEvent event) async{
          var temp = event.snapshot.value;
          if(temp.toString().contains("email: $email") && temp.toString().contains("password: $pass")){
            authServices.getUser(email: email).whenComplete((){
              _routes.navigator_pushreplacement(context, Landing());
            });
          }else{
            _routes.navigator_pushreplacement(context, Login());
          }
        });
      }else{
        _routes.navigator_pushreplacement(context, Welcome());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                width: 320,
                image: AssetImage("assets/logos/logo1_transparent.png"),
              ),
              SizedBox(
                height: 80,
              ),
              CircularProgressIndicator(color: palettes.secondary,)
            ],
          ),
        )
    );
  }
}
