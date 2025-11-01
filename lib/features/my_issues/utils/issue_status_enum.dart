// lib/features/my_issues/utils/issue_status_enum.dart

enum IssueStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

extension IssueStatusExtension on IssueStatus {
  String get label {
    switch (this) {
      case IssueStatus.pending:
        return 'Pending';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.rejected:
        return 'Rejected';
    }
  }

  static IssueStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return IssueStatus.pending;
      case 'in progress':
      case 'inprogress':
        return IssueStatus.inProgress;
      case 'resolved':
        return IssueStatus.resolved;
      case 'rejected':
        return IssueStatus.rejected;
      default:
        throw ArgumentError('Invalid issue status: $status');
    }
  }
}
