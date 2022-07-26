import 'package:flutter/material.dart';
import 'package:soci/libary/login.dart';
//import 'package:soci/social-app/screens/login.dart';

import 'social-app/screens/loading.dart';

void main() {
  runApp(const App());
}
class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // home: Loading(),
     home: Login(),
    );
  }
}


