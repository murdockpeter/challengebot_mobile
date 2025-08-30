// c:/Flutter/flutterapps/flutter_application_android/flutter_application_1/lib/screens/challenge_list_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/challenge_model.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This stream will listen for real-time updates from the 'challenges' collection.
    final Stream<QuerySnapshot<Challenge>> challengesStream = FirebaseFirestore
        .instance
        .collection('challenges')
        .withConverter<Challenge>(
          fromFirestore: (snapshot, _) => Challenge.fromFirestore(snapshot),
          toFirestore: (challenge, _) => challenge.toFirestore(),
        )
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: StreamBuilder<QuerySnapshot<Challenge>>(
        stream: challengesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final challenges = snapshot.data!.docs.map((doc) => doc.data()).toList();

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              // Use the new properties from the updated Challenge model
              return ListTile(
                title: Text(challenge.game),
                subtitle: Text(challenge.description), // This uses the new description getter
              );
            },
          );
        },
      ),
    );
  }
}
