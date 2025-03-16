import 'package:flutter/material.dart';
import 'package:quiz_app/models/ques_model.dart';
import '../constant.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../widgets/result_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions = [
    Question(
      id: '01',
      title: 'Who is GOAT of cricket ?',
      options: {
        'Sachin Tendulkar': false,
        'Virat Kohli': true,
        'Ricky Ponting': false,
        'Viv Richards': false,
      },
    ),

    Question(
      id: '02',
      title: 'Who founded the company Apple ?',
      options: {
        'Tim Cook': false,
        'Me': false,
        'Steve Jobs': true,
        'Bill Gates': false,
      },
    ),
  ];

  //create an index to loop through _questions
  int index = 0;
  int score = 0;
  //create a boolean value to check that if any option is clicked
  bool isPressed = false;
  bool isAlreadySelected = false;

  //function to display the next question
  void nextQuestion() {
    if (index == _questions.length - 1) {
      showDialog(
        context: context,
        barrierDismissible:
            false, //this will disable the dismiss function on clicking outside of box
        builder:
            (ctx) => ResultBox(
              result: score,
              questionLength: _questions.length,
              onPressed: startOver,
            ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select any option to continue'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  //function for checking answer and updating state
  void checkAnswerandUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
      if (value == true) {
        score++;
      }
    }
  }

  //function to start over
  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Padding(
          padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
          child: const Text(
            'Quiz App',
            style: TextStyle(
              fontSize: 40,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            QuestionWidget(
              question: _questions[index].title, //means the first ques in list
              indexAction: index, //currently at 0
              totalQuestions: _questions.length, //total length of list
            ),

            const Divider(color: Colors.black12),
            const SizedBox(height: 25.0),

            for (int i = 0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap:
                    () => checkAnswerandUpdate(
                      _questions[index].options.values.toList()[i],
                    ),
                child: OptionCard(
                  option: _questions[index].options.keys.toList()[i],
                  color:
                      isPressed
                          ? _questions[index].options.values.toList()[i] == true
                              ? correct
                              : incorrect
                          : neutral,
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
