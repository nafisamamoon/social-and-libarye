import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/global.dart';
//import 'package:myauth/token-test/global-token.dart';
//import 'package:myauth/globals.dart';
class OneLoginServices {
static Future<http.Response> login(String email, String password) async {
    Map data = {
      "email": email,
      "password": password,
    };
    var body = json.encode(data);
    
    var url = Uri.parse('http://192.168.178.189:8000/api/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    //print(response.body);
    return response;
  }
}

class RegisterService{
 static Future<http.StreamedResponse> register(String name,String email,String password,String about,String image)async{

 /* Map data = {
    "name":name,
      "email": email,
      "password": password,
      'about':about,
      'image':image
    };
    var body = json.encode(data);
final response=await http.post(
Uri.parse('http://192.168.184.189:8000/api/register'),
//headers: {'Accept': 'application/json'},
headers: {"Content-Type": "application/json"},
body:body
);*/
var url='http://192.168.178.189:8000/api/register';
 var request=http.MultipartRequest('POST',Uri.parse(url));
 request.files.add(await http.MultipartFile.fromPath("image",image));
 request.fields.addAll({
//'name':namecontroller.text,
"name":name,
      "email": email,
      "password": password,
      'about':about,
 });
// request.fields['name']=nam
 request.headers.addAll({
   'Content-type':'multipart/form-data',
  // 'Authorization': 'Bearer $token'

 });
var response=request.send();
return response ;
}
}
class create{
static Future<http.Response> come(String com,int id)async{
  Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
String token=await getToken();
  Map data = {
    "comment":com,
    
    };
    var body = json.encode(data);
final response=await http.post(
Uri.parse('http://192.168.178.189:8000/api/storecomment/$id'),
//headers: {'Accept': 'application/json'},
headers: {"Content-Type": "application/json",
'Authorization': 'Bearer $token'
},
body:body
);

return response ;
}
}