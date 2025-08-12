import 'dart:ui';
import 'package:flutter/material.dart';
import 'nav_drawer.dart';


class HomeScreen extends StatelessWidget {
 final void Function(int tabIndex)? onNavRequest;
 const HomeScreen({Key? key, this.onNavRequest}) : super(key: key);


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     drawer: AppDrawer(),
     body: Container(
       decoration: BoxDecoration(
         color: Colors.indigo.shade900,
         image: DecorationImage(
           image: AssetImage('assets/banner.jpg'),
           fit: BoxFit.cover,
           colorFilter: ColorFilter.mode(
             Colors.black.withOpacity(0.7),
             BlendMode.darken,
           ),
         ),
       ),
       width: double.infinity,
       height: double.infinity,
       child: SafeArea(
         child: Center(
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 24),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 _glassButton(
                   context,
                   icon: Icons.cloud,
                   label: "Check Weather",
                   onTap: () => onNavRequest?.call(1), // Go to Weather tab
                 ),
                 SizedBox(height: 30),
                 _glassButton(
                   context,
                   icon: Icons.task,
                   label: "Manage Tasks",
                   onTap: () => onNavRequest?.call(2), // Go to Tasks tab
                 ),
                 SizedBox(height: 30),
                 _glassButton(
                   context,
                   icon: Icons.email,
                   label: "Contact Admin",
                   onTap: () => onNavRequest?.call(3), // Go to Contact tab
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }


 Widget _glassButton(BuildContext context,
     {required IconData icon,
     required String label,
     required VoidCallback onTap}) {
   return ClipRRect(
     borderRadius: BorderRadius.circular(24),
     child: BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
       child: InkWell(
         onTap: onTap,
         borderRadius: BorderRadius.circular(24),
         child: Container(
           height: 80,
           width: double.infinity,
           decoration: BoxDecoration(
             color: Colors.white.withOpacity(0.15),
             borderRadius: BorderRadius.circular(24),
             border: Border.all(color: Colors.white.withOpacity(0.35), width: 1.5),
             boxShadow: [
               BoxShadow(
                 color: Colors.black.withOpacity(0.25),
                 offset: Offset(0, 4),
                 blurRadius: 10,
               ),
             ],
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(icon, color: Colors.white, size: 32),
               SizedBox(width: 16),
               Text(
                 label,
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 22,
                   fontWeight: FontWeight.w600,
                   letterSpacing: 1,
                 ),
               ),
             ],
           ),
         ),
       ),
     ),
   );
 }
}


