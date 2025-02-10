import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chattly/services/network.dart';

class ChatServices{
  // SENDING MESSAGE
  Future send({required Map details})async{
    try{
      final url = Uri.parse('${networkUtils.networkUtils}/messages.json');
      await http.post(
        url,
        body: json.encode(details),
      ).then((data){
        var respo = json.decode(data.body);
        print("SEND ${respo}");
      });
    }catch(e){
      print("ERROR SEND $e");
    }
  }
}
final ChatServices chatServices = new ChatServices();