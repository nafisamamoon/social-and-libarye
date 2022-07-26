import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AddBook extends StatefulWidget {
  const AddBook({ Key? key }) : super(key: key);

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
   TextEditingController namecontroller=TextEditingController();
  
   TextEditingController descriptioncontroller=TextEditingController();
  TextEditingController writercontroller=TextEditingController();
     GlobalKey<FormState> _formkey=GlobalKey<FormState>();
     PickedFile? _imageFile;
  final ImagePicker _picker=ImagePicker();
  List data=[];
  var m;
  Object? selectedcategory="Sport";
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
   Future getUser()async{
     String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/getcat';
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonData=jsonDecode(response.body);

setState(() {
  data=jsonData;
});
  }
  @override
  void initState() {
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body:SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Form(
                key: _formkey,
                child: Column(
                children: [
                  imageProfile(),
                  SizedBox(height: 10,),
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
                   SizedBox(height: 10,),
                  TextFormField(
                                    validator:(text){
    if(text!.isEmpty){
return "ادخل هذا الحقل";
    }
return null;
  },
  maxLength: 20,
  
                    controller: writercontroller,
                    decoration: InputDecoration(
                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'writer'
                    ),
                  ),
                  SizedBox(height: 15,),
                   SizedBox(height: 10,),
                 
                 
                   SizedBox(height: 15,),
                  TextFormField(
                           validator:(text){
    if(text!.isEmpty){
return "ادخل هذا الحقل";
    }
return null;
  },
                    controller: descriptioncontroller,
                    maxLines: 4,
                    decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      hintText: 'description'
                    ),
                  ),
                   SizedBox(height: 15,),
                 
                 Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30),
child: Text('select book category:',style: TextStyle(fontWeight: FontWeight.bold),),

                      ),
                      SizedBox(width: 20,),
                   
                DropdownButton(
                        
     items: data.map((e){
  
        return DropdownMenuItem(
  
          child: Text(e['name']),
  
          //value: e['id'].toString(),
         
  value: e['name'],
  onTap: (){
    m=e['id'].toString();
    print('//////////////////');
    print(m);
  },
  
          );
  
      }).toList(),
               onChanged: (val){
                 setState(() {
                       selectedcategory=val;
                 });
               },
               value: selectedcategory
               ),
                    ],
                  ),
                  SizedBox(height: 15,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        fixedSize: Size(200,50)
                      ),
                    child: Text('add new book',style: TextStyle(wordSpacing: 2,fontWeight: FontWeight.bold,fontSize: 17),),
                    onPressed: ()async{
                     var formdata=_formkey.currentState;
    if(formdata!.validate()){
                       if(_imageFile != null){
                  var imageResponse=await patchImage(_imageFile!.path);
                 
                  if(imageResponse.statusCode==200){
                    print('//////////////////////////');
                    print('success');
           showDialog(context: context, builder:(context){
return AlertDialog(
  actions: [
    TextButton(onPressed: (){
// Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminHome()));
    },
     child: Text('OK')
     )
  ],
  title: Text('Success',style: TextStyle(color: Colors.green),),
  
  content: Text('The book added successfully'),
);
             });
                   
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
      ) ,
    );
  }
    Widget imageProfile(){
  return Center(
    child: Stack(children: [
  CircleAvatar(radius: 80,
  backgroundImage: _imageFile == null ?  AssetImage('images/download.png'): FileImage(File(_imageFile!.path)) as ImageProvider,
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
Future<http.StreamedResponse> patchImage(String filepath)async{
    String token=await getToken();
 var url='http://192.168.178.189:8000/api/addbook';
 var request=http.MultipartRequest('POST',Uri.parse(url));
 request.files.add(await http.MultipartFile.fromPath("image",filepath));
 request.fields.addAll({
'name':namecontroller.text,
'description':descriptioncontroller.text,
'writer':writercontroller.text,
'category_id':m.toString()
 });
// request.fields['name']=nam
 request.headers.addAll({
   'Content-type':'multipart/form-data',
  //"Content-Type": "application/json",
'Authorization': 'Bearer $token'

 });
var response=request.send();
return response;
}
}