import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_admin/views/screens/user_detail.dart';

class UsersWidget extends StatelessWidget {
  const UsersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('Users').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.cyan));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
            
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Secondary Email')),
           //   DataColumn(label: Text('Secondary Phone')),
               DataColumn(label: Text('role')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.docs.map((doc) {
              final userData = doc.data() as Map<String, dynamic>;
              return DataRow(cells: [
                // DataCell(
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: Image.network(
                //       userData['ProfilePicUrl'] ?? '',
                //       fit: BoxFit.cover,
                //       height: 50,
                //       width: 50,
                //     ),
                //   ),
                // ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(userData['FullName'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(userData['Email'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(userData['Phone'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(userData['SecondaryEmail'] ?? 'N/A'),
                  ),
                ),
                // DataCell(
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: Text(userData['SecondaryPhone'] ?? 'N/A'),
                //   ),
                // ),
                 DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(userData['role'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetailsScreen(id: doc.id),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          child: const Text('Details'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            _showDeleteDialog(context, doc.id);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to delete this user?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteUser(context, docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context, String docId) {
    var collection = FirebaseFirestore.instance.collection('Users');
    collection
        .doc(docId)
        .delete()
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully!')),
          );
        })
        .catchError((error) => print('Delete failed: $error'));
  }
}