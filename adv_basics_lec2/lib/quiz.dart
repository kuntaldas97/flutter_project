import 'package:flutter/material.dart';
import 'package:adv_basics_lec2/start_screen.dart';
import 'package:adv_basics_lec2/question_screen.dart';
import 'package:adv_basics_lec2/data/questions.dart';
import 'package:adv_basics_lec2/result_screen.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  //  void initState(){
  //   activeScreen = StartScreen(switchScreen);
  //   super.initState();
  // }
  List<String> selectedAnswers = [];
  var activeScreen = "start_screen";

  void switchScreen() {
    setState(() {
      activeScreen = 'question_screen';
    });
  }
  void chooseAnswer(String answer){
    selectedAnswers.add(answer);
    if (selectedAnswers.length==questions.length){
      setState(() {
        activeScreen = 'result_screen';
      });
    }
  }

  @override
  Widget build(Context) {

    // Using ternary operator to switch between screens
    // final screenWidget = activeScreen == 'start_screen'
    //           ? StartScreen(switchScreen)
    //           : QuestionScreen();

    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'question_screen') {
      screenWidget = QuestionScreen(onSelectAnswer: chooseAnswer);
    }
    if (activeScreen == 'result_screen') {
      screenWidget =  ResultScreen(choosenAnswers: selectedAnswers);
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 52, 5, 98),
                Color.fromARGB(255, 101, 36, 205),
              ],
              begin: startAlignment,
              end: endAlignment,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
