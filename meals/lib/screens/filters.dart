import 'package:flutter/material.dart';

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key});

  @override
  State<FiltersScreen> createState() {
    return _FilterScreenState();
  }
}

class _FilterScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet=false;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Filters")),
      body: Column(
        children: [
          SwitchListTile(
            value: _glutenFreeFilterSet,
            onChanged: (isChecked){
              _glutenFreeFilterSet=isChecked;
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
            )
          ),
          activeThumbColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.only(left:34,right: 22),
          )
        ],
      
      ),
    );
  }
}
