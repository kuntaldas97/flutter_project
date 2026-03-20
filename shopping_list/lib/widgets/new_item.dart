import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';

class NewItem extends StatefulWidget {
  
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey=GlobalKey<FormState>();
  late String _enteredName;
  late int _enteredQuantity;
  late Category _selectedCategory;

  void _saveItem() async{
   if (_formKey.currentState!.validate()){
    _formKey.currentState!.save();
    final url = Uri.https(
      'flutter-prep-fdf9a-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.post(url,headers: {
      'Content-Type':'application/json'
    },
    body: json.encode({
      'name': _enteredName, 
      'quantity': _enteredQuantity, 
      'category': _selectedCategory.identifier
    })
    );
    print(response.body);
    print(response.statusCode);

    if(!context.mounted){
      return;
    }
    Navigator.of(context).pop();
      // GroceryItem(
    //   id: DateTime.now().toString(), 
    //   name: _enteredName, 
    //   quantity: _enteredQuantity, 
    //   category: _selectedCategory)
    //   );
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a new item!")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text("Name")),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be between 1 & 50 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(label: Text("Quantity")),
                      // initialValue: '1',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)==null ||
                            int.tryParse(value)!<=0) {
                          return "Must be a valid positive quantity";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity=int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                      label: Text("Select Category"),
                      border: OutlineInputBorder()
                      ),
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.identifier),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory=value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    }, 
                    child: const Text('Reset')),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
