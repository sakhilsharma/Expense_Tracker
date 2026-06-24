import 'package:flutter/material.dart';
import '../models/expense.dart';//expense class
import '../services/storage_services.dart';
import 'package:hive_flutter/hive_flutter.dart';//to access hive box class
class ExpenseProvider
    extends ChangeNotifier {
  final List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  late Box _box;  //late becuase hve created later
  Future<void> init() async {
    _box =
    await StorageService
        .openBox();

    loadExpenses();
  }
//  ------------>Hive storage fuc---->
  void loadExpenses() {
    _expenses.clear();
    for (var item in _box.values) {
      final expense =
      Expense.fromMap(
          Map<String,
              dynamic>.from(
              item));
      _expenses.add(expense);
    }
    notifyListeners();
  }

  //save expense to hive
  Future<void> addExpense(
      Expense expense) async {

    _expenses.add(expense);
    //add data of expense to hive
    await _box.add(
        expense.toMap());

    notifyListeners();
  }

  Future<void>
  deleteExpense(
      int index) async {

    _expenses.removeAt(index);

    await _box.deleteAt(
        index);

    notifyListeners();
  }
}

//FLOW----->
/**
 * User presses Save
    ↓
    Expense object created
    ↓
    Add to List
    ↓
    Convert to Map
    ↓
    Store inside Hive
    ↓
    notifyListeners()
    ↓
    UI rebuilds
 */
/**
 * Delete button
    ↓
    Provider removes item
    ↓
    Hive removes item
    ↓
    notifyListeners()
    ↓
    UI rebuilds
 */
