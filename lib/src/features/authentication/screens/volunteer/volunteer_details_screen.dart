import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/features/authentication/models/volunteering_model.dart';
import 'application_screen.dart'; // Import the new screen

class VolunteerDetailScreen extends StatelessWidget {
  final String opportunityId;

  VolunteerDetailScreen(this.opportunityId);

  Future<VolunteeringModel?> fetchOpportunity() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Volunteering')
          .doc(opportunityId)
          .get();

      if (!snapshot.exists) {
        return null; // Handle case where opportunity with given ID is not found
      }

      return VolunteeringModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching opportunity: $e');
      return null; // Return null on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kPrimaryColor,
      appBar: AppBar(
        title: Text('Volunteering Opportunity Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<VolunteeringModel?>(
        future: fetchOpportunity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final opportunity = snapshot.data;

          if (opportunity == null) {
            return Center(
                child:
                    Text('No data found for opportunity ID: $opportunityId'));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.r),
                          bottomRight: Radius.circular(32.r),
                        ),
                        color: AppColor.kPlaceholder1,
                      ),
                      child: opportunity.imageUrl != null &&
                              opportunity.imageUrl.isNotEmpty
                          ? Image.network(
                              opportunity.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200.h,
                            )
                          : Container(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Location: ${opportunity.location}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Contact: ${opportunity.phoneNumber}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Description:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.h,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            opportunity.description,
                            style:
                                TextStyle(fontSize: 16.h, color: Colors.white),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vacancies: ${opportunity.vacancies}',
                                style: TextStyle(
                                    fontSize: 16.h, color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to the ApplicationScreen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ApplicationScreen(
                                          opportunityId: opportunityId),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.kAccentColor,
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h), // Adjust spacing as needed
                        ],
                      ),
                    ),
                    SizedBox(height: 100.h), // Adjust bottom padding as needed
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
