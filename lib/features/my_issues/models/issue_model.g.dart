// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IssueModel _$IssueModelFromJson(Map<String, dynamic> json) => IssueModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  category: IssueModel._categoryFromJson(json['category'] as String),
  imageUrl: json['imageUrl'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  submittedBy: json['submittedBy'] as String,
  status: IssueModel._statusFromJson(json['status'] as String),
  priority: (json['priority'] as num).toInt(),
  createdAt: IssueModel._timestampFromJson(json['createdAt'] as Timestamp),
  verifiedAt: IssueModel._timestampNullableFromJson(
    json['verifiedAt'] as Timestamp?,
  ),
  resolvedAt: IssueModel._timestampNullableFromJson(
    json['resolvedAt'] as Timestamp?,
  ),
  upvotes: (json['upvotes'] as num?)?.toInt() ?? 0,
  assignedAuthorityId: json['assignedAuthorityId'] as String?,
);

Map<String, dynamic> _$IssueModelToJson(IssueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': IssueModel._categoryToJson(instance.category),
      'imageUrl': instance.imageUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'submittedBy': instance.submittedBy,
      'address': instance.address,
      'status': IssueModel._statusToJson(instance.status),
      'priority': instance.priority,
      'createdAt': IssueModel._timestampToJson(instance.createdAt),
      'verifiedAt': IssueModel._timestampNullableToJson(instance.verifiedAt),
      'resolvedAt': IssueModel._timestampNullableToJson(instance.resolvedAt),
      'upvotes': instance.upvotes,
      'assignedAuthorityId': instance.assignedAuthorityId,
    };
