import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.switchScreen, {super.key});

  final void Function() switchScreen;
  @override
  Widget build(context) {
    return  Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Image.asset( 
                "assets/images/quiz-logo.png", 
                width: 300,
                color: const Color.fromARGB(150, 255, 255, 255),),
            // Opacity(
            // opacity: 0.5,
            // child: Image.asset( "assets/images/quiz-logo.png", width: 300)),
          const SizedBox(height: 80),
          Text( "Learn Flutter the fun way!", 
              style: TextStyle(
              fontSize: 24, 
              color: const Color.fromARGB(255, 237, 223, 252))),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: switchScreen,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text("Start Quiz"))
        ]));
  }
}
 