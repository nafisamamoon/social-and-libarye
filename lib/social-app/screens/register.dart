import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/user.dart';
import 'package:soci/social-app/screens/home.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/services/user_service.dart';
class Register extends StatefulWidget {
  const Register({ Key? key }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  TextEditingController txtEmail=TextEditingController();
  TextEditingController txtPassword=TextEditingController();
  TextEditingController txtName=TextEditingController();
  bool load=false;
   void _registerUser()async{
ApiResponse response=await register(txtName.text,txtEmail.text, txtPassword.text);
if(response.error == null){
_saveAndRedirectToHome(response.data as User);
}else{
  setState(() {
    load=!load;
  });
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
}
  }
  void _saveAndRedirectToHome(User user)async{
SharedPreferences pref=await SharedPreferences.getInstance();
await pref.setString('token', user.token ?? '');
await pref.setInt('userId', user.id ?? 0);
Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32,vertical: 32),
          children: [
             TextFormField(
              controller: txtName,
              validator: (val)=>val!.isEmpty ? 'invalid name': null,
              keyboardType: TextInputType.emailAddress,
decoration: kInputDecoration('Name')
            ),
              SizedBox(height: 20,),
            TextFormField(
              controller: txtEmail,
              validator: (val)=>val!.isEmpty ? 'invalid email address': null,
              keyboardType: TextInputType.emailAddress,
decoration: kInputDecoration('Email')
            ),
            SizedBox(height: 20,),
             TextFormField(
              controller: txtPassword,
              validator: (val)=>val!.isEmpty ? 'required': null,
              keyboardType: TextInputType.emailAddress,
decoration: kInputDecoration('Password')
            ),
            SizedBox(height: 20,),
            load ? Center(child: CircularProgressIndicator(),):
            kTextButton('Register', (){
              if(formkey.currentState!.validate()){
  setState(() {
    load=!load;
    _registerUser();
  });
}
            }),
           /* TextButton(onPressed: (){
if(formkey.currentState!.validate()){
  _loginUser();
}
            },
             child: Text('Login',style: TextStyle(color: Colors.white),),
             style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
             padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
             ),
             ),*/
             SizedBox(height: 20,),
            kLoginRegisterHint('Already  have an account?', 'Login', (){
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
            })
          ],
        ),
      ),
    );
  }
}