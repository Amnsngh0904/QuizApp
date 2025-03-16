import 'package:http/http.dart' as http;
import '../models/ques_model.dart';
import 'dart:convert';

/*class DbConnect {
  final url = Uri.parse('https://quizapp-40e4c-default-rtdb.firebaseio.com/questions.json');
  Future<void> addQuestion(Question question) async{
    http.post(url, body: json.encode({
      'title' : question.title,
      'options' :question.options,
    }))
  }
}*/