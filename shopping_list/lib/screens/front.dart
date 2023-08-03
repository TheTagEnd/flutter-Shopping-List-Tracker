import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/modals/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Front extends StatefulWidget {
  const Front({super.key});

  @override
  State<Front> createState() => _FrontState();
}

class _FrontState extends State<Front> {
  List<GroceryItem> _groceryItems = [];
  @override
  void initState() {
    _loaditems(); // TODO: implement initState
    super.initState();
  }

  final List<GroceryItem> loadeditems = [];

  void _loaditems() async {
    final url = Uri.https(
        'flutter-e7ec5-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    print(response);
    final Map<String, dynamic> listData = json.decode(response.body);
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere((element) => element.value.name == item.value['category'])
          .value;
      loadeditems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = loadeditems;
    });
  }

  void _removeitem(GroceryItem item) {
    final url = Uri.https('flutter-e7ec5-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');

    setState(() {
      groceryItems.remove(item);
      http.delete(url);
    });
  }

  void _addItem() async {
    final item = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => NewItem()));
    loadeditems.add(item);
    _loaditems();
  }

  Color color = Colors.red;

  @override
  Widget build(context) {
    print(_groceryItems);
    Widget activeScreen = ListView.builder(
      itemCount: _groceryItems.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: Key(_groceryItems[index].id),
        direction: DismissDirection.horizontal,
        onUpdate: (details) {
          setState(() {
            color = Colors.red;
          });
        },
        onDismissed: (direction) {
          GroceryItem item = _groceryItems[index];

          setState(() {
            _removeitem(item);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Removed'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => setState(
                  () {
                    _groceryItems.add(item);
                  },
                ),
              ),
            ),
          );
        },
        background: Container(
          width: 20,
          height: 20,
          padding: const EdgeInsets.all(20),
          color: color,
        ),
        child: Item(
          color: _groceryItems[index].category.color,
          quantity: _groceryItems[index].quantity,
          title: _groceryItems[index].name,
        ),
      ),
    );

    if (_groceryItems.isEmpty) {
      activeScreen = const Center(child: Text('Nothing There Add Something'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(
              Icons.add,
              size: 32,
            ),
          )
        ],
      ),
      body: activeScreen,
    );
  }
}
