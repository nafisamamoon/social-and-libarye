import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class BookDetail extends StatefulWidget {
  //const BookDetail({ Key? key }) : super(key: key);
  int? id;
BookDetail(this.id);
  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  int? myid;
   Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
  Future<List<Doctor>>getDoctors() async {
  String token=await getToken();
    final String _url='http://192.168.178.189:8000/api/bookdetail/$myid';
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
  Doctor user=new Doctor(u['id'],u['name'],u['writer'],u['image'],u['description']);
  doctors.add(user);
}


print(doctors.length);
return doctors;
  }
  @override
  void initState() {
    setState(() {
    myid=widget.id;
  });
  getDoctors();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future:getDoctors(),
          builder:(context,AsyncSnapshot snapshot){
            if(snapshot.data ==null)
{
  return Container(child: Center(child: CircularProgressIndicator(),
  ),
  );
}else return 
  
Container(
        //padding: EdgeInsets.symmetric(horizontal: 15),
        margin:EdgeInsets.only(top:1),
        width: double.infinity,
        child:ListView.builder(
      shrinkWrap: true,
        itemCount: snapshot.data.length, 
          itemBuilder: (context,i){
            return Container(
              child: Column(
                children: [
                 Container(
                  
                   color: Colors.red,
                height: 400,
                width: double.infinity,
                child: Image.network('http://192.168.178.189:8000/uploads/'+snapshot.data[i].image
            ,fit: BoxFit.cover,),
              ),
             
              Container(
                alignment: Alignment.center,
                height: 700,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18)
                  )
                ),
                child: Column(children: [
   Container(
     margin:EdgeInsets.only(top:40) ,
              child:  Text('${snapshot.data[i].name}',style: TextStyle(fontSize: 20,color: Colors.grey),)
              ),
              SizedBox(height: 10,),
               Container(
              child:  Text('${snapshot.data[i].description}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),)
              ),
               SizedBox(height: 18,),
               Container(
              child:  Text('${snapshot.data[i].writer}',style: TextStyle(fontSize: 20,color: Colors.white),)
              ),
              SizedBox(height: 40,),
               Container(
              child:  ElevatedButton(
                    onPressed:(){
                    Navigator.of(context).pop();
                  
                    },
                    child: Text('BACK',
                    style: TextStyle(fontSize: 30,wordSpacing: 2,fontWeight: FontWeight.w900,color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      //fixedSize: Size(370, 70),
                      fixedSize: Size(170, 70),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
                    ),
                    ),
              ),
                ],),
              )
                ],
              ),
            );
          }
          )
      );
          }
          ),
    );
  }
}
class Doctor{
  final int id;
  final String name,writer,image,description;
  
  Doctor(this.id,this.name,this.writer,this.image,this.description);
}