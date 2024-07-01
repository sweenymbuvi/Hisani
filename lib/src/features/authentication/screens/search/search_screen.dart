import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController controller;
  bool isSearching = false;
  bool isCategorySearching = false;
  List<Map<String, dynamic>> searchResults = [];
  bool noMatchFound = false;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  Future<void> searchOrganizations(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        noMatchFound = false;
      });
      return;
    }

    final collection = FirebaseFirestore.instance.collection('organizations');
    final querySnapshot = await collection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      setState(() {
        searchResults = docs
            .map((doc) => doc.data()..['id'] = doc.id)
            .toList(); // Include the document ID
        noMatchFound = false;
      });
    } else {
      setState(() {
        searchResults = [];
        noMatchFound = true;
      });
    }
  }

  Future<void> searchOrganizationsByCategory(String category) async {
    setState(() {
      isSearching = true;
      isCategorySearching = true;
      searchResults = [];
      noMatchFound = false;
    });

    final collection = FirebaseFirestore.instance.collection('organizations');
    final querySnapshot =
        await collection.where('category', isEqualTo: category).get();

    final docs = querySnapshot.docs;
    if (docs.isNotEmpty) {
      setState(() {
        searchResults = docs
            .map((doc) => doc.data()..['id'] = doc.id)
            .toList(); // Include the document ID
        noMatchFound = false;
      });
    } else {
      setState(() {
        searchResults = [];
        noMatchFound = true;
      });
    }
  }

  void clearSearch() {
    setState(() {
      controller.clear();
      isSearching = false;
      isCategorySearching = false;
      searchResults = [];
      noMatchFound = false;
    });
  }

  void goBackFromCategorySearch() {
    setState(() {
      isSearching = false;
      isCategorySearching = false;
      searchResults = [];
      noMatchFound = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: !isSearching
                      ? Text(
                          'Explore',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : Row(
                          children: [
                            if (isCategorySearching)
                              GestureDetector(
                                onTap: goBackFromCategorySearch,
                                child: SizedBox(
                                  width: 24.w,
                                  child: SvgPicture.asset(
                                    'assets/images/back.png',
                                    width: 24.w,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                'Search Result',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 24.w,
                            )
                          ],
                        ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: _buildSearchBar(),
              ),
              SizedBox(height: 16.h),
              if (isSearching) _buildResult() else _buildSearching(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Search for an organization...',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                setState(() {
                  isSearching = value
                      .isNotEmpty; // Only start searching if input is not empty
                  isCategorySearching = false;
                });
                searchOrganizations(value);
              },
            ),
          ),
          if (isSearching && controller.text.isNotEmpty)
            GestureDetector(
              onTap: clearSearch,
              child: Icon(Icons.clear,
                  color: Colors.black), // X button to clear the search
            ),
          SizedBox(width: 8.w), // Add some space between the buttons
          GestureDetector(
            onTap: () {
              setState(() {
                isSearching = true;
                isCategorySearching = false;
              });
              searchOrganizations(controller.text);
            },
            child: Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        child: searchResults.isEmpty
            ? Center(
                child: Text(
                  noMatchFound ? 'No match found' : 'Searching...',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final organization = searchResults[index];
                  return _buildResultCard(organization);
                },
              ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> organization) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      child: ListTile(
        leading: organization['picture'] != null
            ? Image.network(organization['picture'], width: 50.w, height: 50.h)
            : SizedBox(
                width: 50.w,
                height: 50.h,
                child: Icon(Icons.business),
              ),
        title: Text(organization['name']),
        subtitle: Text(organization['objective'] ?? 'No objective available'),
        onTap: () {
          // Navigate to the DetailScreen with the organizationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(organization['id']), // Pass the organization ID
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearching(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.0.w,
          children: [
            _buildCategoryChip('Children\'s Home'),
            _buildCategoryChip('Schools'),
            _buildCategoryChip('Health'),
            _buildCategoryChip('Others'),
            // Add more categories as needed
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category) {
    return GestureDetector(
      onTap: () {
        searchOrganizationsByCategory(category);
      },
      child: Chip(
        label: Text(category),
        // You can customize the appearance of the chip here
        // Example: backgroundColor: Colors.blue, labelStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
