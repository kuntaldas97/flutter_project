import 'package:flutter/material.dart';
class AnswerButton extends StatelessWidget{
  const AnswerButton({super.key, required this.answerText, required this.onTap});

  final String answerText;
  final void Function() onTap;

  @override
  Widget build(context){
    return ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding:EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            backgroundColor: const Color.fromARGB(230, 102, 9, 164),
            foregroundColor: Colors.white,
          ),
          child: Text(answerText),
        );
  }

}