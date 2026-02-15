import 'package:adv_basics_lec2/answer_button.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget{
const QuestionScreen({super.key});

@override 
State<QuestionScreen> createState(){
  return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen>{

@override
Widget build(context){
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("The Question", style: TextStyle(fontSize: 24, color: Colors.white),),
        SizedBox(height: 30),
        AnswerButton(answerText: "Answer 1", onTap: (){}),
        AnswerButton(answerText: "Answer 2", onTap: (){}),
        AnswerButton(answerText: "Answer 3", onTap: (){}),
        AnswerButton(answerText: "Answer 4", onTap: (){}),
      ],
    ),
  );
  }
}