import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soci/libary/Book.dart';
import 'package:soci/libary/api-response.dart';
import 'package:http/http.dart' as http;
Future<String> getToken()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getString('token') ?? '';
}
//get user id
Future<int> getUserId()async{
SharedPreferences pref=await SharedPreferences.getInstance();
return pref.getInt('userId') ?? 0;
}
//get all post
Future<ApiResponse> getPosts()async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.178.189:8000/api/pop'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['pop'].map((p)=>Popular.fromJson(p)).toList();
      apiResponse.data as List<dynamic>;
      break;
   
    }
  }
  catch(e){
   print('fail');
  }
  return apiResponse;
}
Future<ApiResponse> getCategory()async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.178.189:8000/api/getcat'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['cat'].map((c)=>Category.fromJson(c)).toList();
      apiResponse.data as List<dynamic>;
      break;
   
    }
  }
  catch(e){
   print('fail');
  }
  return apiResponse;
}
Future<ApiResponse> getBest()async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.178.189:8000/api/best'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['best'].map((p)=>Best.fromJson(p)).toList();
      apiResponse.data as List<dynamic>;
      break;
   
    }
  }
  catch(e){
   print('fail');
  }
  return apiResponse;
}
Future<ApiResponse> getOnebook(int id)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.178.189:8000/api/onebook/$id'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['one'].map((o)=>Onebook.fromJson(o)).toList();
      apiResponse.data as List<dynamic>;
      break;
   
    }
  }
  catch(e){
   print('fail');
  }
  return apiResponse;
}
Future<ApiResponse> getcom(int id)async{
  ApiResponse apiResponse=ApiResponse();
  try{
    String token=await getToken();
    final response=await http.get(
      Uri.parse('http://192.168.178.189:8000/api/allcomment/$id'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      }
    );
    switch(response.statusCode){
      case 200:
      apiResponse.data=jsonDecode(response.body)['comment'].map((c)=>Commente.fromJson(c)).toList();
      apiResponse.data as List<dynamic>;
      break;
   
    }
  }
  catch(e){
   print('fail');
  }
  return apiResponse;
}