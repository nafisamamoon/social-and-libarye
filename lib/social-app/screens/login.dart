import 'package:flutter/material.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/user.dart';
import 'package:soci/social-app/screens/home.dart';
import 'package:soci/social-app/screens/register.dart';
import 'package:soci/social-app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey=GlobalKey<FormState>();
  TextEditingController txtEmail=TextEditingController();
  TextEditingController txtPassword=TextEditingController();
  bool load=false;
  void _loginUser()async{
ApiResponse response=await login(txtEmail.text, txtPassword.text);
if(response.error == null){
_saveAndRedirectToHome(response.data as User);
}else{
  setState(() {
    load=false;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            TextFormField(
              controller: txtEmail,
              validator: (val)=>val!.isEmpty ? 'invalid email address': null,
              keyboardType: TextInputType.emailAddress,
decoration: kInputDecoration('Email')
            ),
            SizedBox(height: 10,),
             TextFormField(
              controller: txtPassword,
              validator: (val)=>val!.isEmpty ? 'required': null,
              keyboardType: TextInputType.emailAddress,
decoration: kInputDecoration('Password')
            ),
            SizedBox(height: 10,),
            load ? Center(child: CircularProgressIndicator(),):
            kTextButton('Login', (){
              if(formkey.currentState!.validate()){
  setState(() {
    load=true;
    _loginUser();
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
             SizedBox(height: 10,),
            kLoginRegisterHint('Dont have an account?', 'Register', (){
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Register()), (route) => false);
            })
          ],
        ),
      ),
    );
  }
}