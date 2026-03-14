import 'package:flutter/material.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favourites_provider.dart';
import 'package:meals/providers/filters_provider.dart';


const kInitialFilters={
  Filter.glutenFree:false,
  Filter.lactoseFree:false,
  Filter.vegeterian:false,
  Filter.vegan:false
};
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  Map<Filter, bool> _selectedfilter = kInitialFilters;

  void _showInfoMessage(String message) {
    
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async{      
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result= await Navigator.of(
        context,
      ).push<Map<Filter,bool>>
      (MaterialPageRoute(
        builder: (ctx) => FiltersScreen(
          currentfilters: _selectedfilter,
        )
        )
        );
        setState(() {
          _selectedfilter= result ?? kInitialFilters;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals=meals.where((meal){
      if(_selectedfilter[Filter.glutenFree]! && !meal.isGlutenFree){
        return false;
      }
      if(_selectedfilter[Filter.lactoseFree]! && !meal.isLactoseFree){
        return false;
      }
      if(_selectedfilter[Filter.vegeterian]! && !meal.isVegetarian){
        return false;
      }
      if(_selectedfilter[Filter.vegan]! && !meal.isVegan){
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesSreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categoties';

    if (_selectedPageIndex == 1) {
      final favouriteMeals=ref.watch(favouriteMealsProvider);
      activePage = MealsScreen(
        meals: favouriteMeals,
      );
      activePageTitle = 'Your Favourites';
    }
    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _selectedPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
