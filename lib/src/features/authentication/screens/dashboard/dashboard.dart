import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/details_screen.dart';
import 'package:hisani/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:hisani/src/features/authentication/screens/search/search_screen.dart';
import 'package:hisani/src/features/authentication/screens/volunteer/volunteer_opportunities.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HISANI',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.yellow,
          titleTextStyle: TextStyle(color: Colors.black),
          centerTitle: true,
        ),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    HomeTab(),
    SearchTab(),
    VolunteerTab(), // Added the VolunteerTab
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HISANI'),
        centerTitle: true,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Set selected icon color to black
        unselectedItemColor: Colors.black, // Set unselected icon color to black
        selectedLabelStyle:
            TextStyle(color: Colors.black), // Set selected text color to black
        unselectedLabelStyle: TextStyle(
            color: Colors.black), // Set unselected text color to black
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Volunteer', // Added Volunteer item
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person,
                  color: Colors.black), // Set icon color to black
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('organizations').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> organizations = snapshot.data!.docs;

        if (organizations.isEmpty) {
          return Center(child: Text('No organizations found.'));
        }

        return ListView.builder(
          itemCount: organizations.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                organizations[index].data() as Map<String, dynamic>;

            String name = data['name'] ?? 'Organization Name';
            String objective = data['objective'] ?? 'Objective not provided';
            String imageUrl =
                data['imageUrl'] ?? ''; // Ensure 'imageUrl' field exists

            return GestureDetector(
              onTap: () {
                print(
                    'Organization ID: ${organizations[index].id}'); // Print the ID when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(organizations[index].id),
                  ),
                );
              },
              child: CharityBanner(
                name: name,
                objective: objective,
                imageUrl: imageUrl,
              ),
            );
          },
        );
      },
    );
  }
}

class SearchTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SearchScreen();
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(); // Directly use the ProfileScreen as content for the Profile tab
  }
}

class VolunteerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VolunteerScreen(); // Directly use the ProfileScreen as content for the Profile tab
  }
}

class CharityBanner extends StatelessWidget {
  final String name;
  final String objective;
  final String imageUrl;

  const CharityBanner({
    Key? key,
    required this.name,
    required this.objective,
    required this.imageUrl,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Objective: $objective',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
