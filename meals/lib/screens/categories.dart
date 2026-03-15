import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesSreen extends StatefulWidget {
  const CategoriesSreen({super.key, required this.availableMeals});
  final List<Meal> availableMeals;

  @override
  State<CategoriesSreen> createState() => _CategoriesSreenState();
}

class _CategoriesSreenState extends State<CategoriesSreen> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController=AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 1,
      );

      _animationController.forward();
  }
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title, 
          meals: filteredMeals),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController, 
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          // availableCategories.map((category)=>CategoryGridItem(category: category)).toList();
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context,category);
              },
            ),
        ],
      ),
      builder: (context,child)=>SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.5),
          end: const Offset(0, 0)
          ).animate(
          CurvedAnimation(
            parent: _animationController, 
            curve: Curves.easeInOut)
          ),
          child: child,
        ),
      ); 
  }
}
