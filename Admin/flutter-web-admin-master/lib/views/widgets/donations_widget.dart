import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/views/screens/donation_detail.dart';

class DonationsWidget extends StatelessWidget {
  const DonationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _donationsStream =
        FirebaseFirestore.instance.collection('donations').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _donationsStream,
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
              DataColumn(label: Text('Organization Name')),
              DataColumn(label: Text('Phone Number')),
               DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Status')),
          
             DataColumn(label: Text('Date')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.docs.map((doc) {
              final donationsData = doc.data() as Map<String, dynamic>;
              return DataRow(cells: [
          
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(donationsData['FullName'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(donationsData['organizationName'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(donationsData['phoneNumber'] ?? ''),
                  ),
                ),
                   DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child:Text(donationsData['amount'].toString()),
                  ),
                ),
                
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(donationsData['status'] ?? ''),
                  ),
                ),
                       DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      donationsData['timestamp'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format((donationsData['timestamp'] as Timestamp).toDate())
                          : '',
                    ),
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
                                builder: (context) => DonationDetail(id: doc.id),
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
          content: const Text('Do you really want to delete this record?'),
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
    var collection = FirebaseFirestore.instance.collection('donations');
    collection
        .doc(docId)
        .delete()
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record deleted successfully!')),
          );
        })
        .catchError((error) => print('Delete failed: $error'));
  }
}