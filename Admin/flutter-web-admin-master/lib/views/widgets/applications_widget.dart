import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_admin/views/screens/application_detail.dart';
import 'package:web_admin/views/screens/user_detail.dart';

class ApplicationsWidget extends StatelessWidget {
  const ApplicationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _applicationsStream =
        FirebaseFirestore.instance.collection('Applications').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _applicationsStream,
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
              DataColumn(label: Text('CV(curriculam vitae)')),
              DataColumn(label: Text('Full Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Organization')),
               DataColumn(label: Text('Submission Date')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.docs.map((doc) {
              final applicationData = doc.data() as Map<String, dynamic>;
              return DataRow(cells: [
            DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextButton(
                      onPressed: () async {
                        // Open the CV file link
                        final cvUrl = applicationData['cvUrl'];
                        if (cvUrl != null && cvUrl is String) {
                          final Uri url = Uri.parse(cvUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      child: const Text('Download CV'),
                    ),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(applicationData['applicantName'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(applicationData['applicantEmail'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(applicationData['applicantPhone'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(applicationData['opportunityName'] ?? ''),
                  ),
                ),
                 DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      applicationData['submittedAt'] != null
                          ? DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format((applicationData['submittedAt'] as Timestamp).toDate())
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
                                builder: (context) => ApplicationDetail(id: doc.id),
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
    var collection = FirebaseFirestore.instance.collection('Applications');
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