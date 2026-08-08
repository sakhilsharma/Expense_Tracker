import 'package:flutter/material.dart';
import '../models/expense.dart'; //expense class
import '../services/storage_services.dart';
import 'package:hive_flutter/hive_flutter.dart'; //to access hive box class
import '../repository/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseRepository repository;

  ExpenseProvider(this.repository);

  List<Expense> _expenses = [];

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;
  List<Expense> get expenses => _expenses;

  // ADD
  Future<void> addExpense(Expense expense) async {
    try {
      _error = null;

      final savedExpense = await repository.addExpense(expense);

      _expenses.add(savedExpense);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // LOAD
  Future<void> loadExpenses() async {
    try {
      _loading = true;
      _error = null;

      notifyListeners();

      final expenses = await repository.getExpenses();

      _expenses = expenses;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // DELETE
  Future<void> deleteExpense(String expenseId) async {
    try {
      _error = null;

      await repository.deleteExpense(expenseId);

      _expenses.removeWhere((expense) => expense.id == expenseId);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  //----------> Hive functions
  // late Box _box; //late becuase hve created later
  // Future<void> init() async {
  //   _box = await StorageService.openBox();

  //   loadExpenses();
  // }

  //  ------------>Hive storage fuc---->
  // void loadExpenses() {
  //   _expenses.clear();
  //   for (var item in _box.values) {
  //     final expense = Expense.fromMap(Map<String, dynamic>.from(item));
  //     _expenses.add(expense);
  //   }
  //   notifyListeners();
  // }

  // //save expense to hive
  // Future<void> addExpense(Expense expense) async {
  //   _expenses.add(expense);
  //   //add data of expense to hive
  //   await _box.add(expense.toMap());

  //   notifyListeners();
  // }

  // Future<void> deleteExpense(int index) async {
  //   _expenses.removeAt(index);

  //   await _box.deleteAt(index);

  //   notifyListeners();
  // }
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
