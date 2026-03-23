import 'package:favourite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';

class PlacesListScreen extends StatelessWidget{

  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
        appBar: AppBar(
          title: Text("Your Places"),
          actions: [IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.add))],
        ),
        body: PlacesList(places: [])
      );
  }
}