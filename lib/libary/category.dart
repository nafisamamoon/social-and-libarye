import 'package:flutter/material.dart';
class Category extends StatefulWidget {
  const Category({ Key? key }) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
    List doctors=[{
    'name':'Education',
    'img':'images/e.jfif'
    },
    {
    'name':'Political',
    'img':'images/p.jfif'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200,
        childAspectRatio: 7/8,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10
        ), 
          itemBuilder: (context,i){
            return InkWell(
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(doctors[i]['img'],
          height: 250,
          fit: BoxFit.cover,
          ),
          ),
          Container(
            
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(doctors[i]['name'],style: Theme.of(context).textTheme.headline6,),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15)),
            )
        ],
      ),
    );
          }
          )
      ),
    );
  }
}