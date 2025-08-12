import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'nav_drawer.dart';


class ContactAdminScreen extends StatelessWidget {
 final nameController = TextEditingController();
 final emailController = TextEditingController();
 final subjectController = TextEditingController();
 final messageController = TextEditingController();


 void sendEmail() async {
   final Uri emailURI = Uri(
     scheme: 'mailto',
     path: 'admin@example.com',
     query: Uri.encodeFull('subject=${subjectController.text}&body=${messageController.text}'),
   );
   if (await canLaunchUrl(emailURI)) {
     await launchUrl(emailURI);
   }
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     drawer: AppDrawer(),
     body: Padding(
       padding: const EdgeInsets.all(16),
       child: ListView(
         children: [
           Text("Admin Name: Admin", style: TextStyle(fontWeight: FontWeight.bold)),
           Text("Admin Email: admin@example.com"),
           Divider(),
           TextField(controller: nameController, decoration: InputDecoration(labelText: "Your Name")),
           TextField(controller: emailController, decoration: InputDecoration(labelText: "Your Email")),
           TextField(controller: subjectController, decoration: InputDecoration(labelText: "Subject")),
           TextField(controller: messageController, decoration: InputDecoration(labelText: "Message"), maxLines: 4),
           SizedBox(height: 20),
           ElevatedButton.icon(
             icon: Icon(Icons.send),
             label: Text("Send"),
             onPressed: sendEmail,
           )
         ],
       ),
     ),
   );
 }
}


