import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/challenge_model.dart';

class ChallengeListScreen extends StatelessWidget {
  const ChallengeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get a reference to the 'challenges' collection.
    // Using .withConverter for type-safe data handling.
    final Stream<QuerySnapshot<Challenge>> challengesStream = FirebaseFirestore
        .instance
        .collection('challenges')
        .withConverter<Challenge>(
          fromFirestore: (snapshot, _) => Challenge.fromFirestore(snapshot),
          // The toFirestore function must return a Map<String, Object?>.
          toFirestore: (challenge, _) => {
            'challenge_name': challenge.challengerName,
            'challenge_description': challenge.description
          },
        )
        .snapshots();
        
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: StreamBuilder<QuerySnapshot<Challenge>>(
        stream: challengesStream,
        builder: (context, snapshot) {
          // Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Show a loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // A safer way to check for data.
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No challenges found.'));
          }

          final challenges =
              snapshot.data!.docs.map((doc) => doc.data()).toList();

          // Use ListView.builder for better performance with long lists.
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Side color bar
                      Container(
                        width: 12,
                        color: colorScheme.primaryContainer,
                      ),
                      // Challenge details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                challenge.challengerName,
                                style: theme.textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                challenge.description,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Icon on the right
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Icon(
                            Icons.emoji_events_outlined,
                            color: colorScheme.secondary,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}