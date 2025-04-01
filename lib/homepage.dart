import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black,
        
        title: Row(
          children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
                const SizedBox(width: 80,),
                const Text('CoffeeSghopcity'),
          
            
          ],
        ),
        
      ) ,
    );
  }
}
