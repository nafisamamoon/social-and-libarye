import 'package:flutter/material.dart';
import 'package:soci/libary/favorite-list.dart';
import 'package:soci/libary/profile.dart';
import 'package:soci/libary/test.dart';
import 'package:soci/libary/user-home.dart';
class Bar extends StatefulWidget {
  //const Bar({ Key? key }) : super(key: key);
int? id;
Bar(this.id);
  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  
  int? u;
  int index=0;
  
  @override
  void initState() {
     u=widget.id!;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> screens=[
Profile(u),
UserHome(),
Test(),
FavoriteList()
  ];
    return Scaffold(
      body: screens[index],
        bottomNavigationBar:BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          onTap: (val){
setState(() {
  index=val;
});
          },
          currentIndex: index,
        elevation: 10,
     items: [
       BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
              BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
               BottomNavigationBarItem(icon: Icon(Icons.favorite_border),label: 'Add favorite'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorite list'),
     ],
      ),
    );
  }
}