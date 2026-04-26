import 'package:cloud_firestore/cloud_firestore.dart';

class EstimationModel {
  final String? id;
  final String softwareName;
  final int softwareAge;
  final String softwareSize;
  final String softwareType;
  final String language;
  final int teamSize;
  final double devCost;
  final int complexity;
  final int techDebt;
  final int years;
  final double totalCost;
  final List<double> yearlyBreakdown;
  final String recommendation;
  final DateTime createdAt;
  final String currency;

  EstimationModel({
    
    this.id,
    required this.softwareName,
    required this.softwareAge,
    required this.softwareSize,
    required this.softwareType,
    required this.language,
    required this.teamSize,
    required this.devCost,
    required this.complexity,
    required this.techDebt,
    required this.years,
    required this.totalCost,
    required this.yearlyBreakdown,
    required this.recommendation,
    required this.createdAt,
    required this.currency,
  });

  factory EstimationModel.fromMap(Map<String, dynamic> map, String id) {
    return EstimationModel(
      id: id,
      softwareName: map['softwareName'] ?? '',
      softwareAge: map['softwareAge'] ?? 0,
      softwareSize: map['softwareSize'] ?? '',
      softwareType: map['softwareType'] ?? '',
      language: map['language'] ?? '',
      teamSize: map['teamSize'] ?? 0,
      devCost: (map['devCost'] ?? 0).toDouble(),
      complexity: map['complexity'] ?? 5,
      techDebt: map['techDebt'] ?? 5,
      years: map['years'] ?? 5,
      totalCost: (map['totalCost'] ?? 0).toDouble(),
      yearlyBreakdown: List<double>.from(
        (map['yearlyBreakdown'] ?? []).map((e) => e.toDouble())),
      recommendation: map['recommendation'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      currency: map['currency'] ?? 'USD', // Yeh line line 42 ke paas add karein
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'softwareName': softwareName,
      'softwareAge': softwareAge,
      'softwareSize': softwareSize,
      'softwareType': softwareType,
      'language': language,
      'teamSize': teamSize,
      'devCost': devCost,
      'complexity': complexity,
      'techDebt': techDebt,
      'years': years,
      'totalCost': totalCost,
      'yearlyBreakdown': yearlyBreakdown,
      'recommendation': recommendation,
      'createdAt': FieldValue.serverTimestamp(),
      'currency': currency,
    };
  }
}