class CostCalculator {
  static Map<String, dynamic> calculate({
    required double devCost,
    required int age,
    required String size,
    required int complexity,
    required int techDebt,
    required int years,
  }) {
    // Size factors
    final sizeFactors = {
      'Small': 1.0,
      'Medium': 1.3,
      'Large': 1.6,
      'Enterprise': 2.0,
    };

    final sizeFactor = sizeFactors[size] ?? 1.0;

    // Base maintenance rate (COCOMO II based)
    final baseRate = 0.15 + (complexity * 0.025) + (techDebt * 0.03);

    List<double> yearlyBreakdown = [];
    double total = 0;

    for (int i = 1; i <= years; i++) {
      // Age factor — older software costs more
      final ageFactor = 1.0 + ((age + i) * 0.04);
      // Inflation 3% per year
      final inflationFactor = 1.0 + (i * 0.03);

      final yearlyCost =
          devCost * baseRate * sizeFactor * ageFactor * inflationFactor;

      yearlyBreakdown.add(yearlyCost);
      total += yearlyCost;
    }

    // Recommendation
    String recommendation;
    if (total > devCost * 3) {
      recommendation =
          '⚠️ Total maintenance cost exceeds 3x development cost. '
          'Consider rebuilding the system.';
    } else if (total > devCost * 1.5) {
      recommendation =
          '📊 Maintenance cost is high. Consider refactoring and '
          'reducing technical debt.';
    } else {
      recommendation =
          '✅ Maintenance cost is reasonable. Continue with regular '
          'updates and monitoring.';
    }

    return {
      'yearlyBreakdown': yearlyBreakdown,
      'totalCost': total,
      'recommendation': recommendation,
    };
  }
}