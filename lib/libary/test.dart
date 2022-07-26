import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/Book.dart';
import 'package:soci/libary/api-response.dart';
import 'package:http/http.dart' as http;
import 'package:soci/libary/book-detail.dart';

class Test extends StatefulWidget {
  const Test({ Key? key }) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int ?usid;
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
  Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/allbooks';
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
  Doctor user=new Doctor(u['id'],u['name'],u['image'],u['writer'],u['description'],u['category_id'],u['comments_count'],u['favorites']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  void fav(int book_id, int member_id) async {
     String token=await getToken();
    Map data = {
      "book_id": book_id,
      "member_id": member_id,
    };
    var body = json.encode(data);
    
    var url = Uri.parse('http://192.168.178.189:8000/api/fav/$book_id');
    http.Response response = await http.post(
      url,
      headers:{
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: body,
    );
    //print(response.body);
    //return response;
  }
  Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('id') ?? 0;
}
void getid()async{
      usid=await getUserId();
  }
  @override
  void initState() {
   getDoctors();
   getid();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:body()
    );
  }
  Widget body(){
return FutureBuilder(
        future: getDoctors(),
        builder:(context,AsyncSnapshot snapshot){
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
           
          
            return Container(
             // margin: EdgeInsets.all(8), 
            child:InkWell(
              onTap: (){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>BookDetail(snapshot.data[i].id)));
  },
            child:Card(
              child:Row(
              children: [
                Container(
       child: Flexible(child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image
         ,fit:BoxFit.cover,width: 130,)),
            ),
            SizedBox(width: 10,),
Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
   Text('${snapshot.data[i].name}',style: TextStyle(fontSize: 20),),
SizedBox(height: 10,),
 Text('${snapshot.data[i].writer}',style: TextStyle(fontSize: 15,color: Colors.grey),),

  ],
),
SizedBox(width: 55,),
 IconButton(onPressed: (){
                 fav(snapshot.data[i].id, usid!);
                 setState(() {
                   body();
                 });
                },
               // icon:Icon(Icons.favorite) ,
     icon: snapshot.data[i].favorites.length >0 ? Icon(Icons.favorite,color:  Colors.red ,size: 29,) : Icon(Icons.favorite_outline,color: Colors.black38 ,size: 29),

                 ),
              ],
            )
            )));
          }
          )
      ),
);
        }
        );
  }
}
class Doctor{
  final int id,category_id,comments_count;
  final String name,image,writer,description;
  final List favorites;
  Doctor(this.id,this.name,this.image,this.writer,this.description,this.category_id,this.comments_count,this.favorites);
}
/*Scaffold(
      body:FutureBuilder(
        future: getDoctors(),
        builder:(context,AsyncSnapshot snapshot){
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
              child:Row(
              children: [
                Container(
       child: Flexible(child: Image.network('http://192.168.184.189:8000/uploads/'+snapshot.data[i].image
         ,fit:BoxFit.cover,width: 130,)),
            ),
            SizedBox(width: 10,),
Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
   Text('${snapshot.data[i].name}',style: TextStyle(fontSize: 20),),
SizedBox(height: 30,),
 Text('${snapshot.data[i].writer}',style: TextStyle(fontSize: 15,color: Colors.grey),),
SizedBox(height: 10,),
   IconButton(onPressed: (){
                 fav(snapshot.data[i].id, usid!);
                },
               // icon:Icon(Icons.favorite) ,
     icon: snapshot.data[i].favorites.length >0 ? Icon(Icons.favorite,color:  Colors.red ,) : Icon(Icons.favorite_outline,color: Colors.black38 ,),

     // post.selfLiked == true ? Colors.red : Colors.black38, 
                 ),
  ],
)
              ],
            )
            );
          }
          )
      ),
);
        }
        )
    );*/