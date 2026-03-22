import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';

import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  // late Future<List<GroceryItem>> _loadedItems;
  var _isLoading = true;
  String? _error;
  @override
  void initState() {
    super.initState();
    // _loadedItems = _loadItems();
    _loadItems();
  }

  // Future<List<GroceryItem>> _loadItems() async {
  void _loadItems() async {
    try{
    final url = Uri.https(
      'flutter-prep-fdf9a-default-rtdb.firebaseio.com',
      // 'abc.firebaseio.com',---> when you put wrong url.
      'shopping-list.json',
    );
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      throw Exception("Failed to fetch the Grocery Items. Please try again!");
    }
    if (response.body == 'null') {
      setState(() {
        _isLoading=false;
      });
      return;
      // return [];
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> loadItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.identifier == item.value['category'],
          )
          .value;
      loadItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    // return loadItems;
      setState(() {
        _groceryItems=loadItems;
        _isLoading = false;
      });
    }
    catch(error){
      setState(() {
          _error = "Something went wrong, Please try again later!";
        });
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    try {
      final index = _groceryItems.indexOf(item);
      setState(() {
        _groceryItems.remove(item);
      });
      final url = Uri.https(
        'flu tter-prep-fdf9a-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json',
      );
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        setState(() {
          _groceryItems.insert(index, item);
        });
        throw Exception('Failed to delete');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to delete item. Please try again.'),
          backgroundColor: const Color.fromARGB(255, 232, 225, 225),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        "No items added yet!",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
    if(_isLoading){
      content = Center(child: CircularProgressIndicator());
    }
    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
        ),
      );
    }
    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries!'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: content,
      // body: FutureBuilder(
      //   future: _loadedItems,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasError) {
      //       return Center(
      //         child: Text(
      //           snapshot.error.toString(),
      //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //         ),
      //       );
      //     }
      //     if (snapshot.data!.isEmpty) {
      //       return Center(
      //         child: Text(
      //           "No items added yet!",
      //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      //         ),
      //       );
      //     }
      //     return ListView.builder(
      //       itemCount: snapshot.data!.length,
      //       itemBuilder: (ctx, index) => Dismissible(
      //         onDismissed: (direction) {
      //           _removeItem(snapshot.data![index]);
      //         },
      //         key: ValueKey(snapshot.data![index].id),
      //         child: ListTile(
      //           title: Text(snapshot.data![index].name),
      //           leading: Container(
      //             width: 24,
      //             height: 24,
      //             color: snapshot.data![index].category.color,
      //           ),
      //           trailing: Text(snapshot.data![index].quantity.toString()),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
