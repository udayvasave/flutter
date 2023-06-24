import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
class ChatPage extends StatefulWidget {
  var senderId;
  var chatusername;
  var chatuserProfile;
  ChatPage({this.senderId, this.chatusername, this.chatuserProfile});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var currentLoginId = 22;
  List? MessageData;
fetchMessages() async {
  var messageUrl = Uri.parse("http://192.168.245.116/ChattingApp/fetch_chatting.php");
  var response = await http.get(messageUrl);
      var data = json.decode(response.body);
     setState(() {
       MessageData = data;
     });
}


@override
void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessages();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chatuserProfile),
            ),
            SizedBox(width: 10,),
            Text(widget.chatusername),
          ],
        ),
      ),
       body: Column(
          children: [
            
            Expanded(
              child: ListView.builder(
              itemCount:MessageData == null ? 0 : MessageData!.length,
              itemBuilder: (BuildContext context, int index) {                      

                if('${MessageData![index]["from_user_id"]}' != '22'){
                  return BubbleSpecialThree(
                    text:  '${MessageData![index]["chat_message"]}',
                    color: Color(0xFFE8E8EE),
                    tail: false,
                    isSender: false,
                  );
                }
                else{
                   return BubbleSpecialThree(
                    text:  '${MessageData![index]["chat_message"]}',
                    color: Color(0xFF1B97F3),
                    tail: true,
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  );
                }






         
              }),
            ),
           MessageBar(
    onSend: (_) => print(_),
    actions: [
      InkWell(
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 24,
        ),
        onTap: () {},
      ),
      Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: InkWell(
          child: Icon(
            Icons.camera_alt,
            color: Colors.yellow[300],
            size: 24,
          ),
          onTap: () {},
        ),
      ),
    ],
  ),
          ],
       ));
  }
}