import 'package:flutter/material.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/screens/home.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/services/user_service.dart';
class Loading extends StatefulWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo()async{
String token=await getToken();
print('//////////////////////////');
print(token);
if(token == ''){
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
}else{
  ApiResponse response=await getUserDetail();
  if(response.error == null){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Home()), (route) => false);
  }else if(response.error == unauthorized){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>Login()), (route) => false);
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${response.error}')));
  }
}
  }
  void test()async{
ApiResponse response=await getUserDetail();
  }
  @override
  void initState() {
    _loadUserInfo();
   //test();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
     height: MediaQuery.of(context).size.height,
     color: Colors.white,
     child: Center(
       child: CircularProgressIndicator(),
     ), 
    );
  }
}