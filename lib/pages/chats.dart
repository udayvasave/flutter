import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../connection/connection.dart';
class ChatPage extends StatefulWidget {
  var senderId;
  var chatusername;
  var chatuserProfile;


  ChatPage({this.senderId, this.chatusername, this.chatuserProfile});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {


  var from_user_id = '';
  _getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
     String? _user_id = prefs.getString('user_id');
     setState(() {
      from_user_id = _user_id!;           
    });
  }










  TextEditingController _messagetext = new TextEditingController();
  var currentLoginId = 22;
    bool Sendmessage_btn = true;
  List? MessageData;
fetchMessages() async {
  



  var messageUrl = Uri.parse(connection+"ChattingApp/fetch_chatting.php?from_user_id=$from_user_id&to_user_id="+widget.senderId);
  var response = await http.get(messageUrl);
      var data = json.decode(response.body);
     setState(() {
       MessageData = data;
     });
}


sendMessage() async {

  var sendMessageUrl = Uri.parse(connection+"ChattingApp/sendMessage.php");
  final response = await http.post(sendMessageUrl, body: {
    "from_user_id": from_user_id,
    "to_user_id": widget.senderId,
    "messagetext":_messagetext.text
  }).then((value){
   print(value);
   _messagetext.text = "";
   setState(() {
     Sendmessage_btn = true;
   });
  });



}









void _openBottomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 150,
        // Customize the modal content as per your needs
        child: Column(
          children: [
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                // Handle option 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                // Handle option 2
                Navigator.pop(context);
              },
            ),
            // Add more list tiles or other widgets as required
          ],
        ),
      );
    },
  );
}











@override
void initState() {
    // TODO: implement initState
    super.initState();
    fetchMessages();
    _getUserDetails();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
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
              child: Container(
                height: 500,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  reverse: true,
                  child: Container(
                    child: FutureBuilder(
                    future: fetchMessages(),
                      builder: (context, snapshot) {
                        
                      
                      return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount:MessageData == null ? 0 : MessageData!.length,
                      itemBuilder: (BuildContext context, int index) {                      
                                  
                        if('${MessageData![index]["from_user_id"]}' != from_user_id){
                          return GestureDetector(
                            onLongPress: (){
                              _openBottomModal(context);
                            },
                            child: BubbleSpecialThree(
                              text:  '${MessageData![index]["chat_message"]}',
                              color: Color(0xFFE8E8EE),
                              tail: false,
                              isSender: false,
                            ),
                          );
                        }
                        else{
                           return GestureDetector(
                            onLongPress: (){
                             _openBottomModal(context);
                            },
                             child: BubbleSpecialThree(
                              text:  '${MessageData![index]["chat_message"]}',
                              color: Color(0xFF1B97F3),
                              tail: true,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                              ),
                                                     ),
                           );
                        }
                                  
                                  
                                  
                                  
                                  
                                  
                             
                      });
                      }
                    ),
                  ),
                ),
              ),
            ),



          //  Container(
          //    child: MessageBar(
          //      onSend: (messagetext){
                 
          //        sendMessage(messagetext);
          //      },
          //      actions: [
          //        InkWell(
          //          child: Icon(
          //            Icons.add,
          //            color: Colors.black,
          //            size: 24,
          //          ),
          //          onTap: () {},
          //        ),
          //        Padding(
          //          padding: EdgeInsets.only(left: 8, right: 8),
          //          child: InkWell(
          //            child: Icon(
          //     Icons.camera_alt,
          //     color: Colors.green,
          //     size: 24,
          //            ),
          //            onTap: () {
              
          //            },
          //          ),
          //        ),
          //      ],
          //    ),
          //  ),




        // Container(
          
        //   width: double.infinity,
        //   height: 60,
        //   color: Colors.amber,
        //   child: Row(
        //     children: [
        //       Expanded(
        //         child: TextField(
        //           controller: _messagetext,
        //           decoration: InputDecoration(
        //             hintText: 'Type Message..'
        //           ),
        //         ),
        //       ),
        //       Expanded(child: IconButton(onPressed: (){
                // if(_messagetext.text != ''){
                // sendMessage();
                // }
        //       }, icon: Icon(Icons.send)))
        //     ],
        //   )),
        
 


Container(
            margin: const EdgeInsets.all(12.0),
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35.0),
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 2),
                            blurRadius: 7,
                            color: Colors.grey)
                      ],
                    ),
                        child: Row(
                          children: [
                            // moodIcon(),
                          IconButton(
                          icon: const Icon(
                            Icons.mood,
                            color: Color(0xFF00BFA5),
                          ),
                          onPressed: (){

                          },
                      ),
                         Expanded(
                          child: TextField(
                            controller: _messagetext,
                            onChanged: (value){
                              setState(() {
                                if(_messagetext.text != ''){
                                  Sendmessage_btn = false;
                                }
                                else{
                                  Sendmessage_btn = true;
                                }
                                
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Message",
                                hintStyle: TextStyle(color: Color(0xFF00BFA5)),
                                border: InputBorder.none),
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.attach_file, color: Color(0xFF00BFA5)),
                            onPressed: () {

                            },
                          ),

                       IconButton(
                          icon: const Icon(Icons.photo_camera, color: Color(0xFF00BFA5)),
                          onPressed: () {

                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration:  BoxDecoration(
                      color: Color(0xFF00BFA5), shape: BoxShape.circle),
                  child: Sendmessage_btn ? InkWell(
                    child: Icon(Icons.mic),
                    onLongPress: () {

                    },
                  ) : InkWell(
                    child: Icon(Icons.send),
                    onTap: () {
                    if(_messagetext.text != ''){
                    sendMessage();
                    }
                    },
                  ),
                )
              ],
            ),
          ),



          ],
       ));
  }
}