import 'package:flutter/material.dart';
import '../constant.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    required this.result,
    required this.questionLength,
    required this.onPressed,
    super.key,
  });
  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 17, 202, 212),
      content: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Result',
              style: TextStyle(
                color: Color.fromARGB(255, 18, 30, 196),
                fontSize: 45.0,
              ),
            ),
            const SizedBox(height: 30.0),
            CircleAvatar(
              child: Text(
                '$result/$questionLength',
                style: TextStyle(fontSize: 30.0, color: neutral),
              ),
              radius: 70.0,
              backgroundColor:
                  result == questionLength / 2
                      ? Colors.yellow
                      : result < questionLength / 2
                      ? incorrect
                      : correct,
            ),

            const SizedBox(height: 20.0),
            Text(
              result == questionLength / 2
                  ? 'Almost There'
                  : result < questionLength / 2
                  ? 'Try Again ?'
                  : 'Great!!',

              style: const TextStyle(
                color: Color.fromARGB(255, 18, 30, 196),
                fontSize: 30.0,
              ),
            ),
            const SizedBox(height: 40.0),
            GestureDetector(
              onTap: onPressed,
              child: const Text(
                'Start Over',
                style: TextStyle(
                  color: Color.fromARGB(255, 214, 68, 20),
                  fontSize: 25.0,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
