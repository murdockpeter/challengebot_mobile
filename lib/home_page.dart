import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No users found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 80.0), // Padding for items and FAB
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              String fullName = data['full_name'] ?? 'No Name';
              String initials =
                  fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : '?';

              return Card(
                // The styling for this Card comes from the CardTheme in main.dart
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  title: Text(fullName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16)),
                  subtitle: Text(data['company'] ?? 'No Company'),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey[600]),
                  onTap: () {
                    // You can navigate to a detail page or show a dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped on $fullName')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement functionality to add a new user.
        },
        tooltip: 'Add User',
        child: const Icon(Icons.add),
      ),
    );
  }
}