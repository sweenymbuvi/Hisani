import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hisani/src/constants/colors.dart';
import 'package:hisani/src/features/authentication/models/organization_model.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/donate_physical_screen.dart';
import 'package:hisani/src/features/authentication/screens/dashboard/widgets/calculator_builder.dart';
import 'package:hisani/src/features/authentication/screens/maps/map_detail_screen.dart';
import 'package:hisani/src/features/authentication/screens/payment/billingDetailsScreen.dart';

class DetailScreen extends StatelessWidget {
  final String organizationId;
   final String organizationName;

 const DetailScreen({
    Key? key,
    required this.organizationId,
    required this.organizationName,
  }) : super(key: key);

  Future<OrganizationModel?> fetchOrganization() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('organizations')
          .doc(organizationId)
          .get();

      if (!snapshot.exists) {
        return null; // Handle case where organization with given ID is not found
      }

      return OrganizationModel.fromSnapshot(snapshot);
    } catch (e) {
      print('Error fetching organization: $e');
      return null; // Return null on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kPrimaryColor,
      body: FutureBuilder<OrganizationModel?>(
        future: fetchOrganization(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final organization = snapshot.data;

          if (organization == null) {
            return Center(
                child:
                    Text('No data found for organization ID: $organizationId'));
          }

          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
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
                          child: organization.imageUrl != null
                              ? Image.network(
                                  organization.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200.h,
                                )
                              : Container(),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).viewPadding.top,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 24.w,
                                    color: Colors.white,
                                  ),
                                ),
                                Spacer(),
                                // Add more actions if needed
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organization.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Objective: ${organization.objective}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Contact: ${organization.phoneNumber}',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Location: ${organization.location}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.location_on,
                                    color: Colors.white),
                                onPressed: () => _showLocationOnMap(context,
                                    organization.name, organization.location),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Donation Needs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Donation Needs List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: organization.donationNeeds.length,
                            itemBuilder: (context, index) {
                              final need = organization.donationNeeds[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          need.item,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text('Quantity: ${need.quantity}'),
                                        SizedBox(height: 4.h),
                                        Text('Urgency: ${need.urgency}'),
                                        SizedBox(height: 4.h),
                                        Text(need.description),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 100
                            .h), // Add some bottom padding to make space for the Donate button
                  ],
                ),
              ),
              // Positioned "Donate" button
              Positioned(
                bottom: 16.h,
                left: 16.w,
                right: 16.w,
                child: ElevatedButton(
                  onPressed: () => _showDonateOptions(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.kAccentColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Donate',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLocationOnMap(
      BuildContext context, String organizationName, String location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SimpleMap(
          organizationName: organizationName,
          location: location,
        ),
      ),
    );
  }

  void _showDonateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your donation type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal
                     Get.to(() => BillingDetailsScreen(
                    organizationId: organizationId,
                    organizationName: organizationName,
                  ));
                    // showModalBottomSheet(
                    //   context: context,
                    //   isScrollControlled: true,
                    //   builder: (BuildContext context) {
                    //     return CalculatorBuilder(); // Assuming CalculatorBuilder is for monetary donations
                    //   },
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Adjust with your color
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text('Donate Money'),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DonateItemScreen(organizationId: organizationId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Adjust with your color
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: Text('Donate Physical Item'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
