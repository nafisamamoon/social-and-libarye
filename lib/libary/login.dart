import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:soci/libary/admin-bar.dart';
import 'package:soci/libary/admin-home.dart';
import 'package:soci/libary/user-bar.dart';
import 'package:soci/libary/global.dart';
import 'package:soci/libary/one-login-service.dart';
import 'package:soci/libary/register.dart';
import 'package:soci/libary/user-home.dart';
class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
 bool circular=false;
  var i;
  @override
 void initState() {
   read();
     //TODO: implement initState
    super.initState();
  }
   var status;
   String _email = '';
  String _password = '';
  loginPressed() async {
    
    if (_email.isNotEmpty && _password.isNotEmpty) {
      http.Response response = await OneLoginServices.login(_email, _password);
      status=response.body.contains('error');
      Map responseMap = jsonDecode(response.body);
     
      //var id=responseMap["user"]["id"];
      if (response.statusCode == 200) {
         setState(() {
          circular=false;
        });
     
           save(responseMap['token']);
           // i=responseMap['role_id'];
            //saveRole(responseMap['role_id']);
            saveId(responseMap['id']);
          // print(i);
           getRoleId(responseMap['id']);
           
      
      } else {
        setState(() {
          circular=false;
        });
        errorSnackBar(context, responseMap.values.first);
      }
    } else {
       setState(() {
          circular=false;
        });
      errorSnackBar(context, 'enter all required fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      body:SingleChildScrollView(
        child: Container(
          //height: 700,
          padding: EdgeInsets.only(top: 30),
          child: Stack(
            children: [
              Container(
                width: 500,
                child: Image.asset('images/download.png',fit: BoxFit.fill,)),
          
                 Container(
                   height: 900,
                   margin: EdgeInsets.only(top: 300),
                //alignment: Alignment.center,
                //width: double.infinity,
                //height: 500,
                decoration: BoxDecoration(
                  
                   color: Colors.orange,
                  borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50) )
                ),
               child: Column(
                 children: [
                   SizedBox(height: 10,),
                   Container(
                     child: Text('Welcome back',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.yellow)),
                   ),
                    SizedBox(height: 15,),
                   Container(
                     child: Text('Login to your account',style: TextStyle(fontSize: 18)),
                   ),
                   SizedBox(height: 40,),
                TextFormField(
                  
                          keyboardType:TextInputType.emailAddress ,
                           onChanged: (value) {
                    _email = value;
                  },
                          decoration: InputDecoration(
                            
                            contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            hintText: 'Email',
                            hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                            //prefixIcon: Icon(Icons.email)
                          ),
                        ),
                      SizedBox(height: 50,),
                    Container(
                      child: TextFormField(
                        obscureText: true,
                             onChanged: (value) {
                    _password = value;
                  },
                        decoration: InputDecoration(
                           
                            contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          hintText: 'password',
                          hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                            //prefixIcon: Icon(Icons.lock)
                        
                      ),
                    ),),
                      SizedBox(height: 60,),
                    ElevatedButton(
                      onPressed:(){
                        setState(() {
                          circular=true;
                        });
                        loginPressed();
                      },
                      child:circular? CircularProgressIndicator(color: Colors.black): Text('login',
                      style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900,color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[600],
                        fixedSize: Size(370, 70),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                      ),
                      ),
                     SizedBox(height: 18,),
                     Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text('Dont have an account?',style: TextStyle(fontSize: 15)),
                          ),
                          GestureDetector(
                            child: Container(
                               margin: EdgeInsets.only(left: 5),
                              child: Text('Sign up',style: TextStyle(color: Colors.yellow,fontSize: 15))),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));
                            },
                          )
                        ],
                      ) 
                 ],
               ),
              ),
              
              
             
            ],
          ),
        ),
      )
     
    );
  }
  read() async {
  final pref=await SharedPreferences.getInstance();
  final Key='token';
  final ValueKey=pref.get(Key) ?? 0;
  if(ValueKey != '0'){
    final prefs=await SharedPreferences.getInstance();
    final key='id';
    final ValueKey1=prefs.getInt(key);
    switch(ValueKey1){
  case 1:
   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminHome(ValueKey1)));
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminBar(ValueKey1)));
    break;
    default:
   // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserHome(ValueKey1)));
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Bar(ValueKey1)));
}
  
  }
  //print('################################');
  //print('read : $ValueKey');
  
}
getRoleId(int id){
switch(id){
  case 1:
    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminHome(id)));
     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminBar(id)));
    break;
  default:
    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>UserHome(id)));
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Bar(id)));
}
}
 /*re()async{
      final prefsS=await SharedPreferences.getInstance();
    final key='id';
    final ValueKey2=prefsS.getInt(key);
    print(ValueKey2);
    final String _url='http://192.168.73.189:8000/api/mypat/$ValueKey2';
    try{
       http.Response response=await http.get(Uri.parse(_url));
      if(response.statusCode == 200){
        var i=json.decode(response.body);
        
      print('*************************************');
      print(i);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>doctorhome(i)));
       // return i;
      }else{
        return 'fail';
      }
    }catch(e){
      print(e);
      return 'failed';
    }
    }*/
    /*re()async{
      final prefsS=await SharedPreferences.getInstance();
    final key='id';
    final ValueKey2=prefsS.getInt(key);
    print(ValueKey2);
    final String _url='http://192.168.2.189:8000/api/mypatient/$ValueKey2';
    try{
       http.Response response=await http.get(Uri.parse(_url));
      if(response.statusCode == 200){
        var i=json.decode(response.body);
        
      print('*************************************');
      print(i);
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DoctorHome(i,ValueKey2!)));
        return i;
      }else{
        return 'fail';
      }
    }catch(e){
      print(e);
      return 'failed';
    }
    }*/
}
save(String token) async {
  final pref=await SharedPreferences.getInstance();
  final Key='token';
  final ValueKey=token;
  pref.setString(Key,ValueKey);
}
/*saveRole(int role)async{
  final pref=await SharedPreferences.getInstance();
  final Key='role';
  final ValueKey1=role;
  pref.setInt(Key, ValueKey1);
}*/
saveId(int y)async{
 final pref=await SharedPreferences.getInstance();
  final Key='id';
  final ValueKey2=y;
  pref.setInt(Key, ValueKey2);
}