import 'dart:ui';
import 'package:flutter/material.dart';


class GlassBottomNavBar extends StatelessWidget {
 final int currentIndex;
 final ValueChanged<int> onTap;


 const GlassBottomNavBar({
   Key? key,
   required this.currentIndex,
   required this.onTap,
 }) : super(key: key);


 @override
 Widget build(BuildContext context) {
   return ClipRRect(
     borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
     child: BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
       child: Container(
         height: 70,
         decoration: BoxDecoration(
           color: Colors.white.withOpacity(0.18),
           border: Border(
             top: BorderSide(color: Colors.white.withOpacity(0.18), width: 1),
           ),
         ),
         child: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,
           backgroundColor: Colors.transparent,
           elevation: 0,
           showSelectedLabels: false,
           showUnselectedLabels: false,
           currentIndex: currentIndex,
           selectedItemColor: Colors.indigo[300],
           unselectedItemColor: Colors.white,
           items: const [
             BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
             BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Weather'),
             BottomNavigationBarItem(icon: Icon(Icons.task_rounded), label: 'Tasks'),
             BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Contact'),
             BottomNavigationBarItem(icon: Icon(Icons.info_rounded), label: 'About'),
           ],
           onTap: onTap,
         ),
       ),
     ),
   );
 }
}


