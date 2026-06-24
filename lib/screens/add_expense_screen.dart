import 'package:expense_tracker/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();

  final List<Map<String, dynamic>> categories = [
    {'label': 'Food',          'icon': Icons.restaurant_rounded},
    {'label': 'Shopping',      'icon': Icons.shopping_bag_rounded},
    {'label': 'Transport',     'icon': Icons.directions_car_rounded},
    {'label': 'Entertainment', 'icon': Icons.movie_rounded},
    {'label': 'Health',        'icon': Icons.medical_services_rounded},
    {'label': 'Education',     'icon': Icons.school_rounded},
    {'label': 'Other',         'icon': Icons.receipt_rounded},
  ];

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF6C63FF),
            surface: Color(0xFF1E1E2E),
          ),
        ),
        child: child!,
      ),
    );
    if (pickedDate != null) setState(() => selectedDate = pickedDate);
  }

  Future<void> saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final expense = Expense(
      title: titleController.text.trim(),
      amount: int.parse(amountController.text),
      category: selectedCategory,
      date: selectedDate,
      note: noteController.text.trim(),
    );

    await context.read<ExpenseProvider>().addExpense(expense);
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

  // ── Reusable input decoration ────────────────────────────
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.45),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
      filled: true,
      fillColor: const Color(0xFF1E1E2E),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFF4D6D)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFFF4D6D), width: 1.5),
      ),
      errorStyle: const TextStyle(color: Color(0xFFFF4D6D)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Amount Hero Input ──────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6C63FF), Color(0xFF3B3486)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'HOW MUCH?',
                      style: TextStyle(
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          '₹',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                            decoration: InputDecoration(
                              hintText: '0',
                              hintStyle: TextStyle(
                                color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                              ),
                              border: InputBorder.none,
                              errorStyle: const TextStyle(
                                color: Color(0xFFFFD6DD),
                                fontSize: 12,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter amount';
                              }
                              final amount = int.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Enter valid amount';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Section Label ──────────────────────────
              _sectionLabel('Details'),
              const SizedBox(height: 12),

              // Title field
              TextFormField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Title', Icons.edit_outlined),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Enter title';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Notes field
              TextFormField(
                controller: noteController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: _inputDecoration('Notes (Optional)', Icons.notes_rounded),
              ),

              const SizedBox(height: 28),

              // ── Category ──────────────────────────────
              _sectionLabel('Category'),
              const SizedBox(height: 14),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.map((cat) {
                  final isSelected = selectedCategory == cat['label'];
                  return GestureDetector(
                    onTap: () => setState(() => selectedCategory = cat['label']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6C63FF)
                            : const Color(0xFF1E1E2E),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFFFFFFFF).withValues(alpha: 0.08),
                          width: 1.2,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat['icon'] as IconData,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            cat['label'] as String,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFFFFFFFF).withValues(alpha: 0.5),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              // ── Date Picker ───────────────────────────
              _sectionLabel('Date'),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.calendar_month_rounded,
                          color: Color(0xFF6C63FF),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Date',
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                              fontSize: 11,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),


              GestureDetector(
                onTap: () async {
                  await saveExpense();
                },
                child: Container(
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Save Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: const Color(0xFFFFFFFF).withValues(alpha: 0.35),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}