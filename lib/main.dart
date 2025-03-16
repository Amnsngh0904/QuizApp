import 'package:flutter/material.dart';
import 'package:quiz_app/models/ques_model.dart';
import './screens/home_screen.dart';
import './models/db_connect.dart';

void main() {
  var db = DBConnect();
  db.addQuestion(
    Question(id: '3', 
    title: 'what is 45 x 25 ?', 
    options: {
      '2245':false,
      '4718':false,
      '1125':true,
      '4871':false,
    })
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomeScreen(),
    );
  }
}
