import 'dart:convert';

import 'package:chatapp/auth/login.dart';
import 'package:chatapp/connection/connection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chats.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {

 List? userData;
  _showUsers() async{
      var url = Uri.parse(connection+"ChattingApp/fetch_users.php");
      var response = await http.get(url);
      var data = json.decode(response.body);
       var dir = await getTemporaryDirectory();
      await Hive.initFlutter(dir.path);
      var chatsdb = await Hive.openBox('chatsdb');
     setState(() {
      chatsdb.put('all_chats_users', data);
      var getdata =  chatsdb.get('all_chats_users');
       userData = data;       
     });
  }


  _fetchOffline() async {
    //  var dir = await getTemporaryDirectory();
    // await Hive.initFlutter(dir.path);
     var dir = await getApplicationDocumentsDirectory();
     Hive.init(dir.path);
  
    var chatsdb = await Hive.openBox('chatsdb');
    var getdata =  chatsdb.get('all_chats_users');
     setState(() {      
         userData = getdata;    
         print(userData);  
     });
  }

  _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_image');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }







  String? user_id = '';
  String? user_name = '';
  String? user_image = '';
  _getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _user_id = prefs.getString('user_id');
    final String? _user_name = prefs.getString('user_name');
    final String? _user_image = prefs.getString('user_image');
    setState(() {
      user_id = _user_id;
      user_name = _user_name;
      user_image = _user_image;

    });
  }




@override
void initState() {
    // TODO: implement initState
    super.initState();
     _fetchOffline();
    _showUsers();
    _getUserDetails();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text("ChatApp"),
        actions: [
          IconButton(onPressed: (){
             _logout();
             
          }, icon: Icon(Icons.location_on_outlined))
        ],
      ),
      // ****************************************Body*************************
      body: ListView.builder(
          itemCount: userData == null ? 0 : userData!.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                var senderId = "${userData![index]["user_id"]}";
                var chatusername = "${userData![index]["user_name"]}";
                var chatuserProfile = connection+"ChattingApp/profiles/${userData![index]["user_image"]}";
                print(senderId);
              
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(
                senderId:senderId, 
                chatusername:chatusername,
                chatuserProfile:chatuserProfile
                )));
              },
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(connection+'ChattingApp/profiles/${userData![index]["user_image"]}'),
                      radius: 21,
                    ),
                  ),
                  trailing:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                     CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.green,
                     ),
                    //  CircleAvatar(
                    //   radius: 5,
                    //   backgroundColor: Colors.red,
                    //  ),
                    ],
                  ),
                  title: Text("${userData![index]["user_name"]}", style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),),
            
                  subtitle: Text("Hi, How are you?"),
                  
                  
                  
                  ),
            );
          }),
    
    );
  }
}