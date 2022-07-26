import 'package:flutter/material.dart';
import 'package:soci/social-app/constant.dart';
import 'package:soci/social-app/models/api_response.dart';
import 'package:soci/social-app/models/post.dart';
import 'package:soci/social-app/screens/comment_screen.dart';
import 'package:soci/social-app/screens/login.dart';
import 'package:soci/social-app/screens/post_form.dart';
import 'package:soci/social-app/services/post_service.dart';
import 'package:soci/social-app/services/user_service.dart';
class PostScreen extends StatefulWidget {
  const PostScreen({ Key? key }) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList=[];
  int userId=0;
  bool load=true;
  //get all post
  Future<void> retrivePosts()async{
    userId=await getUserId();
    ApiResponse response=await getPosts();
    if(response.error == null){
      setState(() {
        _postList=response.data as List<dynamic>;
        load=load ? !load : load;
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
  //post like dislike
  void _handlePostLikeDislike(int postId)async{
ApiResponse response=await likeUnLikePost(postId);
if(response.error == null){
  setState(() {
    retrivePosts();
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
  //delete post
  void _handleDeletePost(int postId)async{
    ApiResponse response=await deletPost(postId);
    if(response.error == null){
  setState(() {
    retrivePosts();
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
  @override
  void initState() {
    retrivePosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return load ? Center(child: CircularProgressIndicator(),):
    RefreshIndicator(
      onRefresh: (){
        return retrivePosts();
      },
      child: ListView.builder(
        itemCount: _postList.length,
        itemBuilder:(context,i){
          Post post=_postList[i];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 4,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Padding(padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
      image: post.user!.image != null ? DecorationImage(image: NetworkImage('${post.user!.image}')) : null,
    borderRadius: BorderRadius.circular(25),
    color: Colors.amber
            ),
          ),
          SizedBox(width: 10,),
          Text('${post.user!.name}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17),),
        ],
      ),
      ),
      post.user!.id== userId ? 
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostForm(
      title: 'Edit Post',
      post: post,
    )));
          }else{
    _handleDeletePost(post.id ?? 0);
          }
        },
        ) : SizedBox()
      ],
    ),
    SizedBox(height: 12,),
    Text('${post.body}'),
    post.image != null ? Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
      image: DecorationImage(image: NetworkImage('${post.image}'),
      fit: BoxFit.cover
      )
      ),
    ) : SizedBox(height: post.image != null ? 0 : 10,),
    Row(children: [
     kLikeAndComment(
       post.likesCount ?? 0, 
     post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
      post.selfLiked == true ? Colors.red : Colors.black38, 
      (){
_handlePostLikeDislike(post.id ?? 0);
      }
      ),
        Container(
          height: 25,
          width: 0.5,
color: Colors.black38,        ),
 kLikeAndComment(
       post.commentsCount ?? 0, 
     Icons.sms_outlined,
     Colors.black45, 
      (){
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(
           postId: post.id,
         )));
      }
      ),
    ],),
    Container(
          height: 25,
          width: 0.5,
color: Colors.black38,        ),
              ],
            ),
          );
        }
        ),
    );
  }
}