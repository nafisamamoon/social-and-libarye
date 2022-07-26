import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/one-book.dart';
class CategoryItem extends StatefulWidget {
  //onst CategoryItem({ Key? key }) : super(key: key);
int? id;
String? title;
CategoryItem( this.id,this.title);
  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  
 /* List doctors=[{
    'name':'Novel',
    'img':'images/A.jpg',
    'writer':'nofa mamoon'
    },
    {
    'name':'Children',
    'img':'images/B.jpg',
    'writer':'nofa mamoon'
    },
     {'name':'Health',
    'img':'images/C.jpg',
    'writer':'nofa mamoon'
    },
    {
    'name':'Sport',
    'img':'images/D.jpg',
    'writer':'nofa mamoon'
    },
     {
    'name':'Political',
    'img':'images/E.jpg',
    'writer':'nofa mamoon'
    },
     {
    'name':'science',
    'img':'images/F.jpg',
    'writer':'nofa mamoon'
    },
  ];*/
 int ?usid;
 int? myid;
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
  Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/catitem/$myid';
    //print('>>>>>>>>>>>>>>>>>>>');
    //print(myid);
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
  Doctor user=new Doctor(u['id'],u['name'],u['image'],u['writer'],u['description']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('id') ?? 0;
}
void getid()async{
      usid=await getUserId();
  }
  //fav
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
   @override
  void initState() {
  setState(() {
    myid=widget.id;
  });
getid();
    getDoctors();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!,style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2),),
     elevation:0,
      backgroundColor: Colors.orange,
      centerTitle: true,
      ),
      body: FutureBuilder(
        future: getDoctors(),
        builder:(context,AsyncSnapshot snapshot){
          if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return InkWell(
  child: Container(
    height: 400,
    /*child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context,i){
        return Text('hi');
      }),*/
        //margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context,i){
         return 
      Card(
              
          child:  Row(
            
          children: [
            
            Container(
             // width: 80,
             // child:Flexible(child: Image.asset(doctors[i]['img'],fit: BoxFit.cover,width: 130,) ),
             child: Flexible(child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image
             ,fit:BoxFit.cover,width: 130,)),
            ),
            SizedBox(width: 40,),
            Column(
              children: [
                Container(
                  child: Text('${snapshot.data[i].name}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
                SizedBox(height: 20,),
                 Container(
                  child: Text('${snapshot.data[i].description}',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,color: Colors.grey)),
                ),
                SizedBox(height: 15,),
               
                SizedBox(height: 15,),
                 Container(
                  child: ElevatedButton(
                    onPressed:(){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OneBook(snapshot.data[i].id)));
                    },
                    child: Text('See more',
                    style: TextStyle(fontSize: 20,wordSpacing: 2,fontWeight: FontWeight.bold,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(150, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
                ),
              ],
            )
          ],
        ));
    
          }
          )
      ),
);
        }
        )
    );
  }
}
class Doctor{
  final int id;
  final String name,image,writer,description;
  
  Doctor(this.id,this.name,this.image,this.description,this.writer);
}
/*
   return Card(
              
          child:  Row(
            
          children: [
            
            Container(
             // width: 80,
             // child:Flexible(child: Image.asset(doctors[i]['img'],fit: BoxFit.cover,width: 130,) ),
             child: Flexible(child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image
             ,fit:BoxFit.cover,width: 130,)),
            ),
            SizedBox(width: 40,),
            Column(
              children: [
                Container(
                  child: Text('${snapshot.data[i].name}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
                SizedBox(height: 20,),
                 Container(
                  child: Text('${snapshot.data[i].description}',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,color: Colors.grey)),
                ),
                SizedBox(height: 15,),
               
                SizedBox(height: 15,),
                 Container(
                  child: ElevatedButton(
                    onPressed:(){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OneBook(snapshot.data[i].id)));
                    },
                    child: Text('See more',
                    style: TextStyle(fontSize: 20,wordSpacing: 2,fontWeight: FontWeight.bold,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(150, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
                ),
              ],
            )
          ],
        ));
*/