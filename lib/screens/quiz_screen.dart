import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ques_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/option_card.dart';
import '../widgets/next_button.dart';
import '../widgets/result_box.dart';
import '../constant.dart';

class QuizScreen extends StatefulWidget {
  final String topic;
  QuizScreen({required this.topic});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool loading = true;
  String? errorMessage;
  List<Question> questions = [];

  int currentQuestionIndex = 0;
  String? selectedAnswer;
  bool hasAnswered = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    generateQuiz();
  }

  Future<void> generateQuiz() async {
    setState(() {
      loading = true;
      errorMessage = null;
      questions = [];
      currentQuestionIndex = 0;
      selectedAnswer = null;
      hasAnswered = false;
      score = 0;
    });

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=$GEMINI_API_KEY',
    );

    final prompt = '''
Generate 10 challenging multiple-choice questions (MCQs) on "${widget.topic}". Each question must include:
- 'question': the question text
- 'options': 4 possible answers
- 'answer': correct answer (must exactly match one option)
- 'explanation': brief explanation of the correct answer

Return ONLY valid JSON in this format:
{
  "questions": [
    {
      "question": "...",
      "options": ["...", "...", "...", "..."],
      "answer": "...",
      "explanation": "..."
    }
  ]
}
''';

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [{"text": prompt}]
            }
          ]
        }),
      );

      if (response.statusCode == 429 || response.statusCode == 503) {
        await Future.delayed(Duration(seconds: 8));
        return generateQuiz(); // Retry
      }

      if (response.statusCode != 200) {
        final errorJson = jsonDecode(response.body);
        final msg = errorJson['error']?['message'] ?? 'Unknown error';
        print("Gemini Error: ${response.statusCode}");
        print(errorJson);
        throw Exception("Gemini API Error: $msg");
      }

      final decoded = jsonDecode(response.body);
      String content = decoded['candidates'][0]['content']['parts'][0]['text'];

      // Remove Markdown-style backticks if present
      if (content.startsWith("```json") || content.startsWith("```")) {
        content = content.replaceAll(RegExp(r'```json|```'), '').trim();
      }

      final parsed = jsonDecode(content);
      questions = (parsed['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList();

      // Save questions to Firestore
      final firestore = FirebaseFirestore.instance;
      final batch = firestore.batch();
      for (var q in questions) {
        final docRef = firestore.collection('questions').doc();
        batch.set(docRef, {
          'topic': widget.topic,
          ...q.toMap(),
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();

      setState(() => loading = false);
    } catch (e) {
      print("API Error: $e");
      // Load from Firestore as fallback
      try {
        final fallback = await FirebaseFirestore.instance
            .collection('questions')
            .where('topic', isEqualTo: widget.topic)
            .orderBy('timestamp', descending: true)
            .limit(10)
            .get();

        questions = fallback.docs.map((doc) {
          final data = doc.data();
          return Question(
            question: data['question'],
            options: List<String>.from(data['options']),
            answer: data['answer'],
            explanation: data['explanation'] ?? 'Explanation not available.',
          );
        }).toList();

        setState(() => loading = false);
      } catch (fallbackError) {
        print("Firestore Fallback Error: $fallbackError");
        setState(() {
          loading = false;
          errorMessage = "Couldn't load quiz from Gemini or Firestore.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic)),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: generateQuiz,
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuestionWidget(
                        question: questions[currentQuestionIndex].question,
                        indexAction: currentQuestionIndex,
                        totalQuestions: questions.length,
                      ),
                      const SizedBox(height: 20),
                      ...questions[currentQuestionIndex]
                          .options
                          .map((option) {
                        Color cardColor = Colors.white;
                        if (hasAnswered) {
                          if (option ==
                              questions[currentQuestionIndex].answer) {
                            cardColor = Colors.green.shade200;
                          } else if (option == selectedAnswer) {
                            cardColor = Colors.red.shade200;
                          }
                        }

                        return GestureDetector(
                          onTap: () {
                            if (hasAnswered) return;
                            setState(() {
                              selectedAnswer = option;
                              hasAnswered = true;
                              if (option ==
                                  questions[currentQuestionIndex].answer) {
                                score++;
                              }
                            });
                          },
                          child: OptionCard(
                              option: option, color: cardColor),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      if (hasAnswered)
                        Text(
                          "Explanation: ${questions[currentQuestionIndex].explanation}",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      const SizedBox(height: 30),
                      if (hasAnswered)
                        GestureDetector(
                          onTap: () {
                            if (currentQuestionIndex <
                                questions.length - 1) {
                              setState(() {
                                currentQuestionIndex++;
                                selectedAnswer = null;
                                hasAnswered = false;
                              });
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => ResultBox(
                                  result: score,
                                  questionLength: questions.length,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    generateQuiz();
                                  },
                                ),
                              );
                            }
                          },
                          child: const NextButton(),
                        ),
                    ],
                  ),
                ),
    );
  }
}
