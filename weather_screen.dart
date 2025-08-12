import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'nav_drawer.dart';


class WeatherScreen extends StatefulWidget {
 @override
 _WeatherScreenState createState() => _WeatherScreenState();
}


class _WeatherScreenState extends State<WeatherScreen> {
 String _locationName = 'Bengaluru'; // initial location name
 double _latitude = 12.9716;  // Bengaluru latitude
 double _longitude = 77.5946; // Bengaluru longitude


 List dailyWeather = [];
 List hourlyWeather = [];
 bool isLoading = false;
 TextEditingController _searchController = TextEditingController();


 @override
 void initState() {
   super.initState();
   _searchController.text = _locationName;
   fetchWeather(_latitude, _longitude);
 }


 Future<void> fetchWeather(double lat, double lon) async {
   setState(() {
     isLoading = true;
     dailyWeather = [];
     hourlyWeather = [];
   });


   final url =
       'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,weathercode&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=auto';


   final response = await http.get(Uri.parse(url));


   if (response.statusCode == 200) {
     final data = json.decode(response.body);
     setState(() {
       dailyWeather = List.generate(
         data['daily']['time'].length,
         (index) => {
           'date': data['daily']['time'][index],
           'max': data['daily']['temperature_2m_max'][index],
           'min': data['daily']['temperature_2m_min'][index],
           'weathercode': data['daily']['weathercode'][index],
         },
       );


       hourlyWeather = List.generate(
         data['hourly']['time'].length,
         (index) => {
           'time': data['hourly']['time'][index],
           'temp': data['hourly']['temperature_2m'][index],
           'weathercode': data['hourly']['weathercode'][index],
         },
       );
       isLoading = false;
     });
   } else {
     setState(() {
       isLoading = false;
     });
   }
 }


 Future<void> searchLocation(String location) async {
   if (location.trim().isEmpty) return;
   final geoUrl = 'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(location)}&count=1';
   final response = await http.get(Uri.parse(geoUrl));


   if (response.statusCode == 200) {
     final result = json.decode(response.body);
     if (result['results'] != null && result['results'].length > 0) {
       final firstResult = result['results'][0];
       setState(() {
         _locationName = firstResult['name'];
         _latitude = firstResult['latitude'];
         _longitude = firstResult['longitude'];
       });
       fetchWeather(_latitude, _longitude);
     } else {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Location not found')),
       );
     }
   }
 }


 String formatTime(String time) {
   DateTime dt = DateTime.parse(time);
   return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
 }


 // Glassmorphic container wrapper
 Widget glassContainer({required Widget child, EdgeInsets? padding, double radius = 20, double opacity = 0.15}) {
   return ClipRRect(
     borderRadius: BorderRadius.circular(radius),
     child: BackdropFilter(
       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
       child: Container(
         padding: padding ?? EdgeInsets.all(12),
         decoration: BoxDecoration(
           color: Colors.white.withOpacity(opacity),
           borderRadius: BorderRadius.circular(radius),
           border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
         ),
         child: child,
       ),
     ),
   );
 }


 @override
 Widget build(BuildContext context) {
   final textColor = Colors.white;
   final subTextColor = Colors.white70;
   final accentColor = Colors.indigoAccent;


   return Scaffold(
     drawer: AppDrawer(),
     body: Stack(
       children: [
         // Background image with blur
         Positioned.fill(
           child: Image.asset(
             'assets/banner.jpg',
             fit: BoxFit.cover,
           ),
         ),
         Positioned.fill(
           child: BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
             child: Container(color: Colors.black.withOpacity(0.4)), // Slight dark overlay
           ),
         ),


         // Foreground content
         SafeArea(
           child: Padding(
             padding: const EdgeInsets.all(12),
             child: Column(
               children: [
                 // Search bar with glass effect
                 glassContainer(
                   radius: 16,
                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                   opacity: 0.25,
                   child: TextField(
                     controller: _searchController,
                     style: TextStyle(color: textColor),
                     decoration: InputDecoration(
                       hintText: 'Search location...',
                       hintStyle: TextStyle(color: subTextColor),
                       border: InputBorder.none,
                       suffixIcon: IconButton(
                         icon: Icon(Icons.search, color: textColor),
                         onPressed: () => searchLocation(_searchController.text),
                       ),
                     ),
                     onSubmitted: searchLocation,
                   ),
                 ),
                 SizedBox(height: 15),


                 // Loading spinner or forecasts list
                 isLoading
                     ? Expanded(
                         child: Center(
                           child: CircularProgressIndicator(color: textColor),
                         ),
                       )
                     : Expanded(
                         child: ListView(
                           children: [
                             if (dailyWeather.isNotEmpty)
                               glassContainer(
                                 child: ListTile(
                                   title: Text(
                                     'Today: ${dailyWeather[0]['date']}',
                                     style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                                   ),
                                   subtitle: Text(
                                     'Max: ${dailyWeather[0]['max']}°C, Min: ${dailyWeather[0]['min']}°C',
                                     style: TextStyle(color: subTextColor),
                                   ),
                                 ),
                               ),
                             SizedBox(height: 10),
                             Text(
                               'Hourly forecast',
                               style: TextStyle(
                                 color: textColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18,
                               ),
                             ),
                             SizedBox(height: 8),
                             Container(
                               height: 110,
                               child: ListView.separated(
                                 scrollDirection: Axis.horizontal,
                                 itemCount: hourlyWeather.length > 24 ? 24 : hourlyWeather.length,
                                 separatorBuilder: (_, __) => SizedBox(width: 10),
                                 itemBuilder: (ctx, i) {
                                   final hour = hourlyWeather[i];
                                   return glassContainer(
                                     radius: 16,
                                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                     opacity: 0.25,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Icon(Icons.wb_cloudy, color: accentColor, size: 26),
                                         SizedBox(height: 8),
                                         Text(
                                           '${hour['temp'].round()}°',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             color: textColor,
                                             fontSize: 18,
                                           ),
                                         ),
                                         SizedBox(height: 4),
                                         Text(
                                           formatTime(hour['time']),
                                           style: TextStyle(fontSize: 14, color: subTextColor),
                                         ),
                                       ],
                                     ),
                                   );
                                 },
                               ),
                             ),
                             SizedBox(height: 20),
                             Text(
                               'Daily forecast',
                               style: TextStyle(
                                 color: textColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18,
                               ),
                             ),
                             SizedBox(height: 8),
                             ...dailyWeather.map((day) {
                               return Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 6),
                                 child: glassContainer(
                                   child: ListTile(
                                     title: Text(day['date'], style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                                     subtitle: Text(
                                       'Min: ${day['min']}°C, Max: ${day['max']}°C',
                                       style: TextStyle(color: subTextColor),
                                     ),
                                   ),
                                 ),
                               );
                             }).toList(),
                           ],
                         ),
                       ),
               ],
             ),
           ),
         ),
       ],
     ),
   );
 }
}


