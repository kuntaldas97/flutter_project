import 'package:flutter/material.dart';
// import 'package:meals/screens/tabs.dart';
// import 'package:meals/widgets/main_drawer.dart';
import 'package:meals/providers/filters_provider.dart';



class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentfilters});
  final Map<Filter,bool> currentfilters;

  @override
  State<FiltersScreen> createState() {
    return _FilterScreenState();
  }
}

class _FilterScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegeterianFilterSet = false;
  var _veganFilterSet = false;
  @override
  void initState() {
    super.initState();
    _glutenFreeFilterSet=widget.currentfilters[Filter.glutenFree]!;
    _lactoseFreeFilterSet=widget.currentfilters[Filter.lactoseFree]!;
    _vegeterianFilterSet=widget.currentfilters[Filter.vegeterian]!;
    _veganFilterSet=widget.currentfilters[Filter.vegan]!;
  }
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Filters")),
      // drawer: MainDrawer(
      //   onSelectScreen: (identifier) {
      //     Navigator.of(context).pop();
      //     if (identifier == 'meals') {
      //       Navigator.of(
      //         context,
      //       ).pushReplacement(MaterialPageRoute(builder: (ctx) => TabsScreen()));
      //     }
      //   },
      // ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool dipPop, dynamic result){
        if(dipPop) return;
          Navigator.of(context).pop({
            Filter.glutenFree:_glutenFreeFilterSet,
            Filter.lactoseFree:_lactoseFreeFilterSet,
            Filter.vegeterian:_vegeterianFilterSet,
            Filter.vegan:_veganFilterSet
          });
        },
        child: Column(
          children: [
            SwitchListTile(
              value: _glutenFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _glutenFreeFilterSet = isChecked;
                });
              },
              title: Text(
                "Gluten-free",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Only include gluten free meals",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              activeThumbColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _lactoseFreeFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _lactoseFreeFilterSet = isChecked;
                });
              },
              title: Text(
                "Lactose-free",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ), 
              subtitle: Text(
                "Only include lactose free meals",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              activeThumbColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _vegeterianFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _vegeterianFilterSet = isChecked;
                });
              },
              title: Text(
                "Vegeterian",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Only include vegeterian  meals",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              activeThumbColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
            SwitchListTile(
              value: _veganFilterSet,
              onChanged: (isChecked) {
                setState(() {
                  _veganFilterSet = isChecked;
                });
              },
              title: Text(
                "Vegan",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                "Only include vegan meals",
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              activeThumbColor: Theme.of(context).colorScheme.tertiary,
              contentPadding: const EdgeInsets.only(left: 34, right: 22),
            ),
          ],
        ),
      ),
    );
  }
}
