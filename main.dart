import 'package:flutter/material.dart';
import 'nav_drawer.dart';
import 'home_screen.dart';
import 'weather_screen.dart';
import 'task_screen.dart';
import 'contact_admin.dart';
import 'about_screen.dart';
import 'glass_bottom_nav.dart';


void main() {
 runApp(StudentConnectApp());
}


class StudentConnectApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Student Connect',
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       colorSchemeSeed: Colors.indigo,
       useMaterial3: true,
       scaffoldBackgroundColor: Colors.black,
     ),
     home: MainScreen(),
   );
 }
}


class MainScreen extends StatefulWidget {
 @override
 State<MainScreen> createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
 int selectedIndex = 0;


 void _onNavTap(int index) {
   setState(() {
     selectedIndex = index;
   });
 }


 @override
 Widget build(BuildContext context) {
   final pages = [
     // Note: Pass the callback only to HomeScreen
     HomeScreen(onNavRequest: (tabIndex) {
       setState(() {
         selectedIndex = tabIndex;
       });
     }),
     WeatherScreen(),
     TasksScreen(),
     ContactAdminScreen(),
     AboutScreen(),
   ];


   // Use Stack to make the background image extend under bottom nav
   return Scaffold(
     extendBody: true, // important for transparent nav bar!
     drawer: AppDrawer(),
     body: pages[selectedIndex],
     bottomNavigationBar: GlassBottomNavBar(
       currentIndex: selectedIndex,
       onTap: _onNavTap,
     ),
   );
 }
}




