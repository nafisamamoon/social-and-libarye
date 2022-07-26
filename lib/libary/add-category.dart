import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/admin-home.dart';
import 'package:soci/libary/login.dart';
import 'package:soci/social-app/services/user_service.dart';
class AddCategory extends StatefulWidget {
  const AddCategory({ Key? key }) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
   TextEditingController namecontroller=TextEditingController();
     GlobalKey<FormState> _formkey=GlobalKey<FormState>();
     PickedFile? _imageFile;
  final ImagePicker _picker=ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
    body:SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                  children: [
                    imageProfile(),
                    SizedBox(height: 20,),
                    TextFormField(
  maxLength: 20,
                    validator:(text){
    if(text!.isEmpty){
return "ادخل هذا الحقل";
    }
return null;
  },
                      controller: namecontroller,
                      decoration: InputDecoration(
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                        hintText: 'name'
                      ),
                    ),
                  
                    SizedBox(height: 15,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          fixedSize: Size(200,50)
                        ),
                      child: Text('add category',style: TextStyle(wordSpacing: 2,fontWeight: FontWeight.bold,fontSize: 17),),
                      onPressed: ()async{
                       var formdata=_formkey.currentState;
    if(formdata!.validate()){
                         if(_imageFile != null){
                    var imageResponse=await patchImage(_imageFile!.path);
                   
                    if(imageResponse.statusCode==200){
                      print('//////////////////////////');
                      print('success');
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                     
                    }
      
                  }else{
             print('fail');
                  }
                      }else{
                        print('enter failed');
                      }
                      },
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ) , 
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
Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
Future<http.StreamedResponse> patchImage(String filepath)async{
  String token=await getToken();
 var url='http://192.168.178.189:8000/api/addcat';
 var request=http.MultipartRequest('POST',Uri.parse(url));
 request.files.add(await http.MultipartFile.fromPath("image",filepath));
 request.fields.addAll({
'name':namecontroller.text,
 });
// request.fields['name']=nam
 request.headers.addAll({
   'Content-type':'multipart/form-data',
   'Authorization': 'Bearer $token'

 });
var response=request.send();
return response;
}
}