import "package:flutter/material.dart";

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
   GradientContainer(this.color1, this.color2, {super.key});

   GradientContainer.purple({super.key})
    : color1 = Colors.purple,
      color2 = Colors.deepPurple;

   Color color1;
  final Color color2;
  var activeDiceImage = "assets/dice-images/dice-2.png";
  void rollDice() {
    activeDiceImage = "assets/dice-images/dice-4.png";
    print("Dice Rolled!");
  }
  @override
  Widget build(context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(activeDiceImage, width: 200,),
            const SizedBox(height: 20,),
            TextButton(
              onPressed: rollDice,
              style: TextButton.styleFrom(
                // padding: const EdgeInsets.only(top:20),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 28),
              ),
              child: const Text("Roll Dice"))
          ],
        ),
      ),
    );
  }

  // const GradientContainer({super.key, required this.colors});
  // final List<Color> colors;
  // @override
  // Widget build(context){
  //   return Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             colors:colors,
  //             begin: startAlignment,
  //             end: endAlignment,
  //           ),
  //         ),
  //         child: const Center(
  //           child: StyleText("Hello KD!"),
  //         ),
  //       );
  // }
}
