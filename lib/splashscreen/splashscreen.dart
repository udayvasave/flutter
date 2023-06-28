import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login.dart';
import '../navigator/navigation.dart';
import '../pages/home.dart';
import '../pages/nearby.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplasState();
}

class _SplasState extends State<Splashscreen> {
  _splashscreen() async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _user_id = prefs.getString('user_id');
   
     
    Timer(Duration(seconds: 8), () { 

       if(_user_id != null){
           //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NavigationBarPage()));
       }
       else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
       }


     
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashscreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SvgPicture.asset("assets/splshscreen/Splash_Screen_Dating_App2.svg",fit: BoxFit.cover,),
      
        
      ),
    );
  }
}