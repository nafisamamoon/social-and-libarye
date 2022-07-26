import 'package:flutter/material.dart';

const baseUrl='http://192.168.209.189:8000/api';
const loginUrl=baseUrl+'/login';
const registerUrl=baseUrl+'/register';
const logoutUrl=baseUrl+'/logout';
const userUrl=baseUrl+'/user';
const postsUrl=baseUrl+'/posts';
const commentsUrl=baseUrl+'/comments';


const serverError='Server error';
const unauthorized='Unauthorized';
const somethingWentWrong='something went wrong,try again!';

//input decoration
InputDecoration kInputDecoration(String label){
  return InputDecoration(
  labelText: label,
  contentPadding: EdgeInsets.all(10),
  border: OutlineInputBorder(borderSide: BorderSide(width: 1,color: Colors.black))
);
}
//Button
TextButton kTextButton(String label,Function onpressed){
  return TextButton(onPressed: ()=>onpressed(),
             child: Text(label,style: TextStyle(color: Colors.white),),
             style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
             padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
             ),
             );
}

//LoginRegisterHint
Row kLoginRegisterHint(String text,String label,Function onTap){
  return  Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Text(text),
                 GestureDetector(
                   child: Text(label,style: TextStyle(color: Colors.blue),),
                   onTap: ()=>onTap(),
                 )
               ],
             );
}
//likes and comment btn
Expanded kLikeAndComment(int value,IconData icon,Color color,Function onTap){
  return Expanded(
        child: Material(
          child: InkWell(
            onTap:()=>onTap(),
            child: Padding(padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,size: 16,color: color,),
                SizedBox(width: 4,),
                Text('$value')
              ],
            ),
            ),
          ),
        )
        );
}