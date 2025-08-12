import 'package:flutter/material.dart';
import 'nav_drawer.dart';


class AboutScreen extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     drawer: AppDrawer(),
     body: Padding(
       padding: const EdgeInsets.all(16),
       child: ListView(
         children: const [
           Text("Student Connect", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
           SizedBox(height: 10),
           Text("A simple Flutter demo app for students, built with named routes and a Drawer."),
           SizedBox(height: 10),
           Text("Key Features:", style: TextStyle(fontWeight: FontWeight.bold)),
           ListTile(leading: Icon(Icons.cloud), title: Text("Weather"), subtitle: Text("7-day forecast via Open-Meteo API")),
           ListTile(leading: Icon(Icons.task), title: Text("Tasks"), subtitle: Text("CRUD with SharedPreferences")),
           ListTile(leading: Icon(Icons.email), title: Text("Contact Admin"), subtitle: Text("Send mail from inside the app")),
         ],
       ),
     ),
   );
 }
}


