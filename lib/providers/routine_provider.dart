import 'package:flutter/material.dart';
import '../models/exercise.dart';

class RoutineProvider extends ChangeNotifier {
  final List<Exercise> _routine = [];

  List<Exercise> get routine => _routine;

  int get exerciseCount => _routine.length;

  int get totalSets =>
      _routine.fold(0, (sum, e) => sum + e.sets);

  double get totalVolume =>
      _routine.fold(0, (sum, e) => sum + e.volume);

  bool isInRoutine(String id) {
    return _routine.any((e) => e.id == id);
  }

  Map<String, int> get muscleGroupBreakdown {
    final Map<String, int> map = {};

    for (var e in _routine) {
      map[e.muscleGroup] =
          (map[e.muscleGroup] ?? 0) + 1;
    }

    return map;
  }

  void addExercise(Exercise exercise) {
    if (isInRoutine(exercise.id)) return;

    _routine.add(exercise);
    notifyListeners();
  }

  void removeExercise(String id) {
    _routine.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clearRoutine() {
    _routine.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restock_provider.dart';

class AddItemScreen extends StatefulWidget {
  final String category;

  AddItemScreen({required this.category});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final qty = TextEditingController();
  final price = TextEditingController();

  double total = 0;

  @override
  void initState() {
    super.initState();
    qty.addListener(updateTotal);
    price.addListener(updateTotal);
  }

  void updateTotal() {
    final q = int.tryParse(qty.text) ?? 0;
    final p = double.tryParse(price.text) ?? 0;

    setState(() {
      total = q * p;
    });
  }

  @override
  void dispose() {
    name.dispose();
    qty.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestockProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Add Item")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: "Item Name"),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Required";
                  if (v.length < 3) return "Too short";
                  return null;
                },
              ),

              TextFormField(
                controller: qty,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Quantity"),
                validator: (v) {
                  if (v == null || int.tryParse(v) == null) return "Invalid";
                  if (int.parse(v) <= 0) return "Must be > 0";
                  return null;
                },
              ),

              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Price"),
                validator: (v) {
                  if (v == null || double.tryParse(v) == null)
                    return "Invalid";
                  if (double.parse(v) < 0) return "No negatives";
                  return null;
                },
              ),

              SizedBox(height: 20),

              Text("Total: R $total"),

              SizedBox(height: 20),

              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    provider.addItem(
                      Item(
                        id: DateTime.now().toString(),
                        name: name.text,
                        quantity: int.parse(qty.text),
                        price: double.parse(price.text),
                        category: widget.category,
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Save Item",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
