import 'package:chattly/views/home/view_chat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../../models/auth.dart';
import '../../services/routes.dart';
import '../../utils/palettes.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Routes _routes = new Routes();
  var _users = FirebaseDatabase.instance.ref().child('users');
  var _chats = FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController _search = new TextEditingController();
  bool _isScrolling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        shadowColor: Colors.grey,
        title: Text("Dashboard",style: TextStyle(fontFamily: "bold",fontSize: 18),),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle,size: 30,),
            onPressed: (){},
          ),
          SizedBox(
            width: 10,
          )
        ],
        // flexibleSpace: Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        //   child: TextField(
        //     style: TextStyle(fontFamily: "regular"),
        //     textAlignVertical: TextAlignVertical.center,
        //     decoration: InputDecoration(
        //         counterText: "",
        //         border: InputBorder.none,
        //         hintText: "Search",
        //         hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
        //         labelStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
        //         enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.grey.shade200),
        //             borderRadius: BorderRadius.circular(5)
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: Colors.grey.shade200),
        //             borderRadius: BorderRadius.circular(5)
        //         ),
        //         prefixIcon: Icon(Icons.search,color: Colors.grey,)
        //     ),
        //     controller: _search,
        //   ),
        // ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.idle) {
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _isScrolling = false;
              });
            });
          }else{
            setState(() {
              _isScrolling = true;
            });
          }
          return true;
        },
        child: StreamBuilder(
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
                return datas![datas.length - 1 - index]["email"] == authModel.loggedUser!["email"] ? SizedBox() :
                StreamBuilder(
                    stream: _chats.onValue,
                    builder: (context, snapshot) {
                      List? messages;

                      if(snapshot.hasData){
                        if(snapshot.data!.snapshot.value != null){
                          messages = (snapshot.data!.snapshot.value as Map).values.toList().where((s) => s["receiver_email"] == datas![datas.length - 1 - index]["email"] && s["sender_email"] == authModel.loggedUser!["email"]).toList();
                          messages.sort((a,b) {
                            return a["created_at"].compareTo(b["created_at"]);
                          });
                        }
                      }
                      return messages == null ? SizedBox() : messages!.isEmpty ? SizedBox() : Card(
                      margin: EdgeInsets.only(top: 2),
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
                        title: Text("${datas![datas.length - 1 - index]["firstname"]} ${datas[datas.length - 1 - index]["lastname"]}",style: TextStyle(fontFamily: "semibold",fontSize: 14),),
                        subtitle: Text("${messages[messages.length - 1]["message"]}",maxLines: 1, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: "regular",fontSize: 13)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(DateFormat("h:mm a").format(DateTime.parse(messages[messages.length - 1]["created_at"])),style: TextStyle(fontFamily: "regular"),),
                          ],
                        ),
                        onTap: (){
                          _routes.navigator_push(context, ViewChat(contact: datas![datas.length - 1 - index],));
                        },
                      ),
                    );
                  }
                );
              },
            );
          }
        ),
      ),
    );
  }
}
