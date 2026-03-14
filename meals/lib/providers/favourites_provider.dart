import 'package:flutter_riverpod/legacy.dart';
import 'package:meals/models/meal.dart';

class FavouritesProvider extends StateNotifier<List<Meal>>{
  FavouritesProvider():super([]);

  bool toggleMealFavouriteStatus(Meal meal){
    final mealIsFavourite = state.contains(meal);

    if(mealIsFavourite){
      state=state.where((m)=>m.id!=meal.id).toList();
      return false;
    }
    else{
      state=[...state,meal];
      return true;
    }
  }
}

final favouriteMealsProvider = StateNotifierProvider<FavouritesProvider,List<Meal>>((ref){
  return FavouritesProvider();
});