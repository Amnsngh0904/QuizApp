// lib/screens/category_screen.dart
import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    "Cybersecurity",
    "Machine Learning",
    "Artificial Intelligence",
    "Data Structures",
    "Operating Systems",
    "Web Development",
    "Database Management",
    "Computer Networks",
    "Blockchain Technology",
    "Cloud Computing",
    "Software Engineering",
    "Mobile App Development",
    "Ethical Hacking",
    "Internet of Things (IoT)",
    "DevOps"
  ];  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select a Category")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(categories[index]),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizScreen(topic: categories[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
