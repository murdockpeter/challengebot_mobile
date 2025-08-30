// c:/Flutter/flutterapps/flutter_application_android/flutter_application_1/lib/models/challenge_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String game;
  final String challengerName;
  final String opponentName;
  final String status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String challengerId;
  final String opponentId;
  final String? winnerId;
  final String? loserId;
  final String? result;
  final String? id; // Document ID

  Challenge({
    required this.game,
    required this.challengerName,
    required this.opponentName,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    required this.challengerId,
    required this.opponentId,
    this.winnerId,
    this.loserId,
    this.result,
    this.id,
  });

  // Helper to get a display-friendly description for the UI.
  String get description {
    return '$challengerName vs. $opponentName';
  }

  factory Challenge.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Snapshot data was null!');
    }

    // Helper to safely convert Firestore Timestamps to DateTime.
    DateTime? toDateTime(Timestamp? timestamp) => timestamp?.toDate();

    return Challenge(
      id: snapshot.id,
      game: data['game'] ?? 'Unknown Game',
      challengerName: data['challenger_name'] ?? 'Unknown Challenger',
      opponentName: data['opponent_name'] ?? 'Unknown Opponent',
      status: data['status'] ?? 'unknown',
      createdAt: toDateTime(data['created_at']) ?? DateTime.now(),
      acceptedAt: toDateTime(data['accepted_at']),
      completedAt: toDateTime(data['completed_at']),
      // Firestore can store large numbers for IDs. It's safer to handle them as strings.
      challengerId: data['challenger_id']?.toString() ?? '',
      opponentId: data['opponent_id']?.toString() ?? '',
      winnerId: data['winner_id']?.toString(),
      loserId: data['loser_id']?.toString(),
      result: data['result'],
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'game': game,
      'challenger_name': challengerName,
      'opponent_name': opponentName,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
      if (acceptedAt != null) 'accepted_at': Timestamp.fromDate(acceptedAt!),
      if (completedAt != null) 'completed_at': Timestamp.fromDate(completedAt!),
      'challenger_id': challengerId,
      'opponent_id': opponentId,
      if (winnerId != null) 'winner_id': winnerId,
      if (loserId != null) 'loser_id': loserId,
      if (result != null) 'result': result,
    };
  }
}
