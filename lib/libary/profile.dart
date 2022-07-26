import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/edit-profile.dart';
import 'package:soci/libary/login.dart';
class Profile extends StatefulWidget {
  //const Profile({ Key? key }) : super(key: key);
int? id;
Profile(this.id);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  save(String token) async {
  final pref=await SharedPreferences.getInstance();
  final Key='token';
  final ValueKey=token;
  pref.setString(Key,ValueKey);
}
Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
  Future<List<Pro>>getProfile() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/profile/${widget.id}';
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

print('**********************');
print('///////////////////');
print(jsonDatae);
List<Pro> doctors=[];
for(var u in jsonDatae){
  Pro user=new Pro(u['id'],u['name'],u['image'],u['email'],u['about']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(),
      body: FutureBuilder(
      future: getProfile(),
      builder: (context,AsyncSnapshot snapshot){
            if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return Container(
 // margin: EdgeInsets.only(top: 70),
child: ListView.builder(
   shrinkWrap: true,
    itemCount: snapshot.data.length, 
  itemBuilder: (context,i){
    return Container(
      child: Column(
        children: [
          Container(
            
            height: 280,
            color: Colors.orange[300],
            alignment: Alignment.bottomCenter,
          //  margin: EdgeInsets.only(top: 22),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
              child:  CircleAvatar(
        backgroundImage:NetworkImage('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image),
        radius: 70,
       
            )),
         SizedBox(height: 11,),
    Container(
   child: Text('${snapshot.data[i].name}',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,fontSize: 17,color: Colors.white),)
  ),
   SizedBox(height: 11,),
  Container(
    child: Text('${snapshot.data[i].email}',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,fontSize: 17,color: Colors.white)),
  ),

              ],
            )
          ),
          SizedBox(height: 65,),
          Container(
            height: 230,
            margin: EdgeInsets.all(10),
            child: Card(
              elevation: 7,
              child: Column(
                children: [
                 Container(
                   margin: EdgeInsets.all(17),
                   child:  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text('About',style: TextStyle(wordSpacing: 3,fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(width: 250,),
                       Container(
                        child: Icon(Icons.description,color: Colors.orange[300])
                      ),
                    ],
                  ),
                 ),
                  Divider(),
                  Container(
         child: Text('${snapshot.data[i].about}',style: TextStyle(wordSpacing: 2,fontSize: 15,color: Colors.grey)),           
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 70,),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               ElevatedButton(
                    onPressed:(){
 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile(
   snapshot.data[i].id,
   snapshot.data[i].name,
   snapshot.data[i].email,
   snapshot.data[i].image,
   snapshot.data[i].about

   )));
                    },
                    child: Text('Edit',
                    style: TextStyle(fontSize: 25,wordSpacing: 2,fontWeight: FontWeight.w400,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange[300],
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),),
                    SizedBox(width: 8,)  ,
                   ElevatedButton(
                    onPressed:(){
                     save('0');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Text('Logout',
                    style: TextStyle(fontSize: 25,wordSpacing: 2,fontWeight: FontWeight.w400,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange[300],
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ), 
              ],
            ),
          )
        ],
      ),
    );
  }
  ),
);
       } ),
    );
  }
}
class Pro{
  final int id;
  final String name,image,email,about;
  Pro(this.id,this.name,this.image,this.email,this.about);
}
/*
Container(
      child: Column(
        children: [
           Container(
      child: CircleAvatar(
        backgroundImage:NetworkImage('http://192.168.184.189:8000/uploads/'+snapshot.data[i].image),
        radius: 70,
       
      ),
    ),
    SizedBox(height: 11,),
    Container(
   child: Text('${snapshot.data[i].name}',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,fontSize: 17),)
  ),
   SizedBox(height: 11,),
  Container(
    child: Text('${snapshot.data[i].email}',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,fontSize: 17)),
  ),
   SizedBox(height: 11,),
  Container(
    child: Text('${snapshot.data[i].about}',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,fontSize: 17)),
  ),
   SizedBox(height: 180,),
   ElevatedButton(
                    onPressed:(){
 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProfile(
   snapshot.data[i].id,
   snapshot.data[i].name,
   snapshot.data[i].email,
   snapshot.data[i].image,
   snapshot.data[i].about

   )));
                    },
                    child: Text('Edit',
                    style: TextStyle(fontSize: 25,wordSpacing: 2,fontWeight: FontWeight.w400,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
                      SizedBox(height: 40,),
   ElevatedButton(
                    onPressed:(){
                     save('0');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Text('Logout',
                    style: TextStyle(fontSize: 25,wordSpacing: 2,fontWeight: FontWeight.w400,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
        ],
      ),
    );
*/