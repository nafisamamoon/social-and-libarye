import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/Book.dart';
import 'package:soci/libary/add-book.dart';
import 'package:soci/libary/add-category.dart';
import 'package:soci/libary/api-response.dart';
import 'package:soci/libary/book-fav.dart';
import 'package:soci/libary/category-item.dart';
import 'package:soci/libary/login.dart';
import 'package:http/http.dart' as http;
class AdminHome extends StatefulWidget {
 // const AdminHome({ Key? key }) : super(key: key);
//int? id;
//AdminHome(this.id);
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
 /* List doctors=[{
    'name':'Novel',
    'img':'images/writing.png'
    },
    {
    'name':'Children',
    'img':'images/children.png'
    },
     {'name':'Health',
    'img':'images/hi.png'
    },
    {
    'name':'Sport',
    'img':'images/football.png'
    },
     {
    'name':'Political',
    'img':'images/conference.png'
    },
     {
    'name':'science',
    'img':'images/science.png'
    },
  ];*/
  
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


List<Doctor> doctors=[];
for(var u in jsonDatae){
  Doctor user=new Doctor(u['id'],u['name'],u['image']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }*/
/*Future<List<Pop>>pop() async {
  String token=await getToken();
    final String _url='http://192.168.184.189:8000/api/pop';
var response=await http.get(Uri.parse(_url),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
var jsonDatae=jsonDecode(response.body);

print('**********************');
print('///////////////////pop');
print(jsonDatae);
List<Pop> doctors=[];
for(var u in jsonDatae){
  Pop user=new Pop(u['id'],u['name'],u['writer'],u['image'],u['description']);
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
  List icons=[Icons.foundation_outlined,Icons.inbox_rounded,Icons.settings,Icons.email,Icons.add_a_photo,Icons.alarm_add_rounded];
  @override
  void initState() {
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
        title: Text('Categories',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
          actions: [
         
       IconButton(onPressed: (){
         save('0');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
       }, icon: Icon(Icons.logout))
      ],
      ),
      drawer: Drawer(
      child: ListView(children: [
      
        ListTile(
          title: Text('add category'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddCategory()));
          },
        ),
        SizedBox(height: 10,),
         ListTile(
          title: Text('add book'),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddBook()));
          },
        ),
      ],),
      ),*/
    body: SafeArea(
child:Padding( 
  padding: const EdgeInsets.all(10.0),
      child:SingleChildScrollView(
      child: Column(
        children: [
          Padding(
        padding: EdgeInsets.only(right: 290,top: 10),
            child:Text('category',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17))
          ),
            Container(
             height: 100,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: _categoryList.length,
               itemBuilder: (context,i){
                 Category cat=_categoryList[i];
                 return Padding(
      padding: const EdgeInsets.only(right:8.0,left: 8),
      child: Column(
        children: [
          InkWell(
            onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryItem(cat.id,cat.name))); 
            },
            child:
          Container(
            height: 70,
            width: 70,
         decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(50)
            ),
            child: Icon(icons[i],color: Colors.orange,size: 30,),
          )),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(cat.name!),
          ),
      
        ],
      ),
    );
               }),
                   ),
                      Padding(
     padding: const EdgeInsets.only(top: 10,bottom: 10),
   child:Text('Popular books',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                   ),
    Container(
             height: 420,
          //  color: Colors.blue,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: _postList.length,
               itemBuilder: (context,i){
                  Popular post=_postList[i];
                 return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
     // color: Colors.red,
        width: 200,
        height: 900,
        child: Card(
child: Padding(
  padding: const EdgeInsets.only(top:18.0,left: 5),
  child:   Column(
    children: [
          Container(
            height: 300,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: NetworkImage('http://192.168.178.189:8000/uploads/${post.image}'),
              fit: BoxFit.cover,
              )
  
            ),
  
          ),
         Padding(
            padding: const EdgeInsets.only(top:8.0,left: 8),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('${post.name}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    Row(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //  Text('4.2'),
                        Row(
                          children: [
                           TextButton(onPressed: (){
                       
                           }, child: Text('more'),
                            style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[600],
                      //fixedSize: Size(370, 70),
                     // fixedSize: Size(70, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                           )
                          ],
                        ),
                    // Text('(12+)'),
                        ],
                      ),
                      SizedBox(width: 20,),
                     Row(
                       children: [
                        Padding(padding: EdgeInsets.only(left: 40),
                        child:     Text('\$45',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                        )
                       ],
                     )
                      ],
                    )
                    
                  ],
                ),
             
              ],
            ),
          )
  
    ],
  
  ),
),
        ),
      ),
    );;
               }),
                   ),
                   ////////////////////////////////////
                   Padding(
     padding: const EdgeInsets.only(top: 10,bottom: 10),
   child:Text('Best Sellers',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17)),
                   ),
    Container(
             height: 420,
          //  color: Colors.blue,
             child: ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount: _bestList.length,
               itemBuilder: (context,i){
                 Best best=_bestList[i];
                 return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
     // color: Colors.red,
        width: 200,
        height: 900,
        child: Card(
child: Padding(
  padding: const EdgeInsets.only(top:18.0,left: 5),
  child:   Column(
    children: [
          Container(
            height: 300,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(image: NetworkImage('http://192.168.178.189:8000/uploads/${best.image}'),
              fit: BoxFit.cover,
              )
  
            ),
  
          ),
         Padding(
            padding: const EdgeInsets.only(top:8.0,left: 8),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('${best.name}',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey),),
                    Row(
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //  Text('4.2'),
                        Row(
                          children: [
                           TextButton(onPressed: (){}, child: Text('more'),
                            style: ElevatedButton.styleFrom(
                      primary: Colors.yellow[600],
                      //fixedSize: Size(370, 70),
                     // fixedSize: Size(70, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                           )
                          ],
                        ),
                    // Text('(12+)'),
                        ],
                      ),
                      SizedBox(width: 20,),
                     Row(
                       children: [
                        Padding(padding: EdgeInsets.only(left: 40),
                        child:     Text('\$45',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo),),
                        )
                       ],
                     )
                      ],
                    )
                    
                  ],
                ),
             
              ],
            ),
          )
  
    ],
  
  ),
),
        ),
      ),
    );;
               }),
                   ),
        ],
      )))
      ),
    );
  }
}
class Doctor{
  final int id;
  final String name,image;
  Doctor(this.id,this.name,this.image);
}
/*
  body: Container(
         child:Column(
          children: [
          
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
*/