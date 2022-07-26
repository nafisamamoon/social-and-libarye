import 'package:flutter/material.dart';
import 'package:soci/libary/add-book.dart';
import 'package:soci/libary/add-category.dart';
import 'package:soci/libary/admin-home.dart';
import 'package:soci/libary/profile.dart';
class AdminBar extends StatefulWidget {
  //const AdminBar({ Key? key }) : super(key: key);
int? id;
AdminBar(this.id);
  @override
  State<AdminBar> createState() => _AdminBarState();
}

class _AdminBarState extends State<AdminBar> {
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
AdminHome(),
AddBook(),
AddCategory()
  ];
    return Scaffold(
      body: screens[index],
        bottomNavigationBar:BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 13),
          backgroundColor: Colors.orangeAccent,
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
                BottomNavigationBarItem(icon: Icon(Icons.book_sharp),label: 'Add Book'),
                   BottomNavigationBarItem(icon: Icon(Icons.add_outlined),label: 'Category'),
     ],
      ),
    );
  }
}