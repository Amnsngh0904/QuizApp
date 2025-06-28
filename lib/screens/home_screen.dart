/*import 'package:flutter/material.dart';
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
  var db = DBConnect();
  // List<Question> _questions = [
  /* Question(
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
  ]; */

  late Future _questions;
  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  void initState() {
    _questions = getData();
    super.initState();
  }

  //create an index to loop through _questions
  int index = 0;
  int score = 0;
  //create a boolean value to check that if any option is clicked
  bool isPressed = false;
  bool isAlreadySelected = false;

  //function to display the next question
  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
        context: context,
        barrierDismissible:
            false, //this will disable the dismiss function on clicking outside of box
        builder:
            (ctx) => ResultBox(
              result: score,
              questionLength: questionLength,
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

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
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
                      question:
                          extractedData[index]
                              .question, //means the first ques in list
                      indexAction: index, //currently at 0
                      totalQuestions:
                          extractedData.length, //total length of list
                    ),

                    const Divider(color: Colors.black12),
                    const SizedBox(height: 25.0),

                    for (
                      int i = 0;
                      i < extractedData[index].options.length;
                      i++
                    )
                      GestureDetector(
                        onTap: () => checkAnswerandUpdate(
                          extractedData[index].options[i] ==
                              extractedData[index].answer,
                        ),
                        child: OptionCard(
                          option: extractedData[index].options[i],
                          color: isPressed
                              ? extractedData[index].options[i] ==
                                      extractedData[index].answer
                                  ? correct
                                  : incorrect
                              : neutral,
                        ),
                      ),
                  ],
                ),
              ),

              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }

        return const Center(child: Text('No data'));
      },
    );
  }
}

*/