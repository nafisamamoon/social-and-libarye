import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/admin-bar.dart';
import 'package:soci/libary/admin-home.dart';
import 'package:soci/libary/user-bar.dart';
import 'package:soci/libary/global.dart';
import 'package:soci/libary/login.dart';
import 'package:soci/libary/user-home.dart';

import 'one-login-service.dart';
class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
 // var image='images/A.jpg';
     String _email = '';
  String _password = '';
     String _name = '';
  String _about = '';
  var status;
    PickedFile? _imageFile;
  final ImagePicker _picker=ImagePicker();
  //bool circular=false;
    registerPressed() async {
    
    if (_email.isNotEmpty && _password.isNotEmpty && _name.isNotEmpty && _about.isNotEmpty ) {
     // http.Response
      http.StreamedResponse response = await RegisterService.register(_name, _email, _password, _about,_imageFile!.path);
      //status=response.body.contains('error');
      //Map responseMap = jsonDecode(response.body);
      var res=await http.Response.fromStream(response);
      final result=jsonDecode(res.body) as Map<String,dynamic>;
      status=res.body.contains('error');
     //var responseMap=await response.toString();
     print('&&&&&&&&&&&&&&&&&&');
     print(result);
      //var id=responseMap["user"]["id"];
      if (response.statusCode == 200) {
       
     print('////////////////////////');
    // print(responseMap[0]);
    
           save(result['token']);
         // print(result['name']);
    
            saveId(result['id']);
          
           getRoleId(result['id']);
           
      
      } else {
      
        errorSnackBar(context, result.values.first);
      }
    } else {
      
      errorSnackBar(context, 'enter all required fields');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: 
      Container(
        margin: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              imageProfile(),
              SizedBox(height: 7,),
              Container(
                width: double.infinity,
                height: 700,
         decoration: BoxDecoration(
                    
                     color: Colors.orange,
                    borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50) )
                  ),
                  child: Column(
                    children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                       child: Text('Welcome',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.yellow)),
                     ),
                      SizedBox(height: 15,),
                     Container(
                       child: Text('Create new account',style: TextStyle(fontSize: 18)),
                     ),  
                     SizedBox(height: 20,),
                      Form(
                child: Column(
                  children: [
                    TextFormField(
               
                       onChanged: (value) {
                  _name = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'name',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                        //prefixIcon: Icon(Icons.person)
                      ),
              ),
              SizedBox(height: 50,),
                TextFormField(
                      keyboardType:TextInputType.emailAddress ,
                       onChanged: (value) {
                  _email = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'email',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                       // prefixIcon: Icon(Icons.email)
                      ),
                    ),
                     SizedBox(height: 50,),
              TextFormField(
                   
                       onChanged: (value) {
                  _password = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'password',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                       // prefixIcon: Icon(Icons.lock)
                      ),
                    ),
                     SizedBox(height: 50,),
              TextFormField(
                   
                       onChanged: (value) {
                  _about = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'about',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                        //prefixIcon: Icon(Icons.description)
                      ),
                    ),
                      SizedBox(height: 30,),
                          Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                               // margin: EdgeInsets.only(left: 18),
                                child: ElevatedButton(
                    onPressed:(){
                    
                      registerPressed();
                    },
                    child: Text('register',
                    style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[600],
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
                              ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                      },
                      child: Container(
                        //margin: EdgeInsets.only(left: 60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                        ),
                        child: Icon(Icons.arrow_back,color: Colors.orange,),
                      ),
                    )
                            ],
                          ),
                  ],
                )
                ),     
                    ],
                  ),
              )
            ],
          ),
        ),
      )
    /* Stack(children: [
      /*  Container(
                width: 500,
                child: imageProfile(),
                // Image.asset('images/download.png',fit: BoxFit.fill,)
                ),*/
                
                   // imageProfile(),
               
        Container(
        child: Container(
                   height: 900,
                   margin: EdgeInsets.only(top: 290),
                //alignment: Alignment.center,
                //width: double.infinity,
                //height: 500,
                decoration: BoxDecoration(
                  
                   color: Colors.orange,
                  borderRadius: BorderRadius.only(topRight:Radius.circular(50),topLeft:Radius.circular(50) )
                ),
               child: Column(
                 children: [
                  
                  /* SizedBox(height: 10,),
                   Container(
                     child: Text('Welcome',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.yellow)),
                   ),
                    SizedBox(height: 15,),
                   Container(
                     child: Text('Create new account',style: TextStyle(fontSize: 18)),
                   ),
                   SizedBox(height: 40,),*/
                    imageProfile(),
              Form(
                child: Column(
                  children: [
                    TextFormField(
               
                       onChanged: (value) {
                  _name = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'name',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                        //prefixIcon: Icon(Icons.person)
                      ),
              ),
              SizedBox(height: 50,),
                TextFormField(
                      keyboardType:TextInputType.emailAddress ,
                       onChanged: (value) {
                  _email = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'email',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                       // prefixIcon: Icon(Icons.email)
                      ),
                    ),
                     SizedBox(height: 50,),
              TextFormField(
                   
                       onChanged: (value) {
                  _password = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'password',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                       // prefixIcon: Icon(Icons.lock)
                      ),
                    ),
                     SizedBox(height: 50,),
              TextFormField(
                   
                       onChanged: (value) {
                  _about = value;
                },
                      decoration: InputDecoration(
                         contentPadding: EdgeInsets.only(left: 20),
                            
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        hintText: 'about',
                        hintStyle: TextStyle(fontSize: 20,wordSpacing: 2),
                        //prefixIcon: Icon(Icons.description)
                      ),
                    ),
                      SizedBox(height: 30,),
                          Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                               // margin: EdgeInsets.only(left: 18),
                                child: ElevatedButton(
                    onPressed:(){
                    
                      registerPressed();
                    },
                    child: Text('register',
                    style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[600],
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
                              ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                      },
                      child: Container(
                        //margin: EdgeInsets.only(left: 60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                        ),
                        child: Icon(Icons.arrow_back,color: Colors.orange,),
                      ),
                    )
                            ],
                          ),
                  ],
                )
                ),
           
                 ],
               ),
              ),
      )
      ],)*/
      
    );
  }
   Widget imageProfile(){
  return Center(
    child: Stack(children: [
  CircleAvatar(radius: 80,
  backgroundImage: _imageFile == null ? AssetImage('images/download.png'): FileImage(File(_imageFile!.path)) as ImageProvider,
  ),
  // AssetImage('images/book.png')
  Positioned(child: InkWell(
    onTap: (){
showModalBottomSheet(context:context,
 builder:((builder)=>bottomsheet()),);
    },
    child: Icon(Icons.camera_alt)),
  bottom: 20.0,
  right: 20.0,
  )
    ],),
  );
}
Widget bottomsheet(){
  return Container(
    height: 100.0,
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20
    ),
child: Column(children: [
  Text('choose photo'),
  SizedBox(height: 20,),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    FlatButton.icon(onPressed: (){
      takePhoto(ImageSource.camera);
    },
     icon: Icon(Icons.camera), 
     label: Text('camera')),
     FlatButton.icon(onPressed: (){
       takePhoto(ImageSource.gallery);
     },
     icon: Icon(Icons.image), 
     label: Text('gallery')),
  ],)
],),
  );
}
void takePhoto(ImageSource source)async{
  final pickedFile=await _picker.getImage(source: source);
  setState(() {
    _imageFile=pickedFile;
  });
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
}
save(String token) async {
  final pref=await SharedPreferences.getInstance();
  final Key='token';
  final ValueKey=token;
  pref.setString(Key,ValueKey);
}
saveId(int y)async{
 final pref=await SharedPreferences.getInstance();
  final Key='id';
  final ValueKey2=y;
  pref.setInt(Key, ValueKey2);
}