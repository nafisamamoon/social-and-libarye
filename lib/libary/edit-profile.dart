import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/login.dart';
import 'package:soci/libary/profile.dart';
class EditProfile extends StatefulWidget {
 // const EditProfile({ Key? key }) : super(key: key);
   int? id;
   String? name,image,email,about;
   EditProfile(this.id,this.name,this.email,this.image,this.about);
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _email=TextEditingController();
  TextEditingController _name=TextEditingController();
  TextEditingController _about=TextEditingController();
  int uid=0;
  PickedFile? _imageFile;
  final ImagePicker _picker=ImagePicker();
   @override
  void initState() {
    uid=widget.id!;
    _name.text=widget.name!;
    _about.text=widget.about!;
    _email.text=widget.email!;
  
   // _imageFile=widget.path as PickedFile?;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 160),
          child: Column(
            children: [
      imageProfile(),
       SizedBox(height: 15,),
              Container(
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Name',
                    hintText: 'name'
                  ),
                ),
              ),
              SizedBox(height: 15,),
               Container(
                 child: TextFormField(
                
                  controller: _about,
                  decoration: InputDecoration(
                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'About',
                    hintText: 'about'
                  ),
              ),
               ),
               
            
              SizedBox(height: 20,),
            
               
             
              ElevatedButton(onPressed: ()async{
                //print(_imageFile!.path);
                 if(_imageFile != null){
        var imageResponse=await patchImage();
                   
                    if(imageResponse.statusCode==200){
                      print('//////////////////////////');
                      print('success');
                       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistrarProfile()));
                     /* showDialog(context: context, builder:(context){
return AlertDialog(
  actions: [
    TextButton(onPressed: (){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistrarProfile()));
    },
     child: Text('OK')
     )
  ],
  title: Text('Success',style: TextStyle(color: Colors.green),),
  
  content: Text('The registrar profile edited successfully'),
);
             });*/
                    }
        
                  else{
                    print('//////////////////////////');
                    print('fail');
                  }
                 }else{
                   edit();
                 }
              }
              , child: Text('Apply Editing',style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900),),
              style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      fixedSize: Size(250, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
              ),
                SizedBox(height: 22,),
  
      /////////////////////////////
  
      /* ElevatedButton(
                    onPressed:(){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistrarProfile()));
                    },
                    child: Text('Back',
                    style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      fixedSize: Size(250, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),*/
            ],
          ),
        ),
      ),
    );
  }
  Widget imageProfile(){
  return Center(
    child: Stack(children: [
  CircleAvatar(radius: 80,
  backgroundImage: _imageFile == null ?  NetworkImage('http://192.168.178.189:8000/uploads/'+widget.image!): FileImage(File(_imageFile!.path)) as ImageProvider,
  ),
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
Future<http.StreamedResponse> patchImage()async{
   String token=await getToken();
 var url='http://192.168.178.189:8000/api/edit-all/$uid';
 var request=http.MultipartRequest('POST',Uri.parse(url));
 request.files.add(await http.MultipartFile.fromPath("image",_imageFile!.path));
 //request.files.add(await http.MultipartFile.fromPath("path",_imageFile== null?CachedNetworkImageProvider('http://192.168.2.189:8000/uploads/'+widget.path!) as String  :_imageFile!.path) );
//request.files.add(await http.MultipartFile.fromPath("path",_imageFile== null?'http://192.168.2.189:8000/uploads/'+widget.path! :_imageFile!.path) );
 request.fields.addAll({
'name':_name.text,
'about':_about.text,
//'phone_number':_phone_number.text,
 '_method': 'PUT'
 });
// request.fields['name']=nam
 request.headers.addAll({
   //'Content-type':'multipart/form-data',
   //'Accept': 'application/json'
     'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Bearer $token'
 });
var response=await request.send();
return response;
}
///////////////////////////////////////////////////////////
 Future<http.StreamedResponse> edit()async{
   String token=await getToken();
 var url='http://192.168.178.189:8000/api/edit-data/$uid';
 var request=http.MultipartRequest('POST',Uri.parse(url));
 request.fields.addAll({
'name':_name.text,
'about':_about.text,
 '_method': 'PUT'
 });
 request.headers.addAll({
   //'Content-type':'multipart/form-data',
   //'Accept': 'application/json'
     'Content-Type': 'application/json',
  'Accept': 'application/json',
    'Authorization': 'Bearer $token'
 });
var response=await request.send();
if(response.statusCode == 200){
  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistrarProfile()));
    /*showDialog(context: context, builder:(context){
return AlertDialog(
  actions: [
    TextButton(onPressed: (){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RegistrarProfile()));
    },
     child: Text('OK')
     )
  ],
  title: Text('Success',style: TextStyle(color: Colors.green),),
  
  content: Text('The registrar profile edited successfully'),
);
             });*/
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
}
else{
  print('fail');
}
return response;
}
}