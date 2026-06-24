import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.expenses;

    final totalExpense = expenses.fold(0,
          (sum, expense) => sum + expense.amount,
    );
    const totalIncome = 50000;
    final balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ExpenseFlow',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF6C63FF).withValues(alpha: 0.2),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF6C63FF),
                size: 20,
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddExpenseScreen(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Balance Card ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C63FF), Color(0xFF3B3486)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circle
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Color(0xFFFFFFFF),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'CURRENT BALANCE',
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '₹$balance',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Updated just now',
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF).withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Summary Cards ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Income',
                    amount: '₹$totalIncome',
                    icon: Icons.arrow_downward_rounded,
                    accentColor: const Color(0xFF00C896),
                    trend: '+0%',
                    isPositiveTrend: true,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SummaryCard(
                    title: 'Expenses',
                    amount: '₹$totalExpense',
                    icon: Icons.arrow_upward_rounded,
                    accentColor: const Color(0xFFFF4D6D),
                    trend: '${((totalExpense / totalIncome) * 100).toStringAsFixed(0)}%',
                    isPositiveTrend: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ── Section Header ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  '${expenses.length} total',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Transaction List ──────────────────────────
            Expanded(
              child: expenses.isEmpty
                  ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 56,
                      color: const Color(0xFFFFFFFF).withValues(alpha: 0.15),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'No expenses yet',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tap + to add your first one',
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: expenses.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return Dismissible(
                    key: ValueKey(expense.date.toString() + expense.title),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.only(right: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D6D).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFF4D6D).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFFF4D6D),
                        size: 24,
                      ),
                    ),
                    onDismissed: (_) {
                      context.read<ExpenseProvider>().deleteExpense(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                color: Color(0xFFFF4D6D),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${expense.title} deleted',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF2A2A3E),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E2E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFFFFF).withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              getCategoryIcon(expense.category),
                              color: const Color(0xFF6C63FF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Title + category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  expense.category,
                                  style: TextStyle(
                                    color: const Color(0xFFFFFFFF).withValues(alpha: 0.4),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Amount
                          Text(
                            '−₹${expense.amount}',
                            style: const TextStyle(
                              color: Color(0xFFFF4D6D),
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Food':       return Icons.restaurant_rounded;
    case 'Shopping':   return Icons.shopping_bag_rounded;
    case 'Transport':  return Icons.directions_car_rounded;
    case 'Entertainment': return Icons.movie_rounded;
    case 'Health':     return Icons.medical_services_rounded;
    case 'Education':  return Icons.school_rounded;
    default:           return Icons.receipt_rounded;
  }
}