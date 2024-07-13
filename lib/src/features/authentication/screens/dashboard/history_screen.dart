import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final String fullName;

  HistoryScreen({required this.fullName});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _donationHistoryFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _donationHistoryFuture = fetchDonationHistory(widget.fullName);
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<List<Map<String, dynamic>>> fetchDonationHistory(
      String fullName) async {
    List<Map<String, dynamic>> history = [];

    // Fetch physical donations
    QuerySnapshot physicalDonationsSnapshot = await FirebaseFirestore.instance
        .collection('PhysicalDonations')
        .where('userFullName', isEqualTo: fullName)
        .get();

    for (var doc in physicalDonationsSnapshot.docs) {
      history.add({
        'type': 'Physical Donation',
        'data': doc.data() as Map<String, dynamic>,
      });
    }

    // Fetch money donations
    QuerySnapshot moneyDonationsSnapshot = await FirebaseFirestore.instance
        .collection('donations')
        .where('FullName', isEqualTo: fullName)
        .get();

    for (var doc in moneyDonationsSnapshot.docs) {
      history.add({
        'type': 'Money Donation',
        'data': doc.data() as Map<String, dynamic>,
      });
    }

    // Fetch volunteer applications
    QuerySnapshot volunteerApplicationsSnapshot = await FirebaseFirestore
        .instance
        .collection('Applications')
        .where('applicantName', isEqualTo: fullName)
        .get();

    for (var doc in volunteerApplicationsSnapshot.docs) {
      final applicationData = doc.data() as Map<String, dynamic>;
      final status = applicationData['status'] ?? 'Pending';

      history.add({
        'type': 'Volunteer Application',
        'data': applicationData,
        'status': status,
      });
    }

    return history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Donations'),
            Tab(text: 'Volunteering'),
          ],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _donationHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final history = snapshot.data;

          if (history == null || history.isEmpty) {
            return Center(child: Text('No history found.'));
          }

          final donationHistory = history
              .where((item) =>
                  item['type'] == 'Physical Donation' ||
                  item['type'] == 'Money Donation')
              .toList();
          final volunteerHistory = history
              .where((item) => item['type'] == 'Volunteer Application')
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              buildHistoryList(donationHistory),
              buildVolunteerHistoryList(volunteerHistory),
            ],
          );
        },
      ),
    );
  }

  Widget buildHistoryList(List<Map<String, dynamic>> history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final type = item['type'];
        final data = item['data'];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(type),
              subtitle: Text(formatData(type, data)),
            ),
          ),
        );
      },
    );
  }

  Widget buildVolunteerHistoryList(List<Map<String, dynamic>> history) {
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        final type = item['type'];
        final data = item['data'];
        final status = item['status'] ?? 'Pending';

        Color statusColor = Colors.grey; // Default color for pending

        if (status == 'Approved') {
          statusColor = Colors.green;
        } else if (status == 'Rejected') {
          statusColor = Colors.red;
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(type),
              subtitle: Text(formatData(type, data)),
              trailing: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatData(String type, Map<String, dynamic> data) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: 'Ksh');

    switch (type) {
      case 'Physical Donation':
        final timestamp = data['timestamp'] as Timestamp?;
        final date =
            timestamp != null ? dateFormat.format(timestamp.toDate()) : 'N/A';
        return 'Organization: ${data['organizationName'] ?? 'N/A'}\nItem: ${data['itemName'] ?? 'N/A'}\nDescription: ${data['description'] ?? 'N/A'}\nQuantity: ${data['quantity'] ?? 'N/A'}\nDate: $date';
      case 'Money Donation':
        final timestamp = data['timestamp'] as Timestamp?;
        final date =
            timestamp != null ? dateFormat.format(timestamp.toDate()) : 'N/A';
        final amount = data['amount'] as num?;
        final formattedAmount =
            amount != null ? currencyFormat.format(amount) : 'N/A';
        return 'Amount: $formattedAmount\nDate: $date';
      case 'Volunteer Application':
        final timestamp = data['submittedAt'] as Timestamp?;
        final date =
            timestamp != null ? dateFormat.format(timestamp.toDate()) : 'N/A';
        return 'Opportunity Name: ${data['opportunityName'] ?? 'N/A'}\nDate: $date';
      default:
        return data.toString();
    }
  }
}