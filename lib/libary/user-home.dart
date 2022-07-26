import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/Book.dart';
import 'package:soci/libary/api-response.dart';
import 'package:soci/libary/book-fav.dart';
import 'package:soci/libary/category-item.dart';
import 'package:soci/libary/login.dart';
import 'package:soci/libary/test.dart';
class UserHome extends StatefulWidget {
 // const UserHome({ Key? key }) : super(key: key);
//int? id;
//UserHome(this.id);
  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int SelectedIndex=0;
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
/*Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.184.189:8000/api/getcat';
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
  Doctor user=new Doctor(u['id'],u['name'],u['image']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  Future<List<Profilee>>getProfile() async {
  String token=await getToken();
    final String _url='http://192.168.184.189:8000/api/pop';
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

print('**********************');
print('///////////////////');
print(jsonDatae);
List<Profilee> doctors=[];
for(var u in jsonDatae){
  Profilee user=new Profilee(u['id'],u['name'],u['writer'],u['image'],u['description']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }*/
    List<dynamic> _postList=[];
   List<dynamic> _categoryList=[];
   List<dynamic> _bestList=[];
    Future<void> retrivePosts()async{
   // userId=await getUserId();
    ApiResponse response=await getPosts();
    if(response.error == null){
      setState(() {
        _postList=response.data as List<dynamic>;
        //print(_postList);
        //load=load ? !load : load;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    
    }
  }
  Future<void>  getCat()async{
   // userId=await getUserId();
    ApiResponse response=await  getCategory();
    if(response.error == null){
      setState(() {
        _categoryList=response.data as List<dynamic>;
      //  print(_categoryList);
        //load=load ? !load : load;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    
    }
  }
  Future<void> bestSeller()async{
   // userId=await getUserId();
    ApiResponse response=await getBest();
    if(response.error == null){
      setState(() {
        _bestList=response.data as List<dynamic>;
        print(_bestList);
        //load=load ? !load : load;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    
    }
  }
  @override
  void initState() {
   // getDoctors();
    //getProfile();
    getCat();
    retrivePosts();
    bestSeller();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Categories'),
        centerTitle: true,
          actions: [
         
       IconButton(onPressed: (){
         save('0');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
       }, icon: Icon(Icons.logout))
      ],
      ),*/
     
    body: Container(
         child:Column(
          children: [
         
         // SizedBox(height: 15,),
          //////////////////////////////////////////////////
       Flexible(
         child: ListView.builder(
            scrollDirection: Axis.horizontal,
           itemCount:_categoryList.length ,
           itemBuilder: (context,i){
               Category cat=_categoryList[i];
               return Row(
     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[ 
          InkWell(
                 onTap: (){
                 
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryItem(cat.id,cat.name)));   
              },
         child: Container(
           margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(17),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),borderRadius: BorderRadius.circular(10)
            ),
        
          child: Text('${cat.name}'),
        )),
       SizedBox(width: 20,)
       ]
        
      ); 
           }
           )),
          Row(
              children: [
                Container(
            margin: EdgeInsets.only(right: 200,left: 20),
            child:  Text('Popular book',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2)),
          ),
          Container(
            child: TextButton(onPressed: (){}, child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                 border: Border.all(color: Colors.orange),borderRadius: BorderRadius.circular(10)
              ),
              child: Text('View all'),)),
          )
              ],
            ),
        Flexible(
          child: ListView.builder(
             scrollDirection: Axis.horizontal,
            itemCount: _postList.length,
            itemBuilder:(context,i){
               Popular post=_postList[i];
               return 
               Container(
                 child:Flex(direction: Axis.horizontal,
                   children: [
                     Card(child: Image.network('http://192.168.184.189:8000/uploads/${post.image}') ,),
                   
                   ],
                 )
                  
                
               );
            }
            )),
            Row(
              children: [
                Container(
            margin: EdgeInsets.only(right: 210,left: 20),
            child:  Text('Best Seller',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2),),
          ),
          Container(
            child: TextButton(onPressed: (){}, child:  Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                 border: Border.all(color: Colors.orange),borderRadius: BorderRadius.circular(10)
              ),
              child: Text('View all'),)),
          )
              ],
            ),
             Flexible(
          child: ListView.builder(
             scrollDirection: Axis.horizontal,
            itemCount: _bestList.length,
            itemBuilder:(context,i){
               Best best=_bestList[i];
               return Container(
                 child:Flex(direction: Axis.horizontal,
                   children: [
                     Card(child: Image.network('http://192.168.184.189:8000/uploads/${best.image}') ,),
                   
                   ],
                 )
                  
                
               );
            }
            ))
          ],
        )
      ),
    
    );
  }
}
class Doctor{
  final int id;
  final String name,image;
  Doctor(this.id,this.name,this.image);
}
class Profilee{
  final int id;
  final String name,writer,image,description;
  Profilee(this.id,this.name,this.writer,this.image,this.description);
}
/*
  body:  Container(
        child: FutureBuilder(
          future: getDoctors(),
          builder:(context,AsyncSnapshot snapshot){
            if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return 
  
Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin:EdgeInsets.only(top:50),
        
        child:GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200,
        childAspectRatio:0.85,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15
        ),
        itemCount: snapshot.data.length, 
          itemBuilder: (context,i){
            return InkWell(
              onTap: (){
                 //print('>>>>>>>>>>>>>>>>>>>');
                 // print(snapshot.data[i].name);
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryItem(snapshot.data[i].id,snapshot.data[i].name)));   
   
              },
child: Container(
  color: Colors.orange,
  child: Card(
    //color: Colors.orange,
    elevation:6,
    child: Column(
      children: [
         Container(
   margin: EdgeInsets.only(top: 15),
    height: 100,
    width: 200,
    decoration: BoxDecoration(
 //color: Colors.red,
    ),
    child: Image.network('http://192.168.184.189:8000/uploads/'+snapshot.data[i].image,),
   
  ),
  SizedBox(height: 8,),
   Container(
     alignment: Alignment.center,
     width: double.infinity,
     height: 30,
     color: Colors.white,
     margin: EdgeInsets.only(top:30),
     child: Text('${snapshot.data[i].name}',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
   ),
      ],
    ),
  ),
),
           );
          }
          )
      );
          }
          ),
      ),
*/