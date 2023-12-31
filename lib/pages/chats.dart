import 'dart:convert';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../connection/connection.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  await Hive.initFlutter();
  // You can optionally register your Hive adapter classes here
  runApp(ChatPage());
}

class ChatPage extends StatefulWidget {
  var senderId;
  var chatusername;
  var chatuserProfile;


  ChatPage({this.senderId, this.chatusername, this.chatuserProfile});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isonline = true;

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
  var dir = await getTemporaryDirectory();
  await Hive.initFlutter(dir.path);
  var chatsdb = await Hive.openBox('chatsdb');
   var getdata =  chatsdb.get('chats'+widget.senderId);
   MessageData = getdata;
  
  _updateOnline();
  showStatus();
  var messageUrl = Uri.parse(connection+"ChattingApp/fetch_chatting.php?from_user_id=$from_user_id&to_user_id="+widget.senderId);
  var response = await http.get(messageUrl);
      var data = json.decode(response.body);
     setState(() {
        chatsdb.put('chats'+widget.senderId, data);
        var getdata =  chatsdb.get('chats'+widget.senderId);
       MessageData = getdata;
     });
}


sendMessage() async {
  var sendMessageUrl = Uri.parse(connection+"ChattingApp/sendMessage.php");
  final response = await http.post(sendMessageUrl, body: {
    "from_user_id": from_user_id,
    "to_user_id": widget.senderId,
    "messagetext":_messagetext.text
  }).then((value){
   print(value.body);
   _messagetext.text = "";
   setState(() {
     Sendmessage_btn = true;
   });
  });



}



var updateonlineurl = Uri.parse(connection+"/ChattingApp/update_online_or_offline.php");
_updateOnline() async {
    var response = await http.post(updateonlineurl,body:{
      "login_user_id": from_user_id
    }).then((value) {
      
    });
}

var showStatusUrl = Uri.parse(connection+'/ChattingApp/show_user_status.php');
 showStatus()async{
  var response = await http.post(showStatusUrl,body:{
      "sender_id": widget.senderId
    }).then((value) {
      print(value.body);
      if(value.body == '3'){
        setState(() {
            isonline = false;
        });
      }
      else{
        setState(() {
          isonline = true;
        });
      }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Row(
          children: [
            
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chatuserProfile),
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.chatusername),
                isonline ? Text("Online", style:TextStyle(fontSize: 14, color: Colors.green), textAlign: TextAlign.start) : 
                Text("Offline", style:TextStyle(fontSize: 14, color: Colors.red), textAlign: TextAlign.start,)
              ],
            ),
          ],
        ),
        
      ),
       body: Container(

        decoration: BoxDecoration(
          //image: DecorationImage(image: AssetImage('assets/chatbackground/chatbackground-doodle.jpg'),fit: BoxFit.cover)
        ),
         child: Column(
            children: [
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                
                              
                
                              // return GestureDetector(
                              //   onLongPress: (){
                              //     _openBottomModal(context);
                              //   },
                              //   child: Container(
                                  
                              //      constraints: BoxConstraints(minWidth: 50, maxWidth: 100),
                              //      decoration: BoxDecoration(
                              //       color: Colors.orange,
                              //       borderRadius: BorderRadius.circular(30)
                              //      ),
                              //      child: Text('${MessageData![index]["chat_message"]}'),
                                
                              //   ),
                                // child: BubbleSpecialThree(
                                //   text:  '${MessageData![index]["chat_message"]}',
                                //   color: Color.fromARGB(255, 173, 157, 70),// left
                                //   tail: false,
                                //   isSender: false,
                                // ),
                              // );
                
                              //  return  BubbleSpecialThree(
                              //     text:  '${MessageData![index]["chat_message"]}\n${MessageData![index]["chat_message"]}',
                              //     color: Color.fromARGB(255, 173, 157, 70),// left
                              //     tail: false,
                              //     isSender: false,
                                  
                              //   );
                
                                return   GestureDetector(
                                  onLongPress: (){
                                    _openBottomModal(context);
                                  },
                                  child: ChatBubble(
                                                    clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
                                                    backGroundColor: Color(0xffE7E7ED),
                                                    margin: EdgeInsets.only(top: 20),
                                                    child: Container(
                                                      constraints: BoxConstraints(
                                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                                      ),
                                                      child: Text(
                                                        '${MessageData![index]["chat_message"]}',
                                                        style: TextStyle(color: Color(0xFFE8E8EE)),
                                                      ),
                                                    ),
                                                  ),
                                );
                
                             
                
                
                
                
                
                
                
                
                            }
                            else{
                              //  return GestureDetector(
                              //   onLongPress: (){
                              //    _openBottomModal(context);
                              //   },
                              //    child: BubbleSpecialThree(
                              //     text:  '${MessageData![index]["chat_message"]}',
                              //     color: Color(0xFF1B97F3),//right
                              //     tail: true,
                              //     textStyle: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 16
                              //     ),
                              //                            ),
                              //  );

                              return   ChatBubble(
         clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 20),
        backGroundColor: Colors.blue,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            style: TextStyle(color: Colors.white),
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
          
        
       
       // Write message Text Field
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
         ),
       ));
  }
}