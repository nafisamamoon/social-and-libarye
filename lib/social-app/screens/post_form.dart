import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/post.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/services/post_service.dart';
import 'package:soci/social-app/services/user_service.dart';
class PostForm extends StatefulWidget {
  //const PostForm({ Key? key }) : super(key: key);
final Post? post;
final String? title;
PostForm({
this.post,
this.title
});
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  final TextEditingController _txtControllerBody=TextEditingController();
  bool load=false;
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
  void _createPost()async{
    String? image=_imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response=await createPost(_txtControllerBody.text, image);
    if(response.error == null){
      Navigator.of(context).pop();
    }else if(response.error == unauthorized){
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
  }

  //edit post
  void _editPost(int postId)async{
    ApiResponse response=await editPost(postId, _txtControllerBody.text);
    if(response.error == null){
  Navigator.of(context).pop();
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
  }
  @override
  void initState() {
    if(widget.post != null){
      _txtControllerBody.text=widget.post!.body ?? '';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body:load ? Center(child: CircularProgressIndicator(),): ListView(
        children: [
          widget.post != null ? SizedBox() :
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: _imageFile == null ? null: DecorationImage(image: FileImage(_imageFile ?? File(''),),
              fit: BoxFit.cover
              )
            ),
            child: Center(
              child: IconButton(onPressed: (){
getImage();
              }, 
              icon: Icon(Icons.image,size: 50,color: Colors.black38,)
              ),
            ),
          ),
          Form(
            key: _formkey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: _txtControllerBody,
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                validator: (val)=>val!.isEmpty ? 'post body is required' : null,
                decoration: InputDecoration(
                  hintText: 'post body',
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black38))
                ),
                
              ),
              )),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8),
              child: kTextButton('Post', (){
if(_formkey.currentState!.validate()){
  setState(() {
  load=true;
});
if(widget.post == null){
_createPost();
}else{
_editPost(widget.post!.id ?? 0);
}

}
              }),
              )
        ],
      ),
    );
  }
}