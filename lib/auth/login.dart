import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../connection/connection.dart';
import '../pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();








 var loginUrl = Uri.parse(connection+"ChattingApp/login.php");
 _login() async { 
final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = _username.text;
    var password = _password.text;
   var response = await http.post(loginUrl, body: {
     "username":username,
     "password":password,
   }).then((value) async {
    
    if(value.body == '0'){
      Fluttertoast.showToast(
        msg: "User does not exist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
    else if(value.body == '2'){
       Fluttertoast.showToast(
        msg: "Wrong Password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
    else{
    
      
       var parsedata = json.decode(value.body);
        await prefs.setString('user_id', parsedata['user_id']);
        await prefs.setString('user_name', parsedata['user_name']);
        await prefs.setString('user_name', parsedata['user_image']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

    }


   });


 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
         children: [
          SizedBox(height: 80,),
          Text("Login", style: TextStyle(fontSize: 40),),


          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
            child: TextField(
              controller: _username,
              decoration: InputDecoration(
                hintText: 'Username',
                prefixIcon: Icon(Icons.person)
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
            child: TextField(
              controller: _password,
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock)
              ),
            ),
          ),


          Padding(
           padding: const EdgeInsets.only(left: 28, right: 28, top: 40),
            child: GestureDetector(
              onTap: (){
                 _login();
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.purple[700]
                ),
                child: Center(
                  child: Text("Login", style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                  ),),
                ),
              ),
            ),
          
          )



         ],
       ),
    );
  }
}