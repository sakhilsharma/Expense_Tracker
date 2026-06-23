import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState
    extends State<AddExpenseScreen> {
  final _formKey =
  GlobalKey<FormState>();

  final titleController =
  TextEditingController();

  final amountController =
  TextEditingController();

  final noteController =
  TextEditingController();

  String selectedCategory = 'Food';

  DateTime selectedDate =
  DateTime.now();

  final List<String> categories = [
    'Food',
    'Shopping',
    'Transport',
    'Entertainment',
    'Health',
    'Education',
    'Other',
  ];

  Future<void> pickDate() async {
    final pickedDate =
    await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate:
      DateTime(2020),
      lastDate:
      DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate =
            pickedDate;
      });
    }
  }

  Future<void> saveExpense()
  async {
    if (!_formKey.currentState!
        .validate()) {
      return;
    }

    final expense = Expense(
      title:
      titleController.text
          .trim(),
      amount: int.parse(
        amountController.text,
      ),
      category:
      selectedCategory,
      date: selectedDate,
      note:
      noteController.text
          .trim(),
    );

    await context
        .read<
        ExpenseProvider>()
        .addExpense(expense);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text(
            'Add Expense'),
      ),
      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
            16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              TextFormField(
                controller:
                titleController,
                decoration:
                const InputDecoration(
                  labelText:
                  'Title',
                  border:
                  OutlineInputBorder(),
                ),
                validator:
                    (value) {
                  if (value ==
                      null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Enter title';
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                amountController,
                keyboardType:
                TextInputType
                    .number,
                decoration:
                const InputDecoration(
                  labelText:
                  'Amount',
                  border:
                  OutlineInputBorder(),
                ),
                validator:
                    (value) {
                  if (value ==
                      null ||
                      value
                          .trim()
                          .isEmpty) {
                    return 'Enter amount';
                  }

                  final amount =
                  int.tryParse(
                      value);

                  if (amount ==
                      null ||
                      amount <=
                          0) {
                    return 'Enter valid amount';
                  }

                  return null;
                },
              ),

              const SizedBox(
                  height: 16),

              DropdownButtonFormField<
                  String>(
                value:
                selectedCategory,
                decoration:
                const InputDecoration(
                  labelText:
                  'Category',
                  border:
                  OutlineInputBorder(),
                ),
                items:
                categories
                    .map(
                      (category) =>
                      DropdownMenuItem(
                        value:
                        category,
                        child:
                        Text(
                          category,
                        ),
                      ),
                )
                    .toList(),
                onChanged:
                    (value) {
                  setState(() {
                    selectedCategory =
                    value!;
                  });
                },
              ),

              const SizedBox(
                  height: 16),

              TextFormField(
                controller:
                noteController,
                decoration:
                const InputDecoration(
                  labelText:
                  'Notes (Optional)',
                  border:
                  OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(
                  height: 16),

              Card(
                child: ListTile(
                  title:
                  const Text(
                    'Date',
                  ),
                  subtitle:
                  Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  ),
                  trailing:
                  const Icon(
                    Icons
                        .calendar_month,
                  ),
                  onTap:
                  pickDate,
                ),
              ),

              const SizedBox(
                  height: 30),

              SizedBox(
                height: 55,
                child:
                ElevatedButton(
                  onPressed:
                  saveExpense,
                  child:
                  const Text(
                    'Save Expense',
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