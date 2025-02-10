import 'package:chattly/models/auth.dart';
import 'package:chattly/services/apis/chat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/palettes.dart';

class ViewChat extends StatefulWidget {
  final Map contact;
  ViewChat({required this.contact});
  @override
  State<ViewChat> createState() => _ViewChatState();
}

class _ViewChatState extends State<ViewChat> {
  var _chats = FirebaseDatabase.instance.ref().child('messages');
  final TextEditingController _message = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isSending = false;
  String _messageChecker = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          shadowColor: Colors.grey.shade200,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 18,
                backgroundImage: NetworkImage("https://freesvg.org/img/abstract-user-flat-4.png"),
                foregroundColor: Colors.grey.shade200,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${widget.contact["firstname"]} ${widget.contact["lastname"]}",style: TextStyle(fontSize: 15,fontFamily: "semibold"),maxLines: 1, overflow: TextOverflow.ellipsis,),
                  Text(widget.contact["email"],style: TextStyle(color: Colors.grey,fontFamily: "regular",fontSize: 13),)
                ],
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            StreamBuilder(
                stream: _chats.onValue,
                builder: (context, snapshot) {
                  List? datas;

                  if(snapshot.hasData){
                    if(snapshot.data!.snapshot.value != null){
                      datas = (snapshot.data!.snapshot.value as Map).values.toList().where((s) => s["receiver_email"] == widget.contact["email"] && s["sender_email"] == authModel.loggedUser!["email"] || s["sender_email"] == widget.contact["email"] && s["receiver_email"] == authModel.loggedUser!["email"]).toList();
                      datas.sort((a,b) {
                        return a["created_at"].compareTo(b["created_at"]);
                      });
                    }
                  }
                  return ListView(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 100),
                  children: [
                    if(_isSending)...{
                      _sendingChat(message: _messageChecker, photo: "")
                    },
                    if(datas != null)...{
                      for(int x = 0 ; x < datas.length; x++)...{
                        datas[datas.length - 1 - x]["sender_email"] == authModel.loggedUser!["email"] ?
                        _myChat(message: datas[datas.length - 1 - x]["message"], photo: "", date: datas[datas.length - 1 - x]["created_at"]) :
                        _otherChat(message: datas[datas.length - 1 - x]["message"], photo: "", date: datas[datas.length - 1 - x]["created_at"])
                      },
                    },
                    SizedBox(
                      height: 20,
                    ),
                    Center(child: Text("Start a conversation with ${widget.contact["firstname"]}.",style: TextStyle(fontFamily: "regular",fontSize: 13),)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 2; i++)
                          Align(
                            widthFactor: 0.6,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade50,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundImage: NetworkImage("https://freesvg.org/img/abstract-user-flat-4.png"),
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                );
              }
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    style: TextStyle(fontFamily: "regular"),
                    controller: _message,
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "Type here...",
                      hintStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                      labelStyle: TextStyle(fontFamily: "regular",color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.only(left: 5),
                        width: 70,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.grey.shade200)
                          )
                        ),
                        child: IconButton(
                          icon: Icon(Icons.send_rounded,size: 35,color: palettes.secondary,),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: (){
                            if(_message.text.isNotEmpty){
                              setState(() {
                                _isSending = true;
                                _messageChecker = _message.text;
                                _message.text = "";
                              });
                              chatServices.send(details: {
                                "sender": "${authModel.loggedUser!["firstname"]} ${authModel.loggedUser!["lastname"]}",
                                "sender_email": authModel.loggedUser!["email"],
                                "receiver": "${widget.contact["firstname"]} ${widget.contact["lastname"]}",
                                "receiver_email": widget.contact["email"],
                                "message": _messageChecker,
                                "created_at": "${DateTime.now()}",
                              }).whenComplete((){
                                setState(() {
                                  _isSending = false;
                                  _messageChecker = "";
                                });
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _sendingChat({required String message, required String photo}){
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          photo == "" ?
          SizedBox() :
          Container(
            constraints: BoxConstraints(maxWidth: 330),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            // margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: palettes.primary,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
            child: Image(
              image: NetworkImage(photo),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          message == "" ?
          SizedBox() :
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
                color: palettes.primary,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
            ),
            child: Text(message,style: TextStyle(fontFamily: "regular",color: Colors.white),),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Sending",style: TextStyle(fontFamily: "regular",fontSize: 11,color: Colors.grey),),
          ),
        ],
      ),
    );
  }

  Widget _myChat({required String message, required String photo, required String date}){
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          photo == "" ?
          SizedBox() :
          Container(
            constraints: BoxConstraints(maxWidth: 330),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            // margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: palettes.primary,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
            child: Image(
              image: NetworkImage(photo),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: message == "" ? 0 : 5,
          ),
          message == "" ?
          SizedBox() :
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              color: palettes.primary,
              borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
            ),
            child: Text(message,style: TextStyle(fontFamily: "regular",color: Colors.white),),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(DateFormat("h:mm a").format(DateTime.parse(date)),style: TextStyle(fontFamily: "regular",fontSize: 11,color: Colors.grey),),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  Widget _otherChat({required String message, required String photo, required String date}){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          photo == "" ?
          SizedBox() :
          Container(
            constraints: BoxConstraints(maxWidth: 330),
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            // margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5), bottomLeft: Radius.circular(5))
            ),
            child: Image(
              image: NetworkImage(photo),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: message == "" ? 0 : 5,
          ),
          message == "" ?
          SizedBox() :
          Container(
            constraints: BoxConstraints(maxWidth: 330),
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            // margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
            ),
            child: Text(message,style: TextStyle(fontFamily: "regular"),),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(DateFormat("h:mm a").format(DateTime.parse(date)),style: TextStyle(fontFamily: "regular",fontSize: 11,color: Colors.grey),),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
