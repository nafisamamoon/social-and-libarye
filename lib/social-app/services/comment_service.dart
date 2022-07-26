


import 'dart:convert';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/services/user_service.dart';
import 'package:soci/social-app/models/comment.dart';
import 'package:http/http.dart' as http;
//get post comments
Future<ApiResponse> getComments(int postId)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.209.189:8000/api/posts/$postId/comments'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['comments'].map((p)=>Comment.fromJson(p)).toList();
      apiResponse.data as List<dynamic>;
      break;
      case 401:
      apiResponse.error=unauthorized;
      break;
      case 403:
      apiResponse.error=jsonDecode(response.body)['message'];
      break;
    }
  }
  catch(e){
    apiResponse.error=serverError;
  }
  return apiResponse;
}

//create comment
Future<ApiResponse> createComment(int postId,String comment)async{
ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
     Map data1 = {
    'comment':comment,
    };
    var bo1= json.encode(data1);
    final response=await http.post(
      Uri.parse('http://192.168.209.189:8000/api/posts/$postId/comments'),
      headers: {
          "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
      body: bo1
    );
      switch(response.statusCode){
      case 200:
        apiResponse.data=jsonDecode(response.body);
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

//delete comment
Future<ApiResponse> deleteComment(int commentId)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.delete(
Uri.parse('http://192.168.209.189:8000/api/comments/$commentId'),
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

//edit comment
Future<ApiResponse> editComment(int commentId,String comment)async{
ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
     Map data1 = {
    'comment':comment,
    };
    var bo1= json.encode(data1);
    final response=await http.put(
      Uri.parse('http://192.168.209.189:8000/api/comments/$commentId'),
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