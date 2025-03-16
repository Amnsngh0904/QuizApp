import 'package:flutter/material.dart';
import 'package:quiz_app/constant.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    required this.question,
    required this.indexAction,
    required this.totalQuestions,
    super.key,
  });

  final String question;
  final int indexAction;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        'Question ${indexAction + 1}/$totalQuestions: $question',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
          color: neutral,
        ),
      ),
    );
  }
}
