import 'package:http/http.dart' as http;
import '../models/ques_model.dart';
import 'dart:convert';

class DBConnect {
  //lets first create a function to add a question to our database.
  final url = Uri.parse(
    'https://quizapp-40e4c-default-rtdb.firebaseio.com/questions.json',
  );
  Future<void> addQuestion(Question question) async {
    http.post(
      url,
      body: json.encode({'title': question.title, 'options': question.options}),
    );
  }

  Future<List<Question>> fetchQuestions() async {
    return http.get(url).then((response) {
      // the 'then' method returns a 'response' which is our data.
      // to whats inside we have to decode it first.

      var data = json.decode(response.body) as Map<String, dynamic>;
      List<Question> newQuestions = [];
      data.forEach((key, value) {
        var newQuestion = Question(
          id: key,
          title: value['title'],
          options: Map.castFrom(value['options']),
        );
        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }
}
