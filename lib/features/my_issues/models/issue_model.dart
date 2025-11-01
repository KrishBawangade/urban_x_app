import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:urban_x_app/features/my_issues/utils/issue_status_enum.dart';
import '../utils/issue_category_enum.dart';

part 'issue_model.g.dart';

@JsonSerializable(explicitToJson: true)
class IssueModel {
  final String id;
  final String title;
  final String description;

  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  final IssueCategory category;

  final String imageUrl;
  final double latitude;
  final double longitude;
  final String submittedBy;
  final String? address;

  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final IssueStatus status;

  final int priority;

  @JsonKey(fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime createdAt;

  @JsonKey(fromJson: _timestampNullableFromJson, toJson: _timestampNullableToJson)
  final DateTime? verifiedAt;

  @JsonKey(fromJson: _timestampNullableFromJson, toJson: _timestampNullableToJson)
  final DateTime? resolvedAt;

  final int upvotes;

  /// 🆕 Field for assigning an issue to a department / officer
  final String? assignedAuthorityId;

  IssueModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.submittedBy,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.verifiedAt,
    this.resolvedAt,
    this.upvotes = 0,
    this.assignedAuthorityId,
  });

  /// ✅ From / To JSON
  factory IssueModel.fromJson(Map<String, dynamic> json) =>
      _$IssueModelFromJson(json);
  Map<String, dynamic> toJson() => _$IssueModelToJson(this);

  /// ✅ Firestore timestamp helpers
  static DateTime _timestampFromJson(Timestamp timestamp) => timestamp.toDate();
  static Timestamp _timestampToJson(DateTime date) => Timestamp.fromDate(date);

  static DateTime? _timestampNullableFromJson(Timestamp? timestamp) =>
      timestamp?.toDate();
  static Timestamp? _timestampNullableToJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;

  /// ✅ Enum conversions
  static IssueCategory _categoryFromJson(String value) =>
      IssueCategoryExtension.fromString(value);
  static String _categoryToJson(IssueCategory category) => category.name;

  static IssueStatus _statusFromJson(String value) =>
      IssueStatusExtension.fromString(value);
  static String _statusToJson(IssueStatus status) => status.name;

}
