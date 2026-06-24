import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/expense_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  int? _touchedIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final Map<String, int> categoryTotals = {};
    for (final expense in expenses) {
      categoryTotals.update(
        expense.category,
            (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final totalExpense =
    expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Sort categories by amount descending
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: colors.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6C63FF),
          indicatorWeight: 3,
          labelColor: const Color(0xFF6C63FF),
          unselectedLabelColor: colors.onSurface.withValues(alpha: 0.45),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Breakdown'),
            Tab(text: 'By Category'),
          ],
        ),
      ),
      body: expenses.isEmpty
          ? _EmptyState(colors: colors)
          : TabBarView(
        controller: _tabController,
        children: [
          // ── Tab 1: Pie + summary ───────────────────
          _BreakdownTab(
            sortedCategories: sortedCategories,
            totalExpense: totalExpense,
            touchedIndex: _touchedIndex,
            onSectionTouch: (index) =>
                setState(() => _touchedIndex = index),
            colors: colors,
            isDark: isDark,
          ),

          // ── Tab 2: Bar chart + list ────────────────
          _CategoryTab(
            sortedCategories: sortedCategories,
            totalExpense: totalExpense,
            colors: colors,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

// ── Tab 1: Donut + legend ─────────────────────────────────────────────────────

class _BreakdownTab extends StatelessWidget {
  final List<MapEntry<String, int>> sortedCategories;
  final int totalExpense;
  final int? touchedIndex;
  final ValueChanged<int?> onSectionTouch;
  final ColorScheme colors;
  final bool isDark;

  const _BreakdownTab({
    required this.sortedCategories,
    required this.totalExpense,
    required this.touchedIndex,
    required this.onSectionTouch,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final sections = sortedCategories.asMap().entries.map((entry) {
      final i = entry.key;
      final cat = entry.value;
      final isTouched = touchedIndex == i;
      final percentage =
      totalExpense == 0 ? 0.0 : (cat.value / totalExpense) * 100;

      return PieChartSectionData(
        color: getCategoryColor(cat.key),
        value: cat.value.toDouble(),
        title: isTouched ? '${percentage.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 100 : 88,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        badgeWidget: isTouched
            ? _Badge(category: cat.key, amount: cat.value)
            : null,
        badgePositionPercentageOffset: 1.25,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Total spend card ────────────────────────
          _GradientInfoCard(
            label: 'Total Spending',
            value: '₹$totalExpense',
            subtitle: '${sortedCategories.length} categories tracked',
            colors: colors,
          ),

          const SizedBox(height: 24),

          // ── Donut chart ─────────────────────────────
          _SectionLabel(label: 'Spending Breakdown', colors: colors),
          const SizedBox(height: 16),

          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 72,
                sectionsSpace: 3,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    if (!event.isInterestedForInteractions ||
                        response == null ||
                        response.touchedSection == null) {
                      onSectionTouch(null);
                      return;
                    }
                    onSectionTouch(
                        response.touchedSection!.touchedSectionIndex);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Legend ──────────────────────────────────
          _SectionLabel(label: 'Legend', colors: colors),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: sortedCategories.map((entry) {
              final percentage = totalExpense == 0
                  ? 0.0
                  : (entry.value / totalExpense) * 100;
              return _LegendChip(
                label: entry.key,
                percentage: percentage,
                color: getCategoryColor(entry.key),
                isDark: isDark,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Tab 2: Bar chart + category list ─────────────────────────────────────────

class _CategoryTab extends StatelessWidget {
  final List<MapEntry<String, int>> sortedCategories;
  final int totalExpense;
  final ColorScheme colors;
  final bool isDark;

  const _CategoryTab({
    required this.sortedCategories,
    required this.totalExpense,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final maxAmount =
    sortedCategories.isEmpty ? 1 : sortedCategories.first.value;

    final barGroups = sortedCategories.asMap().entries.map((entry) {
      final i = entry.key;
      final cat = entry.value;
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: cat.value.toDouble(),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                getCategoryColor(cat.key).withValues(alpha: 0.6),
                getCategoryColor(cat.key),
              ],
            ),
            width: 28,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
        ],
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Bar chart ───────────────────────────────
          _SectionLabel(label: 'Spend by Category', colors: colors),
          const SizedBox(height: 16),

          Container(
            height: 240,
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1E2E)
                  : colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.07),
              ),
            ),
            child: BarChart(
              BarChartData(
                maxY: maxAmount * 1.25,
                barGroups: barGroups,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxAmount / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: colors.onSurface.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: maxAmount / 4,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          '₹${(value / 1000).toStringAsFixed(0)}k',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.onSurface.withValues(alpha: 0.45),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i >= sortedCategories.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Icon(
                            getCategoryIcon(sortedCategories[i].key),
                            size: 16,
                            color: getCategoryColor(sortedCategories[i].key),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => isDark
                        ? const Color(0xFF2A2A3E)
                        : colors.surface,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final cat = sortedCategories[group.x];
                      return BarTooltipItem(
                        '${cat.key}\n₹${cat.value}',
                        TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Category rows ────────────────────────────
          _SectionLabel(label: 'Categories', colors: colors),
          const SizedBox(height: 12),

          ...sortedCategories.map((entry) {
            final percentage = totalExpense == 0
                ? 0.0
                : (entry.value / totalExpense) * 100;
            return _CategoryRow(
              category: entry.key,
              amount: entry.value,
              percentage: percentage,
              colors: colors,
              isDark: isDark,
            );
          }),
        ],
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _GradientInfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final ColorScheme colors;

  const _GradientInfoCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6C63FF), Color(0xFF3B3486)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final ColorScheme colors;

  const _SectionLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: colors.onSurface.withValues(alpha: 0.75),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;
  final bool isDark;

  const _LegendChip({
    required this.label,
    required this.percentage,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            '$label  ${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final int amount;
  final double percentage;
  final ColorScheme colors;
  final bool isDark;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color = getCategoryColor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(getCategoryIcon(category), color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: colors.onSurface,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹$amount',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurface.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: colors.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String category;
  final int amount;

  const _Badge({required this.category, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        '₹$amount',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ColorScheme colors;

  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 64,
            color: colors.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'Nothing to analyse yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: colors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add some expenses to see insights',
            style: TextStyle(
              fontSize: 13,
              color: colors.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Color getCategoryColor(String category) {
  switch (category) {
    case 'Food':          return const Color(0xFFFF9F43);
    case 'Shopping':      return const Color(0xFF6C63FF);
    case 'Transport':     return const Color(0xFF3B82F6);
    case 'Entertainment': return const Color(0xFFFF4D6D);
    case 'Health':        return const Color(0xFF10B981);
    case 'Education':     return const Color(0xFF14B8A6);
    default:              return const Color(0xFF94A3B8);
  }
}

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Food':          return Icons.restaurant_rounded;
    case 'Shopping':      return Icons.shopping_bag_rounded;
    case 'Transport':     return Icons.directions_car_rounded;
    case 'Entertainment': return Icons.movie_rounded;
    case 'Health':        return Icons.medical_services_rounded;
    case 'Education':     return Icons.school_rounded;
    default:              return Icons.receipt_rounded;
  }
}