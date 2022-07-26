class Popular{
  int? id;
  String? name;
  String? writer;
  String? image;
  String? description;
  Popular({
this.id,
this.name,
this.writer,
this.image,
this.description,

  });
  //map json to post model
  factory Popular.fromJson(Map<String,dynamic> json){
    return Popular(
      id: json['id'],
      name: json['name'],
      writer: json['writer'],
      image: json['image'],
      description: json['description'],
   
     
    );
  }
}
class Category{
  int? id;
  String? name;
  String? image;
  Category({
this.id,
this.name,
this.image,
  });
  //map json to post model
  factory Category.fromJson(Map<String,dynamic> json){
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
class Best{
  int? id;
  String? name;
  String? writer;
  String? image;
  String? description;
  Best({
this.id,
this.name,
this.writer,
this.image,
this.description,

  });
  //map json to post model
  factory Best.fromJson(Map<String,dynamic> json){
    return Best(
      id: json['id'],
      name: json['name'],
      writer: json['writer'],
      image: json['image'],
      description: json['description'],
   
     
    );
  }
}
class Onebook{
  int? id;
  int? comment_count;
  String? name;
  String? writer;
  String? image;
  String? description;
  Onebook({
this.id,
this.name,
this.writer,
this.image,
this.description,
this.comment_count,
  });
  //map json to post model
  factory Onebook.fromJson(Map<String,dynamic> json){
    return Onebook(
      id: json['id'],
      name: json['name'],
      image: json['image'],
       writer: json['writer'],
      description: json['description'],
  comment_count:json['comments_count']
     
    );
  }
}
class Commente{
  int? id;
  String? comment;
  Map? member;

  Commente({
this.id,
this.comment,
this.member

  });
  //map json to post model
  factory Commente.fromJson(Map<String,dynamic> json){
    return Commente(
      id: json['id'],
      comment: json['comment'],
      member: json['member'],
     
     
    );
  }
}