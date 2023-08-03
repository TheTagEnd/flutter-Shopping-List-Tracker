import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({super.key , required this.color , required this.quantity , required this.title});

  final Color color ;
  final String title;
  final int quantity ; 

  @override
  Widget build(BuildContext context) {
    return  Column(
      
        children: [
          Row(
            children: [
              SizedBox(width: 10,),
              IconButton(onPressed: (){}, icon:
             const  Icon(
                 Icons.square , 
                 ),
                   style: IconButton.styleFrom(foregroundColor: color) , iconSize: 35,

              ),
           const  SizedBox(width: 20,),
        Expanded(
          child: Text(title , style:const  TextStyle(
                fontSize: 20
               ),),
        ),
             
              Text(quantity.toString(), style:const  TextStyle(
              fontSize: 18
             ),
             textAlign: TextAlign.end,),
              const SizedBox(width: 15,),

            ],
          )
        ],
              );
  }
}