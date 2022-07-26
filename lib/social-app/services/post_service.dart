
import 'dart:convert';

import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:soci/social-app/models/post.dart';
import 'package:soci/social-app/services/user_service.dart';
//get all post
Future<ApiResponse> getPosts()async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.209.189:8000/api/posts'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['posts'].map((p)=>Post.fromJson(p)).toList();
      apiResponse.data as List<dynamic>;
      break;
      case 401:
      apiResponse.error=unauthorized;
      break;
    }
  }
  catch(e){
    apiResponse.error=serverError;
  }
  return apiResponse;
}
//create post
Future<ApiResponse> createPost(String body,String? image)async{
  ApiResponse apiResponse=ApiResponse();
  print('//////////////////');
  print(body);
  try{
    Map data1 = {
    'body':body,
        'image':image
    };
    var bo1= json.encode(data1);
     Map data2 = {
     'body':body
    };
    var bo2 = json.encode(data2);
    String token=await getToken();
    final response=await http.post(
      Uri.parse('http://192.168.209.189:8000/api/posts'),
      headers: {
         "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: image !=null ? bo1:bo2
    );
    print('*************************');
  print(response.body);
    switch(response.statusCode){
      case 200:
        apiResponse.data=jsonDecode(response.body);
        break;
        case 422:
        final errors=jsonDecode(response.body)['errors'];
        apiResponse.error=errors[errors.keys.elementAt(0)][0];
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

//edit post
Future<ApiResponse> editPost(int postId,String body)async{
ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
     Map data1 = {
    'body':body,
    };
    var bo1= json.encode(data1);
    final response=await http.put(
      Uri.parse('http://192.168.209.189:8000/api/posts/$postId'),
      headers: {
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: bo1
    );
      switch(response.statusCode){
      case 200:
        apiResponse.data=jsonDecode(response.body)['message'];
        break;
        case 403:
        apiResponse.error=jsonDecode(response.body)['message'];
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

//delete post
Future<ApiResponse> deletPost(int postId)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.delete(
Uri.parse('http://192.168.209.189:8000/api/posts/$postId'),
 headers: {
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );
     switch(response.statusCode){
      case 200:
        apiResponse.data=jsonDecode(response.body)['message'];
        break;
        case 403:
        apiResponse.error=jsonDecode(response.body)['message'];
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
//like or unlike post
Future<ApiResponse> likeUnLikePost(int postId)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.post(
Uri.parse('http://192.168.209.189:8000/api/posts/$postId/likes'),
headers: {
   "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
}
    );
    switch(response.statusCode){
      case 200:
         apiResponse.data=jsonDecode(response.body)['message'];
         break;
         case 401:
         apiResponse.error=unauthorized;
         break;
    }
  }
  catch(e){
    apiResponse.error=serverError;
  }
  return apiResponse;
}