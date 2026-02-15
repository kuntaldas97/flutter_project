import 'package:flutter/material.dart';
import 'package:adv_basics_lec2/start_screen.dart';
import 'package:adv_basics_lec2/question_screen.dart';

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
  
  var activeScreen = "start_screen";

  void switchScreen() {
    setState(() {
      activeScreen = 'question_screen';
    });
  }

  @override
  Widget build(Context) {

    // Using ternary operator to switch between screens
    // final screenWidget = activeScreen == 'start_screen'
    //           ? StartScreen(switchScreen)
    //           : QuestionScreen();

    Widget screenWidget = StartScreen(switchScreen);

    if (activeScreen == 'question_screen') {
      screenWidget = QuestionScreen();
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 33, 5, 109),
                Color.fromARGB(255, 68, 21, 149),
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
