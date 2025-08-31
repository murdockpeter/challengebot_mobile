import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({super.key});

  @override
  State<ChallengesPage> createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> {
  // Get a reference to the 'challenges' collection in Firestore
  final Stream<QuerySnapshot> _challengesStream =
      FirebaseFirestore.instance.collection('challenges').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _challengesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 1. Handle errors
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // 2. Show a loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 3. Handle the case where there are no challenges
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No challenges found.'));
          }

          // 4. If we have data, build the list
          return ListView(
            padding: const EdgeInsets.only(top: 8.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              // --- DIAGNOSTIC PRINT ---
              // This will print the contents of a document to your debug console.
              print('Firestore document data: $data');

              // Use the actual field names from your Firestore 'challenges' collection.
              // For example, if your fields are 'challengeName' and 'challengeDescription':
              String name = data['title'] ?? 'Unnamed Challenge';
              String description =
                  data['details'] ?? 'No description available.';

              return Card(
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(description),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}