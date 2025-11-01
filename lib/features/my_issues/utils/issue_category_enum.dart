enum IssueCategory {
  roadDamage,
  garbage,
  streetLight,
  waterLeakage,
  sewageOverflow,
  illegalParking,
  noisePollution,
  airPollution,
  treeCutting,
  encroachment,
  publicSafety,
  drainage,
  animalIssue,
  electricPole,
  other,
}

extension IssueCategoryExtension on IssueCategory {
  String get displayName {
    switch (this) {
      case IssueCategory.roadDamage:
        return "Road Damage";
      case IssueCategory.garbage:
        return "Garbage";
      case IssueCategory.streetLight:
        return "Street Light";
      case IssueCategory.waterLeakage:
        return "Water Leakage";
      case IssueCategory.sewageOverflow:
        return "Sewage Overflow";
      case IssueCategory.illegalParking:
        return "Illegal Parking";
      case IssueCategory.noisePollution:
        return "Noise Pollution";
      case IssueCategory.airPollution:
        return "Air Pollution";
      case IssueCategory.treeCutting:
        return "Tree Cutting";
      case IssueCategory.encroachment:
        return "Encroachment";
      case IssueCategory.publicSafety:
        return "Public Safety";
      case IssueCategory.drainage:
        return "Drainage";
      case IssueCategory.animalIssue:
        return "Animal Issue";
      case IssueCategory.electricPole:
        return "Electric Pole";
      case IssueCategory.other:
        return "Other";
    }
  }

  static IssueCategory fromString(String value) {
    return IssueCategory.values.firstWhere(
      (e) => e.displayName.toLowerCase() == value.toLowerCase(),
      orElse: () => IssueCategory.other,
    );
  }
}
