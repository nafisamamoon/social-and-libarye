import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/user.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/services/user_service.dart';
class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool loading=true;
  TextEditingController txtNameController=TextEditingController();
  GlobalKey<FormState> formKey=GlobalKey<FormState>();
   File? _imageFile;
  final _picker=ImagePicker();
  Future getImage()async{
    final pickedFile=await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile=File(pickedFile.path);
      });
    }
  }
  //get user detail
  void getUser()async{
    ApiResponse response=await getUserDetail();
    if(response.error == null){
  setState(() {
   user=response.data as User;
   loading=false;
txtNameController.text=user!.name ?? '';
  });
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      
    }
  }
  //update profile
  void updateProfile()async{
      ApiResponse response=await updateUser(txtNameController.text, getStringImage(_imageFile));
      setState(() {
        loading=false;
      });
    if(response.error == null){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.data}')));
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      
    }
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),) :
    Padding(padding: EdgeInsets.only(top: 40,left: 40,right: 40),
    child: ListView(
      children: [
        Center(
          child: GestureDetector(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
borderRadius: BorderRadius.circular(60),
image: _imageFile== null ? user!.image != null ? DecorationImage(image: NetworkImage('${user!.image}'),
fit: BoxFit.cover
):null : DecorationImage(image: FileImage(_imageFile ?? File('')),fit: BoxFit.cover),
color: Colors.amber

              ),
            ),
            onTap: (){
              getImage();
            },
          ),
        ),
        SizedBox(height: 20,),
        Form(child: TextFormField(
          key: formKey,
          decoration: kInputDecoration('Name'),
          controller: txtNameController,
          validator: (val)=>val!.isEmpty ? 'invalid name' : null,
        )),
        SizedBox(height: 20,),
        kTextButton('update',(){
          if(formKey.currentState!.validate()){
            setState(() {
              loading=true;
            });
            updateProfile();
          }
        })
      ],
    ),
    );
  }
}