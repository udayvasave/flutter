import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../connection/connection.dart';

class NearByLocationPage extends StatefulWidget {
  const NearByLocationPage({super.key});

  @override
  State<NearByLocationPage> createState() => _NearByLocationPageState();
}

class _NearByLocationPageState extends State<NearByLocationPage> {

  List? userData;
  _showUsers() async{
      var url = Uri.parse(connection+"/ChattingApp/nearbyusers.php");
      var response = await http.get(url);
      var data = json.decode(response.body);
     setState(() {
       userData = data;
     });
  }



@override
void initState() {
    // TODO: implement initState
    super.initState();
     _showUsers();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[800],
        title: Text("NearBy Location"),
      ),      
      body: ListView.builder(
          itemCount:userData == null ? 0 : userData!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
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
                       Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.purple[800],
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text("Send Request", style: TextStyle(
                            color: Colors.white
                          ),),),
                        ),
                       )
                    ],
                  ),
                  title: Text("${userData![index]["user_name"]}", style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),),
            
                  subtitle: Text("Hi, How are you?"),
                  
                  
                  
                  );
          }),
    );
  }
}