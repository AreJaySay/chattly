import 'dart:convert';
import 'package:chattly/models/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:chattly/services/network.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices{
  // REGISTER
  Future register({required Map details})async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/users.json');
      await http.post(
        url,
        body: json.encode(details),
      ).then((data){
        var respo = json.decode(data.body);
        print("REGISTER ${respo}");
      });
    }catch(e){
      print("ERROR REGISTER $e");
    }
  }

  // GET LOGGED USER
  Future getUser({required String email}) async {
    FirebaseDatabase.instance.ref().child('users').orderByChild("email").equalTo(email).onChildAdded.forEach((event)async{
      authModel.loggedUser = event.snapshot.value as Map?;
      print(event.snapshot.value);
    });
  }
}
final AuthServices authServices = new AuthServices();