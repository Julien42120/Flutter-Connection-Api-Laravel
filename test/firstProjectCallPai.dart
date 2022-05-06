// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Future<List<Property>> fetchProperty(http.Client client) async {
//   final response =
//       await client.get(Uri.parse('http://127.0.0.1:8000/api/appartement'));
//   return compute(parseProperty, response.body);
// }

// List<Property> parseProperty(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   return parsed.map<Property>((json) => Property.fromJson(json)).toList();
// }

// class Property {
//   final int id;
//   final String title;
//   final String description;
//   final int size;
//   final int floor;
//   final String image;
//   final int room;
//   final int price;
//   final String address;
//   final String postcode;
//   final String city;
//   // ignore: non_constant_identifier_names
//   final String created_at;
//   // ignore: non_constant_identifier_names
//   final String updated_at;

//   const Property({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.size,
//     required this.floor,
//     required this.image,
//     required this.room,
//     required this.price,
//     required this.address,
//     required this.postcode,
//     required this.city,
//     // ignore: non_constant_identifier_names
//     required this.created_at,
//     // ignore: non_constant_identifier_names
//     required this.updated_at,
//   });

//   factory Property.fromJson(json) {
//     return Property(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       size: json['size'],
//       floor: json['floor'],
//       image: json['image'],
//       room: json['room'],
//       price: json['price'],
//       address: json['address'],
//       postcode: json['postcode'],
//       city: json['city'],
//       created_at: json['created_at'],
//       updated_at: json['updated_at'],
//     );
//   }
// }

// void main() => runApp(const MyApp());

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Future<Property> futureProperty;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Property',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//             title: const Center(child: Text('Property')),
//             backgroundColor: Colors.black,
//             actions: <Widget>[
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.add),
//                     tooltip: 'Add property',
//                     onPressed: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => const MoreProperty()),
//                       // );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back),
//                     tooltip: 'Back',
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             ]),
//         body: FutureBuilder<List<Property>>(
//           future: fetchProperty(http.Client()),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(
//                 child: Text('An error has occurred!'),
//               );
//             } else if (snapshot.hasData) {
//               return PropertyList(property: snapshot.data!);
//             } else {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

// class PropertyList extends StatelessWidget {
//   const PropertyList({Key? key, required this.property}) : super(key: key);

//   final List<Property> property;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           gradient: LinearGradient(
//         begin: Alignment.topRight,
//         end: Alignment.bottomLeft,
//         colors: [
//           Color.fromARGB(255, 0, 0, 0),
//           Color.fromARGB(255, 7, 123, 141),
//           Color.fromARGB(255, 0, 0, 0),
//         ],
//       )),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//         ),
//         itemCount: property.length,
//         itemBuilder: (context, index) {
//           return Container(
//             height: 50,
//             margin: EdgeInsets.all(20),
//             padding: const EdgeInsets.all(25),
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(131, 31, 137, 224),
//               borderRadius: BorderRadius.all(Radius.circular(20)),
//             ),
//             child: InkWell(
//               onTap: () => {},
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 120,
//                     child: Image.network(property[index].image),
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         width: 300,
//                         child: Text(
//                           property[index].title,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Text('price :'),
//                             Text(
//                               property[index].size.toString() + (' m²'),
//                               style:
//                                   const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
