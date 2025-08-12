import 'package:flutter/material.dart';


class AppDrawer extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Drawer(
     child: ListView(
       children: [
         DrawerHeader(
           decoration: BoxDecoration(color: Colors.indigo),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: const [
               Icon(Icons.school, color: Colors.white, size: 60),
               SizedBox(height: 10),
               Text("Student Connect",
                   style: TextStyle(color: Colors.white, fontSize: 18)),
             ],
           ),
         ),
       ],
     ),
   );
 }
}


