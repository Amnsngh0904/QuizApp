/*import 'package:flutter/material.dart';
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
          color: Colors.black87,
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${indexAction + 1} of $totalQuestions',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          question,
          style: const TextStyle(
            fontSize: 22.0,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
