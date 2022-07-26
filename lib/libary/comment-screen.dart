import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/one-login-service.dart';
class CommentScreen extends StatefulWidget {
 // const CommentScreen({ Key? key }) : super(key: key);
int? bookid;
CommentScreen(this.bookid);
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  var myid;
   int userId=0;
   TextEditingController _txtComment=TextEditingController();
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('id') ?? 0;
}
   Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/allcomment/$myid';
   
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

print('**********************');
print('///////////////////');
print(jsonDatae);
List<Doctor> doctors=[];
for(var u in jsonDatae){
  Doctor user=new Doctor(u['id'],u['comment'],u['member']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  createComment(var com)async{
      http.Response response = await create.come(com,widget.bookid!);
  }
 void getid()async{
      userId=await getUserId();
  }
  _deleteComment(int id)async{
    print(id);
 String token=await getToken();
    final response=await http.delete(
Uri.parse('http://192.168.178.189:8000/api/destroycomment/$id'),
 headers: {
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
    if(response.statusCode == 200){
      print('succes');
    }
  }
   @override
  void initState() {
  setState(() {
    myid=widget.bookid;
  
  });
    getDoctors();
    getid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:FutureBuilder(
        future: getDoctors(),
        builder: (context,AsyncSnapshot snapshot){
             if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return Column(
  children: [
    Container(
child: ListView.builder(
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
child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: [
        Row(
     
      children :[
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
_deleteComment(snapshot.data[i].id ?? 0);
          }
        },
        ) : SizedBox()
     ],
   ),SizedBox(height: 10,),
   Text('${snapshot.data[i].comment}')
  ],
),
    );
  }
  ),
),
Container(
  width: MediaQuery.of(context).size.width,
  padding: EdgeInsets.all(10),
  decoration:BoxDecoration(
   border:  Border(top: BorderSide(color: Colors.black26,width: 0.5)
  )
  ),
  child: Row(children: [
    Expanded(child: TextField(
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
      }
    }, 
    icon: Icon((Icons.send))
    )
  ],),
)
  ],
);
        }
        ),
    );
  }
}
class Doctor{
  final int id;
  final String comment;
  final Map member;
  Doctor(this.id,this.comment,this.member);
}
/*
 body:FutureBuilder(
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
            return Card(
              
          child: Column(
            children: [
              
              SizedBox(height: 14,),
              Container(
              child:  Text('${snapshot.data[i].comment}')
              ),
           SizedBox(height: 14,),
              Container(
              child:  Text('${snapshot.data[i].member['name']}')
              ),
            ],
          ),);
          }
          )
      ),
);
        }
        ),
*/