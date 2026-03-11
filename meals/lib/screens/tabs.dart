import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget{
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen>{
  int _selectedPageIndex=0;

   final List<Meal> _favouriteMeals=[];
   void _showInfoMessage(String message){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message)
        )
    );
   }
   void _toggleMealFavouriteStatus(Meal meal){
     final isExisting = _favouriteMeals.contains(meal);
     setState(() {
       if(isExisting){
         _favouriteMeals.remove(meal);
         _showInfoMessage("Removed from favourite");
      }
      else{
        _favouriteMeals.add(meal);
        _showInfoMessage("Added to the favourite");
      }
     });   
   }

  void _selectedPage(int index){
    setState(() {
       _selectedPageIndex=index;
    });
  }
  @override
  Widget build(BuildContext context){
    Widget activePage = CategoriesSreen(onToggleFavourite: _toggleMealFavouriteStatus,);
    var activePageTitle='Categoties';

    if(_selectedPageIndex==1){
      activePage=MealsScreen(
        meals:_favouriteMeals, 
        onToggleFavourite: _toggleMealFavouriteStatus,
        );
      activePageTitle = 'Your Favourites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: const MainDrawer(),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectedPage,
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites')
        ]
      ),
    );
  }
}