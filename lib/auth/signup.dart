import 'package:chatapp/connection/connection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import '../navigator/navigation.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

TextEditingController _username = new TextEditingController();
TextEditingController _email = new TextEditingController();
TextEditingController _mobile = new TextEditingController();
TextEditingController _password= new TextEditingController();
TextEditingController _confirmpass= new TextEditingController();
TextEditingController _dob = new TextEditingController();
// TextEditingController _gender = new TextEditingController();
DateTime? selectedDate;

var _gender = '';
bool ismale = true;
bool isfemale = true;
bool isother = true;



Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        
        selectedDate = picked;
          print(selectedDate);
         
          var date = DateTime.parse(picked.toString());
          // var formattedDate = "${date.day}-${date.month}-${date.year}";
          var formattedDate = "${date.year}-${date.month}-${date.day}";

          _dob.text = formattedDate;
      });
    }
  }












var sendOtp = Uri.parse(connection+'/ChattingApp/sendotp.php');
_sendotp() async {

  if(_username.text == '' || _email.text == '' || _mobile.text == '' || _dob.text == '' || _password.text == '' || _confirmpass.text == ''){
     Fluttertoast.showToast(
        msg: "All field are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  else if(_gender == ''){
         Fluttertoast.showToast(
        msg: "Please Select Gender",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  else if(_password.text.length <= 7){
     Fluttertoast.showToast(
        msg: "Password should be at least 8 char long",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  else if(_password.text != _confirmpass.text){
     Fluttertoast.showToast(
        msg: "Password doen't matched",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  else{
  var response = await http.post(sendOtp, body: {
    "mobile":_mobile.text,
    "email":_email.text
  }).then((value){
    print(value.body);
    if(value.body == '1'){
      Fluttertoast.showToast(
        msg: "Mobile already Registered",
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
        msg: "Email already Registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyOTPpgae(
        resOtp:value.body,
        username:_username.text,
        email:_email.text,
        mobile:_mobile.text,
        password:_password.text,
        dob:_dob.text,
        gender:_gender
        
        
        
        )));
    }


  });

  }
  //
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Create a new Account"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
      
      
      
              Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                controller: _username,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  prefixIcon: Icon(Icons.person_outline_outlined)
                ),
              ),
             ),
      
              Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  prefixIcon: Icon(Icons.email_outlined)
                ),
              ),
             ),
      
              Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                keyboardType: TextInputType.phone,
                controller: _mobile,
                decoration: InputDecoration(
                  hintText: 'Enter Your Mobile',
                  prefixIcon: Icon(Icons.phone)
                ),
              ),
             ),
      
      
              Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                readOnly: true,
                onTap: (){
                  _selectDate(context);
                },
                controller: _dob,
                decoration: InputDecoration(
                  hintText: 'Select Date of Birth',
                  prefixIcon: Icon(Icons.date_range)
                ),
              ),
             ),
      
              Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: Container(
                width: double.infinity,
                child: Text("Select Gender"))
              
             ),
      
            



            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [


                   ismale ? GestureDetector(
                    onTap: (){
                      setState(() {
                        ismale = false;
                        isfemale = true;
                        isother = true;
                        _gender = 'Male';
                      });
                    },
                     child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.blueGrey,
                      child: Center(child: Text("Male", style: TextStyle(color: Colors.white),)),
                     ),
                   ) : GestureDetector(
                    onTap: (){
                       setState(() {
                        // ismale = true;
                        // isfemale = true;
                        // isother = true;
                      });
                    },
                     child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.purple,
                      child: Center(child: Text("Male", style: TextStyle(color: Colors.white),)),
                     ),
                   ),



                  isfemale ?   GestureDetector(
                      onTap: (){
                        setState(() {
                          isfemale = false;
                          ismale = true;
                          isother = true;
                           _gender = 'Female';
                        });
                      },
                      child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.blueGrey,
                      child: Center(child: Text("Female", style: TextStyle(color: Colors.white),)),
                                       ),
                    ) : GestureDetector(
                      onTap: (){
                        setState(() {
                          //isfemale = true;
                        });
                      },
                      child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.purple,
                      child: Center(child: Text("Female", style: TextStyle(color: Colors.white),)),
                                       ),
                    ),




                    isother ? GestureDetector(
                      onTap: (){
                         setState(() {
                          isother = false;
                          ismale = true;
                          isfemale = true;
                           _gender = 'Other';
                       });
                      },
                      child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.blueGrey,
                      child: Center(child: Text("Other", style: TextStyle(color: Colors.white),)),
                                       ),
                    ) : GestureDetector(
                      onTap: (){
                       setState(() {
                          //isother = true;
                       });
                      },
                      child: Container(
                      width: 80,
                      height: 40,
                      color: Colors.purple,
                      child: Center(child: Text("Other", style: TextStyle(color: Colors.white),)),
                                       ),
                    )
                ],
              ),
            ),















      
      
                 Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                controller: _password,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  prefixIcon: Icon(Icons.lock)
                ),
              ),
             ),
      
                 Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextField(
                controller: _confirmpass,
                decoration: InputDecoration(
                  hintText: 'Enter Confirm Password',
                  prefixIcon: Icon(Icons.lock)
                ),
              ),
             ),
      
         
      
      
      
                Padding(
             padding: const EdgeInsets.only(left: 28, right: 28, top: 40),
              child: GestureDetector(
                onTap: (){
                   _sendotp();
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.purple[700]
                  ),
                  child: Center(
                    child: Text("Send OTP", style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    ),),
                  ),
                ),
              ),
            
            ),
      
      
      
      
            ],
          ),
        ),
      ),
    );
  }
}


class VerifyOTPpgae extends StatefulWidget {
  var resOtp;
  var username;
  var email;
  var mobile;
  var password;
  var dob;
  var gender;

  VerifyOTPpgae({this.resOtp, this.username, this.dob, this.email, this.gender, this.mobile, this.password});

  @override
  State<VerifyOTPpgae> createState() => _VerifyOTPpgaeState();
}

class _VerifyOTPpgaeState extends State<VerifyOTPpgae> {

  _verifyOtp(pin){
    if(widget.resOtp == pin){
       _signup();
    }
    else{
       Fluttertoast.showToast(
        msg: "Wrong Otp",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    }
  }

_signup() async{
  var SignupLink = Uri.parse(connection+'ChattingApp/singup.php');
  var res = await http.post(SignupLink, body: 
  {
    "username": widget.username,
    "emailid":widget.email,
    "mobile":widget.mobile,
    "password":widget.password,
    "gender":widget.gender,
    "dob":widget.dob
  }).then((value) async {
     if(value.body == '0'){
        Fluttertoast.showToast(
        msg: "Please try again later!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
     }
     else{          
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('user_id', value.body);
       await prefs.setString('user_name', widget.username);
       await prefs.setString('user_image', '');
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationBarPage()));
     }
  });

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Verify OTP"),
      ),

      body: Container(
        child: Column(
          children: [

                SizedBox(height: 100,),

                OTPTextField(
                length: 5,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 80,
                style: TextStyle(
                fontSize: 17
                ),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) {
                     print("Completed: " + pin);
                     _verifyOtp(pin);
                },
                ),



                 Padding(
             padding: const EdgeInsets.only(left: 28, right: 28, top: 80),
              child: GestureDetector(
                onTap: (){
                  var otp = '';
                   _verifyOtp(otp);
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.purple[700]
                  ),
                  child: Center(
                    child: Text("Verify OTP", style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                    ),),
                  ),
                ),
              ),
            
            ),
      



          ],
        ),
      ),
    );
  }
}




