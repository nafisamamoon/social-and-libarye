import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FavoriteList extends StatefulWidget {
  const FavoriteList({ Key? key }) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  int? userId;
  Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('id') ?? 0;
}
void getid()async{
      userId=await getUserId();
  }
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/fav/$userId';
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
  Doctor user=new Doctor(u['id'],u['member_id'],u['book_id'],u['book']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  @override
  void initState() {
    getid();
    print(userId);
    getDoctors();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        margin: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context,i){
            return Card(
              
          child:  Row(
            
          children: [
            
            Container(
             // width: 80,
             // child:Flexible(child: Image.asset(doctors[i]['img'],fit: BoxFit.cover,width: 130,) ),
             child: Flexible(child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].book['image']
             ,fit:BoxFit.cover,width: 130,)),
            ),
            SizedBox(width: 40,),
           Column(
              children: [
                Container(
                  child: Text('${snapshot.data[i].book['name']}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                ),
               SizedBox(height: 20,),
                 Container(
                  child: Text('${snapshot.data[i].book['writer']}',style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 18,color: Colors.grey)),
                ),
               SizedBox(height: 20,),
                 Container(
                  child: Icon(Icons.favorite,color: Colors.red,)
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
        ),
    );
  }
}
class Doctor{
  final int id,member_id,book_id;
  final Map book;
  Doctor(this.id,this.member_id,this.book_id,this.book);
}