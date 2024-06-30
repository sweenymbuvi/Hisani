import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisani/src/features/authentication/screens/volunteer/volunteer_details_screen.dart';

class VolunteerScreen extends StatefulWidget {
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  // Controller to manage the search input
  TextEditingController _searchController = TextEditingController();
  // String to hold the current search query
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Opportunities'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search opportunities',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // List of opportunities
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Volunteering')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> opportunities = snapshot.data!.docs;

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  opportunities = opportunities.where((doc) {
                    Map<String, dynamic>? data =
                        doc.data() as Map<String, dynamic>?;
                    String name = data?['name']?.toString().toLowerCase() ?? '';
                    return name.contains(_searchQuery);
                  }).toList();
                }

                if (opportunities.isEmpty) {
                  return Center(
                      child: Text('No volunteer opportunities found.'));
                }

                return ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic>? data =
                        opportunities[index].data() as Map<String, dynamic>?;

                    String name = data?['name'] ?? 'Opportunity Name';
                    int vacancies = data?['vacancies'] ?? 0;
                    String imageUrl = data?['imageUrl'] ?? '';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VolunteerDetailScreen(opportunities[index].id),
                          ),
                        );
                      },
                      child: VolunteerBanner(
                        name: name,
                        imageUrl: imageUrl,
                        vacancies: vacancies,
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

class VolunteerBanner extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int vacancies;

  const VolunteerBanner({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.vacancies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                    child: Icon(Icons.image, size: 50, color: Colors.white),
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Vacancies: $vacancies',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
