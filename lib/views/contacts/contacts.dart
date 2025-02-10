import 'package:chattly/models/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../services/routes.dart';
import '../../utils/palettes.dart';
import '../home/view_chat.dart';

class Contacts extends StatefulWidget {
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  var _users = FirebaseDatabase.instance.ref().child('users');
  final Routes _routes = new Routes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey,
        title: Text("My Contacts",style: TextStyle(fontFamily: "bold",fontSize: 18),),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle,size: 30,),
            onPressed: (){},
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: StreamBuilder(
          stream: _users.onValue,
          builder: (context, snapshot) {
            List? datas;

            if(snapshot.hasData){
              if(snapshot.data!.snapshot.value != null){
                datas = (snapshot.data!.snapshot.value as Map).values.toList();
                datas.sort((a,b) {
                  return a["created_at"].compareTo(b["created_at"]);
                });
              }
            }
            return datas == null ?
            Center(
              child: CircularProgressIndicator(color: palettes.secondary,),
            ) : ListView.builder(
            itemCount: datas.length,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, index){
              return datas![index]["email"] == authModel.loggedUser!["email"] ? SizedBox() : Card(
                margin: EdgeInsets.only(top: 5),
                shadowColor: Colors.grey.withOpacity(0.3),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("https://freesvg.org/img/abstract-user-flat-4.png"),
                    foregroundColor: Colors.grey.shade200,
                  ),
                  title: Text("${datas[index]["firstname"]} ${datas[index]["lastname"]}",style: TextStyle(fontFamily: "semibold",fontSize: 14),),
                  subtitle: Text(datas[index]["email"],maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "regular",fontSize: 13)),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: (){
                    _routes.navigator_push(context, ViewChat(contact: datas![index],));
                  },
                ),
              );
            },
          );
        }
      ),
    );
  }
}
