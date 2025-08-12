import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'storage.dart';
import 'nav_drawer.dart';


class TasksScreen extends StatefulWidget {
 @override
 State<TasksScreen> createState() => _TasksScreenState();
}


class _TasksScreenState extends State<TasksScreen> {
 List<Map<String, String>> tasks = [];
 final titleController = TextEditingController();
 final notesController = TextEditingController();


 @override
 void initState() {
   super.initState();
   _loadTasks();
 }


 // --- Data handling functions (unchanged) ---
 Future<void> _loadTasks() async {
   final loadedTasks = await TaskStorage.loadTasks();
   setState(() {
     tasks = loadedTasks;
   });
 }


 Future<void> _saveTasks() async {
   await TaskStorage.saveTasks(tasks);
 }


 void addTask(String title, String notes) {
   setState(() {
     tasks.add({"title": title, "notes": notes});
   });
   _saveTasks();
 }


 void editTask(int index, String title, String notes) {
   setState(() {
     tasks[index] = {"title": title, "notes": notes};
   });
   _saveTasks();
 }


 void deleteTask(int index) {
   setState(() {
     tasks.removeAt(index);
   });
   _saveTasks();
 }


 // --- Reusable Glassmorphic Container (unchanged) ---
 Widget glassContainer({required Widget child, EdgeInsets? padding, double radius = 16, double opacity = 0.15}) {
   return ClipRRect(
     borderRadius: BorderRadius.circular(radius),
     child: BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
       child: Container(
         padding: padding ?? const EdgeInsets.all(12),
         decoration: BoxDecoration(
           color: Colors.white.withOpacity(opacity),
           borderRadius: BorderRadius.circular(radius),
           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
         ),
         child: child,
       ),
     ),
   );
 }


 // --- Glassmorphic Dialog (unchanged) ---
 void showTaskDialog({int? index}) {
   if (index != null) {
     titleController.text = tasks[index]['title'] ?? '';
     notesController.text = tasks[index]['notes'] ?? '';
   } else {
     titleController.clear();
     notesController.clear();
   }


   showDialog(
     context: context,
     builder: (_) => BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
       child: AlertDialog(
         backgroundColor: Colors.white.withOpacity(0.2),
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16),
           side: BorderSide(color: Colors.white.withOpacity(0.3)),
         ),
         title: Text(
           index == null ? 'Add Task' : 'Edit Task',
           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             TextField(
               controller: titleController,
               style: const TextStyle(color: Colors.white),
               decoration: InputDecoration(
                 labelText: 'Title',
                 labelStyle: const TextStyle(color: Colors.white70),
                 enabledBorder: UnderlineInputBorder(
                   borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                 ),
                 focusedBorder: const UnderlineInputBorder(
                   borderSide: BorderSide(color: Colors.white),
                 ),
               ),
             ),
             TextField(
               controller: notesController,
               style: const TextStyle(color: Colors.white),
               decoration: InputDecoration(
                 labelText: 'Notes',
                 labelStyle: const TextStyle(color: Colors.white70),
                 enabledBorder: UnderlineInputBorder(
                   borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                 ),
                 focusedBorder: const UnderlineInputBorder(
                   borderSide: BorderSide(color: Colors.white),
                 ),
               ),
             ),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(context),
             child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
           ),
           ElevatedButton(
             onPressed: () {
               if (titleController.text.trim().isEmpty) return;
               if (index == null) {
                 addTask(titleController.text, notesController.text);
               } else {
                 editTask(index, titleController.text, notesController.text);
               }
               Navigator.pop(context);
             },
             style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.blueAccent.withOpacity(0.8)),
             child: const Text("Save"),
           ),
         ],
       ),
     ),
   );
 }


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     // --- CHANGE: AppBar removed ---
     drawer: AppDrawer(),
     body: Stack(
       children: [
         Positioned.fill(
           child: Image.asset(
             "assets/banner.jpg",
             fit: BoxFit.cover,
           ),
         ),
         Positioned.fill(
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
             child: Container(color: Colors.black.withOpacity(0.3)),
           ),
         ),
         SafeArea(
           child: tasks.isEmpty
               ? const Center(
                   child: Text(
                     "No tasks yet. Add one!",
                     style: TextStyle(color: Colors.white70, fontSize: 18),
                   ),
                 )
               : ListView.builder(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                   itemCount: tasks.length,
                   itemBuilder: (context, index) {
                     return Padding(
                       padding: const EdgeInsets.symmetric(vertical: 6.0),
                       child: glassContainer(
                         child: ListTile(
                           title: Text(
                             tasks[index]['title'] ?? '',
                             style: const TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold,
                               fontSize: 16,
                             ),
                           ),
                           subtitle: Text(
                             tasks[index]['notes'] ?? '',
                             style: const TextStyle(color: Colors.white70),
                             maxLines: 2,
                             overflow: TextOverflow.ellipsis,
                           ),
                           trailing: Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               IconButton(
                                 icon: const Icon(Icons.edit, color: Colors.white70),
                                 onPressed: () => showTaskDialog(index: index),
                               ),
                               IconButton(
                                 icon: const Icon(Icons.delete, color: Colors.redAccent),
                                 onPressed: () => deleteTask(index),
                               ),
                             ],
                           ),
                         ),
                       ),
                     );
                   },
                 ),
         ),
       ],
     ),
     // --- CHANGE: FloatingActionButton updated for glassmorphism and positioning ---
     floatingActionButton: Padding(
       // 1. Padded to raise it above the bottom navigation bar
       padding: const EdgeInsets.only(bottom: 80.0),
       child: ClipRRect(
         // 2. Clipped to a circle to contain the blur effect
         borderRadius: BorderRadius.circular(56.0 / 2),
         child: BackdropFilter(
           // 3. Blur effect for glassmorphism
           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
           child: FloatingActionButton(
             onPressed: () => showTaskDialog(),
             // 4. Semi-transparent background
             backgroundColor: Colors.white.withOpacity(0.25),
             elevation: 0, // No shadow for a flatter, modern look
             child: const Icon(Icons.add, color: Colors.white),
             tooltip: 'Add Task',
           ),
         ),
       ),
     ),
   );
 }
}


