
import 'dart:convert';
import 'dart:io';

import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:soci/social-app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
//login
Future<ApiResponse> login(String email,String password)async{
ApiResponse apiResponse=ApiResponse();
print('////////////////////////////');
print(email);
print(password);
try{
  Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
final response=await http.post(
Uri.parse('http://192.168.209.189:8000/api/login'),
headers: {"Content-Type": "application/json"},
body:body
);
print("*****************");
print(response.body);
switch(response.statusCode){
  case 200:
  apiResponse.data=User.fromJson(jsonDecode(response.body));
  break;
  case 422:
  final errors=jsonDecode(response.body)['errors'];
  apiResponse.error=errors[errors.keys.elementAt(0)][0];
  break;
  case 403:
  apiResponse.error=jsonDecode(response.body)['message'];
  break;
  
  
}
}catch(e){
apiResponse.error=serverError;
}
return apiResponse;
}
//register
Future<ApiResponse> register(String name,String email,String password)async{
ApiResponse apiResponse=ApiResponse();
print('////////////////////////////');
print(name);
print(email);
print(password);
try{
  Map data = {
    "name":name,
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
final response=await http.post(
Uri.parse('http://192.168.209.189:8000/api/register'),
//headers: {'Accept': 'application/json'},
headers: {"Content-Type": "application/json"},
body:body
);
print("*****************");
print(response.body);
switch(response.statusCode){
  case 200:
  apiResponse.data=User.fromJson(jsonDecode(response.body));
  break;
  case 422:
  final errors=jsonDecode(response.body)['errors'];
  apiResponse.error=errors[errors.keys.elementAt(0)][0];
  break;
 
  
  
}
}catch(e){
apiResponse.error=serverError;
}
return apiResponse;
}
//user detail
Future<ApiResponse> getUserDetail()async{
ApiResponse apiResponse=ApiResponse();
try{
  String token=await getToken();
final response=await http.get(
//Uri.parse(userUrl),
Uri.parse('http://192.168.209.189:8000/api/user'),
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
);
print('/////////////////');
print(response.body);
switch(response.statusCode){
  case 200:
  apiResponse.data=User.fromJson(jsonDecode(response.body));
  break;
  case 401:
  final errors=unauthorized;
  break;
 
  
  
}
}catch(e){
apiResponse.error=serverError;
}
return apiResponse;
}
//get token
Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
//get user id
Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('userId') ?? 0;
}
//logout
Future<bool> logout()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return await pref.remove('token');
}
//get base64 encoded image
String? getStringImage(File? file){
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
//update user
Future<ApiResponse> updateUser(String name,String? image)async{
ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
     Map data1 = {
    'name':name,
    };
    var bo1= json.encode(data1);
    Map data2={
'name':name,
'image':image
    };
    var bo2= json.encode(data2);
    final response=await http.put(
      Uri.parse('http://192.168.209.189:8000/api/user'),
      headers: {
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: image == null ? bo1:bo2
    );
      switch(response.statusCode){
      case 200:
        apiResponse.data=jsonDecode(response.body)['message'];
        break;
        case 401:
        apiResponse.error=unauthorized;
        break;

      }
  }catch(e){
    apiResponse.error=serverError;
  }
  return apiResponse;
}