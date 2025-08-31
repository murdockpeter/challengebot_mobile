import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ChallengeApp());
}

class ChallengeApp extends StatelessWidget {
  const ChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set the home page to our new ChallengeListPage
      home: const ChallengeListPage(),
    );
  }
}

// This is the new Widget that will display your challenges
class ChallengeListPage extends StatelessWidget {
  const ChallengeListPage({super.key});

  // Helper function to determine the color of the status chip
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      case 'accepted':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      // Use a StreamBuilder to listen for real-time updates from Firestore
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              // 1. Point the stream to your 'challenges' collection in Firestore.
              //    Make sure the collection name here EXACTLY matches your database.
              stream: FirebaseFirestore.instance.collection('challenges').snapshots(),
              builder: (context, snapshot) {
                // Handle the loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Handle any errors
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong: ${snapshot.error}'));
                }

                // Handle the case where the collection is empty
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No challenges found.'));
                }

                // If we have data, build the list
                final challenges = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    // 2. Access the data for each document.
                    final challengeData = challenges[index].data() as Map<String, dynamic>;

                    // Extract the data fields from the document with null safety
                    final game = challengeData['game'] as String? ?? 'Unknown Game';
                    final challenger = challengeData['challenger_name'] as String? ?? 'Challenger';
                    final opponent = challengeData['opponent_name'] as String? ?? 'Opponent';
                    final status = challengeData['status'] as String? ?? 'unknown';

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        leading: const Icon(Icons.shield_outlined, color: Colors.teal),
                        title: Text(game, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('$challenger vs. $opponent'),
                        trailing: Chip(
                          label: Text(status, style: const TextStyle(color: Colors.white)),
                          backgroundColor: _getStatusColor(status),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
