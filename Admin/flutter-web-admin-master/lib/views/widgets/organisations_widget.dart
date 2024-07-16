import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/views/screens/crud_detail_screen.dart';

class OrganisationsWidget extends StatelessWidget {
  const OrganisationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _organizationsStream =
        FirebaseFirestore.instance.collection('organizations').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _organizationsStream,
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
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Phone Number')),
              DataColumn(label: Text('Actions')),
            ],
            rows: snapshot.data!.docs.map((doc) {
              final organizationData = doc.data() as Map<String, dynamic>;
              return DataRow(cells: [
                // DataCell(
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: Image.network(
                //       organizationData['imageUrl'],
                //       fit: BoxFit.cover,
                //       height: 50,
                //       width: 50,
                //     ),
                //   ),
                // ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(organizationData['name'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(organizationData['location'] ?? ''),
                  ),
                ),
                DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(organizationData['phoneNumber'] ?? ''),
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
      builder: (context) => CrudDetailScreen(id: doc.id),
    ),
  );
},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            side: BorderSide(color: Colors.blue),
                          ),
                          child: Text('Details'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                         onPressed: () {
                            _showDeleteDialog(context, doc.id);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Text('Delete'),
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
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Are you sure?',
      desc: 'Do you really want to delete this organization?',
      width: 350,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        _deleteOrganization(context, docId);
      },
      btnOkText: 'Delete',
      btnCancelText: 'Cancel',
      btnOkColor: Colors.red,
    ).show();
  }

 void _deleteOrganization(BuildContext context, String docId) {
    var collection = FirebaseFirestore.instance.collection('organizations');
    collection
        .doc(docId)
        .delete()
        .then((_) {
          print('Deleted');
          _showSuccessDialog(context);
        })
        .catchError((error) => print('Delete failed: $error'));
  }

 void _showSuccessDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Success',
      desc: 'The organization has been deleted successfully!',
      width: 350,
      btnOkOnPress: () {},
      btnOkText: 'OK',
      btnOkColor: Colors.green,
    ).show();
  }
}

