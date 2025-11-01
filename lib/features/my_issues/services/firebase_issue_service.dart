import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/issue_model.dart';

/// A service class to manage civic issues in Firestore for the UrbanX app.
/// Handles adding, fetching, updating, and deleting issue reports.
class FirebaseIssueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reference to the issues collection
  CollectionReference get _issuesRef => _firestore.collection('issues');

  /// Adds a new issue to Firestore using IssueModel
  Future<void> addIssue(IssueModel issue) async {
    try {
      await _issuesRef.add(issue.toJson());
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all issues (sorted by creation date)
  Future<List<IssueModel>> fetchAllIssues() async {
    try {
      final snapshot =
          await _issuesRef.orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IssueModel.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches issues submitted by the current user
  Future<List<IssueModel>> fetchMyIssues() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _issuesRef
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return IssueModel.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Updates an existing issue
  Future<void> updateIssue(String issueId, Map<String, dynamic> updatedData) async {
    try {
      await _issuesRef.doc(issueId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  /// Deletes an issue
  Future<void> deleteIssue(String issueId) async {
    try {
      await _issuesRef.doc(issueId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
