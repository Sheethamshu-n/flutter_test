import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class TaskStorage {
 static const String _key = 'tasks';


 static Future<void> saveTasks(List<Map<String, String>> tasks) async {
   print('DEBUG: Saving ${tasks.length} tasks...');
   try {
     final prefs = await SharedPreferences.getInstance();
     final jsonStr = json.encode(tasks);
     print('DEBUG: JSON string: $jsonStr');
     await prefs.setString(_key, jsonStr);
     print('DEBUG: Save completed successfully');
   } catch (e) {
     print('DEBUG: Save ERROR: $e');
   }
 }


 static Future<List<Map<String, String>>> loadTasks() async {
   print('DEBUG: Loading tasks...');
   try {
     final prefs = await SharedPreferences.getInstance();
     final jsonStr = prefs.getString(_key);
     print('DEBUG: Loaded raw string: $jsonStr');
    
     if (jsonStr != null) {
       final List<dynamic> jsonData = json.decode(jsonStr);
       final result = jsonData.map((item) => Map<String, String>.from(item)).toList();
       print('DEBUG: Converted to ${result.length} tasks');
       return result;
     }
     print('DEBUG: No data found, returning empty list');
     return [];
   } catch (e) {
     print('DEBUG: Load ERROR: $e');
     return [];
   }
 }
}


