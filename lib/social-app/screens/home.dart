import 'package:flutter/material.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/screens/post.dart';
import 'package:soci/social-app/screens/post_form.dart';
import 'package:soci/social-app/screens/profile.dart';
import 'package:soci/social-app/services/user_service.dart';
class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog app'),
        actions: [
          IconButton(onPressed: (){},
           icon: Icon(Icons.exit_to_app)
           )
        ],
      ),
     body:currentIndex == 0 ? PostScreen() : Profile() ,
     floatingActionButton: FloatingActionButton(
       onPressed: (){
   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostForm(
     title: 'Add new post',
   )));
       },
       child: Icon(Icons.add),
       ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       bottomNavigationBar: BottomAppBar(
         notchMargin: 5,
         elevation: 10,
         clipBehavior: Clip.antiAlias,
         shape: CircularNotchedRectangle(),
         child: BottomNavigationBar(
           items: [
             BottomNavigationBarItem(
               icon: Icon(Icons.home),
               label: ''
             ),
              BottomNavigationBarItem(
               icon: Icon(Icons.person),
               label: ''
             ),
           ],
           currentIndex: currentIndex,
           onTap: (val){
setState(() {
  currentIndex=val;
});
           },
         ),
       ),
    );
  }
}
/*
Center(
       child: GestureDetector(
         onTap: (){
           logout().then((value) => {
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false)
           });
         },
         child: Text('home : press to logout')),
     ),*/