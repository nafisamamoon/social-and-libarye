import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/Book.dart';
import 'package:soci/libary/api-response.dart';
import 'package:soci/libary/book-fav.dart';
import 'package:soci/libary/comment-screen.dart';
import 'package:soci/libary/one-login-service.dart';
class OneBook extends StatefulWidget {
  //const OneBook({ Key? key }) : super(key: key);
  int? id;
OneBook(this.id);
  @override
  State<OneBook> createState() => _OneBookState();
}

class _OneBookState extends State<OneBook> {
  TextEditingController  _txtComment=TextEditingController();
  int userId=0;
  var myid;
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
 List<dynamic> _bestList=[];
    Future<void> retrivePosts()async{
   // userId=await getUserId();
    ApiResponse response=await getOnebook(myid);
    if(response.error == null){
      setState(() {
        _bestList=response.data as List<dynamic>;
       // print(_bestList);
        //load=load ? !load : load;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    
    }
  }
  List<dynamic> _commentList=[];
    Future<void> retriveComment()async{
   // userId=await getUserId();
    ApiResponse response=await getcom(myid);
    if(response.error == null){
      setState(() {
        _commentList=response.data as List<dynamic>;
        print(_commentList);
        //load=load ? !load : load;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    
    }
  }
  Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/onebook/$myid';
   
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

//print('**********************');
//print('///////////////////');
//print(jsonDatae);
List<Doctor> doctors=[];
for(var u in jsonDatae){
  Doctor user=new Doctor(u['id'],u['name'],u['image'],u['writer'],u['description'],u['comments_count']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
   Future<List<Comment>>getComment() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/allcomment/$myid';
   
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

//print('**********************');
//print('///////////////////');
//print(jsonDatae);
List<Comment> com=[];
for(var u in jsonDatae){
  Comment user=new Comment(u['id'],u['comment'],u['member']);
  com.add(user);
}


print(com.length);
return com;
  }
    createComment(var com)async{
      http.Response response = await create.come(com,widget.id!);
  }
  Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('id') ?? 0;
}
  void getid()async{
      userId=await getUserId();
  }
  clearTextInput(){
    _txtComment.clear();
  }
    @override
  void initState() {
  setState(() {
    myid=widget.id;
  });
    getDoctors();
    getComment();
    getid();
    //retrivePosts();
    //retriveComment();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: content()
     
    );
  }
 Widget content(){
   return Container(
     child:SingleChildScrollView(
child: Column(
  children: [
    FutureBuilder(
      future: getDoctors(),
      builder: (context,AsyncSnapshot snapshot){
             if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return InkWell(
  child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context,i){
            return SingleChildScrollView(
            child:Card(
              
          child: SingleChildScrollView(
        child:  Column(
            children: [
              Container(
                height: 400,
                child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image
             ,fit:BoxFit.cover,width: double.infinity,),
              ),
              SizedBox(height: 14,),
              Container(
              child:  Text('${snapshot.data[i].name}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
              ),
               SizedBox(height: 14,),
               Container(
              child:  Text('${snapshot.data[i].description}',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),
              SizedBox(height: 20,),
               Container(
              child:  Text('${snapshot.data[i].writer}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),
            ]
          ))
            )
            );
          }
        )
  )
);
      }
      ),
      FutureBuilder(
        future: getComment(),
        builder: (context,AsyncSnapshot snapshot){
             if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return Column(
children: [
ListView.builder(
  physics: AlwaysScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount:snapshot.data.length,
  itemBuilder: (context,i){
    return Container(
       padding: EdgeInsets.all(10),
width: MediaQuery.of(context).size.width,
decoration: BoxDecoration(
  border: Border(bottom: BorderSide(color: Colors.black,width: 0.5)
),
),
child: SingleChildScrollView(
child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
children: [
    Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: snapshot.data[i].member['image'] != null ? 
 DecorationImage(image: NetworkImage('http://192.168.178.189:8000/uploads/'+snapshot.data[i].member['image']
            ),fit: BoxFit.cover) : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey
          ),
        ),
        SizedBox(width: 20,),
 Text('${snapshot.data[i].member['name']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)
],
  ),
  snapshot.data[i].member['id']== userId ?
      PopupMenuButton(
        child: Padding(padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.more_vert,color: Colors.black,),
        ),
        itemBuilder: (context)=>[
          PopupMenuItem(
            child:Text('Edit') ,
            value: 'edit',
            ),
             PopupMenuItem(
            child:Text('Delete') ,
            value: 'delete',
            )
        ],
        onSelected: (val){
          if(val == 'edit'){
            setState(() {
              //_editCommentId=comment.id ?? 0;
              //_txtCommentController.text=comment.comment ?? '';
            });
    
          }else{
//_deleteComment(snapshot.data[i].id ?? 0);
          }
        },
        ) : SizedBox()
  ],
)
,SizedBox(height: 10,),
   Text('${snapshot.data[i].comment}')
  ],
)),
    );
  }
  )
],
);
        }
        ),
        Container(
           width: MediaQuery.of(context).size.width,
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(
   border:  Border(top: BorderSide(color: Colors.black26,width: 0.5)
  )
  ),
  child:Row(
    children: [
      Expanded(
        child: TextField(
      decoration:InputDecoration(
  labelText: 'comment',
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))
),
controller: _txtComment,
    )
      ),
       IconButton(onPressed: (){
      if(_txtComment.text.isNotEmpty){
         createComment(_txtComment.text);
        
       setState(() {
         content();
       });
        clearTextInput();
      }
    }, 
    icon: Icon((Icons.send))
    )
    ],
  )
        )
  ],
)),
   );
  } 
}
class Doctor{
  final int id,comments_count;
  final String name,image,writer,description;
  Doctor(this.id,this.name,this.image,this.description,this.writer,this.comments_count);
}
class Comment{
  final int id;
  final String comment;
  final Map member;
  Comment(this.id,this.comment,this.member);
}

/*Widget content(){
   return Container(
     child:SingleChildScrollView(
child: Column(
  children: [
    FutureBuilder(
      future: getDoctors(),
      builder: (context,AsyncSnapshot snapshot){
             if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return InkWell(
  child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context,i){
            return SingleChildScrollView(
            child:Card(
              
          child: SingleChildScrollView(
        child:  Column(
            children: [
              Container(
                height: 400,
                child: Image.network('http://192.168.184.189:8000/uploads/'+snapshot.data[i].image
             ,fit:BoxFit.cover,width: double.infinity,),
              ),
              SizedBox(height: 14,),
              Container(
              child:  Text('${snapshot.data[i].name}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
              ),
               SizedBox(height: 14,),
               Container(
              child:  Text('${snapshot.data[i].description}',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),
              SizedBox(height: 20,),
               Container(
              child:  Text('${snapshot.data[i].writer}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),
            ]
          ))
            )
            );
          }
        )
  )
);
      }
      ),
      FutureBuilder(
        future: getComment(),
        builder: (context,AsyncSnapshot snapshot){
             if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return Column(
children: [
ListView.builder(
  physics: AlwaysScrollableScrollPhysics(),
  shrinkWrap: true,
  itemCount:snapshot.data.length,
  itemBuilder: (context,i){
    return Container(
       padding: EdgeInsets.all(10),
width: MediaQuery.of(context).size.width,
decoration: BoxDecoration(
  border: Border(bottom: BorderSide(color: Colors.black,width: 0.5)
),
),
child: SingleChildScrollView(
child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
children: [
    Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: snapshot.data[i].member['image'] != null ? 
 DecorationImage(image: NetworkImage('http://192.168.184.189:8000/uploads/'+snapshot.data[i].member['image']
            ),fit: BoxFit.cover) : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey
          ),
        ),
        SizedBox(width: 20,),
 Text('${snapshot.data[i].member['name']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)
],
  ),
  snapshot.data[i].member['id']== userId ?
      PopupMenuButton(
        child: Padding(padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.more_vert,color: Colors.black,),
        ),
        itemBuilder: (context)=>[
          PopupMenuItem(
            child:Text('Edit') ,
            value: 'edit',
            ),
             PopupMenuItem(
            child:Text('Delete') ,
            value: 'delete',
            )
        ],
        onSelected: (val){
          if(val == 'edit'){
            setState(() {
              //_editCommentId=comment.id ?? 0;
              //_txtCommentController.text=comment.comment ?? '';
            });
    
          }else{
//_deleteComment(snapshot.data[i].id ?? 0);
          }
        },
        ) : SizedBox()
  ],
)
,SizedBox(height: 10,),
   Text('${snapshot.data[i].comment}')
  ],
)),
    );
  }
  )
],
);
        }
        ),
        Container(
           width: MediaQuery.of(context).size.width,
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(
   border:  Border(top: BorderSide(color: Colors.black26,width: 0.5)
  )
  ),
  child:Row(
    children: [
      Expanded(
        child: TextField(
      decoration:InputDecoration(
  labelText: 'comment',
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))
),
controller: _txtComment,
    )
      ),
       IconButton(onPressed: (){
      if(_txtComment.text.isNotEmpty){
         createComment(_txtComment.text);
        
       setState(() {
         content();
       });
        clearTextInput();
      }
    }, 
    icon: Icon((Icons.send))
    )
    ],
  )
        )
  ],
)),
   );
  }*/
/*
 body: Container(
        child: Column(
          children: [
             Expanded(
            
         child: ListView.builder(
         //  physics: NeverScrollableScrollPhysics(),
           shrinkWrap:true,
           // scrollDirection: Axis.horizontal,
           itemCount:_bestList.length ,
           itemBuilder: (context,i){
               Onebook cat=_bestList[i];
               return Container(
                 child: Column(children: [
                Container(
                  color: Colors.red,
                height: 400,
                width: double.infinity,
                child: Image.network('http://192.168.184.189:8000/uploads/${cat.image}',fit: BoxFit.fill,),
              ),
              SizedBox(height: 14,),
              Container(
              child:  Text('${cat.name}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
              ),
               SizedBox(height: 14,),
               Container(
              child:  Text('${cat.description}',style: TextStyle(fontSize:15,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),
              SizedBox(height: 20,),
               Container(
              child:  Text('${cat.writer}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.grey),)
              ),    
                 ],),
               );
           }
           )),
           /////////////////////////////////////////////////
     Expanded(
       
         child: ListView.builder(
           shrinkWrap: true,
           // scrollDirection: Axis.horizontal,
           itemCount:_commentList.length ,
           itemBuilder: (context,i){
               Commente cat=_commentList[i];
               return Container(
       padding: EdgeInsets.all(10),
width: MediaQuery.of(context).size.width,
decoration: BoxDecoration(
  border: Border(bottom: BorderSide(color: Colors.black,width: 0.5)
),
),
child: SingleChildScrollView(
child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
children: [
    Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: cat.member!['image'] != null ? 
 DecorationImage(image: NetworkImage('http://192.168.184.189:8000/uploads/'+cat.member!['image']
            ),fit: BoxFit.cover) : null,
            borderRadius: BorderRadius.circular(15),
            color: Colors.blueGrey
          ),
        ),
        SizedBox(width: 20,),
 Text('${cat.member!['name']}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)
],
  ),
  cat.member!['id']== userId ?
      PopupMenuButton(
        child: Padding(padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.more_vert,color: Colors.black,),
        ),
        itemBuilder: (context)=>[
          PopupMenuItem(
            child:Text('Edit') ,
            value: 'edit',
            ),
             PopupMenuItem(
            child:Text('Delete') ,
            value: 'delete',
            )
        ],
        onSelected: (val){
          if(val == 'edit'){
            setState(() {
              //_editCommentId=comment.id ?? 0;
              //_txtCommentController.text=comment.comment ?? '';
            });
    
          }else{
//_deleteComment(snapshot.data[i].id ?? 0);
          }
        },
        ) : SizedBox()
  ],
)
,SizedBox(height: 10,),
   Text('${cat.comment}')
  ],
)),
    );
           }
           )),       
          ],
        ),
      ),
*/