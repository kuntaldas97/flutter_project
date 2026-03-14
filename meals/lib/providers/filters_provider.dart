import 'package:flutter_riverpod/legacy.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegeterian,
  vegan
}
class FiltersNotifier extends StateNotifier<Map<Filter,bool>>{
  FiltersNotifier():super({
    Filter.glutenFree:false,
    Filter.lactoseFree:false,
    Filter.vegeterian:false,
    Filter.vegan:false
  });

  void setFilter(Filter filter, bool isActive){
    state={
      ...state,
      filter:isActive
    };
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Map<Filter,bool>>(
  (ref)=>FiltersNotifier()
  );