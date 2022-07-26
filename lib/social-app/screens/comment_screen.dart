import 'package:flutter/material.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/comment.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/services/comment_service.dart';
import 'package:soci/social-app/services/user_service.dart';
class CommentScreen extends StatefulWidget {
 // const CommentScreen({ Key? key }) : super(key: key);
final int? postId;
CommentScreen({
  this.postId
});
  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList=[];
  bool load=true;
  int userId=0;
  TextEditingController  _txtCommentController=TextEditingController();
  int _editCommentId=0;
  //get comments
  Future<void> _getComments()async{
    userId=await getUserId();
    ApiResponse response=await getComments(widget.postId ?? 0);
    if(response.error == null){
  setState(() {
    _commentsList=response.data as List<dynamic>;
    load= load ? !load : load;
  });
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
  }
  //create comment
  void _createComment()async{
    ApiResponse response=await createComment(widget.postId ?? 0,_txtCommentController.text);
     if(response.error == null){
  _txtCommentController.clear();
  _getComments();
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      setState(() {
        load=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
  }
  //delete comment
  void _deleteComment(int commentId)async{
    ApiResponse response=await deleteComment(commentId);
     if(response.error == null){
  _getComments();
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
  }
  //edit comment
 void _editComment()async{
   ApiResponse response=await editComment(_editCommentId, _txtCommentController.text);
     if(response.error == null){
       _editCommentId=0;
       _txtCommentController.clear();
  _getComments();
}else if(response.error == unauthorized){
Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        load=!load;
      });
    }
 }
  @override
  void initState() {
    _getComments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('comments'),),
      body: load ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          Expanded(
            child:RefreshIndicator(
              child: ListView.builder(
                itemCount: _commentsList.length,
                itemBuilder: (context,i){
Comment comment=_commentsList[i];
return Container(
  padding: EdgeInsets.all(10),
  width: MediaQuery.of(context).size.width,
  decoration: BoxDecoration(
    border: Border(
      bottom: BorderSide(color: Colors.black26,width: 0.5)
    )
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
        Row(
    
    
    
      children: [
    
        Container(
    
          width: 30,
    
          height: 30,
    
          decoration: BoxDecoration(
    
            image: comment.user!.image != null ?DecorationImage(image: NetworkImage('${comment.user!.image}'),
    
            fit: BoxFit.cover
    
            ) : null,
    
            borderRadius: BorderRadius.circular(15),
    
            color: Colors.blueGrey
    
          ),
    
        ),
    
        SizedBox(width: 10,),
    
        Text('${comment.user!.name}',style: TextStyle(
    
          fontWeight: FontWeight.w600,fontSize: 16
    
        ),),
    
      ],
    
    ),
    comment.user!.id == userId ?
      PopupMenuButton(
        child: Padding(padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.more_vert,color: Colors.black,),
        ),
        itemBuilder: (context)=>[
          PopupMenuItem(
            child:Text('Edit') ,
            value: 'edit',
            ),
             PopupMenuItem(
            child:Text('Delete') ,
            value: 'delete',
            )
        ],
        onSelected: (val){
          if(val == 'edit'){
            setState(() {
              _editCommentId=comment.id ?? 0;
              _txtCommentController.text=comment.comment ?? '';
            });
    
          }else{
_deleteComment(comment.id ?? 0);
          }
        },
        ) : SizedBox()
  ],
),
SizedBox(height: 10,),
Text('${comment.comment}')
    ],
  ),
);
                }
                ),
               onRefresh: (){
                 return _getComments();
               }
               ) 
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black26,width: 0.5)
                )
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: kInputDecoration('Comment'),
                      controller: _txtCommentController,
                    )
                    ),
                    IconButton(
                      onPressed: (){
if(_txtCommentController.text.isNotEmpty){
  setState(() {
    load=true;
  });
  if(_editCommentId > 0){
 _editComment();
  }else{
     _createComment();
   
  }
 
}
                      },
                       icon: Icon(Icons.send)
                       )
                ],
              ),
            )
        ],
      ),
    );
  }
}