// import 'package:flutter/material.dart';
// import 'package:hisani/src/constants/colors.dart';
// import 'package:hisani/src/constants/image_strings.dart';
// import 'package:hisani/src/constants/sizes.dart';
// import 'package:hisani/src/constants/text_strings.dart';

// class Dashboard extends StatelessWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Define your list here. This is just a placeholder example.
//     List<Item> list = [
//       Item(title: "Item 1", onPress: () {}),
//       Item(title: "Item 2", onPress: () {}),
//       Item(title: "Item 3", onPress: () {}),
//     ];

//     // Determine whether the app is in dark mode
//     bool isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         leading: Icon(
//           Icons.menu,
//           color: isDark ? tWhiteColor : tDarkColor,
//         ),
//         title: Text(tAppName, style: Theme.of(context).textTheme.headlineSmall),
//         actions: [
//           SingleChildScrollView(
//             child: Container(
//               margin: const EdgeInsets.only(right: 20, top: 7),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: isDark ? tSecondaryColor : tCardBgColor,
//               ),
//               child: IconButton(
//                 onPressed: () {},
//                 icon: const Image(image: AssetImage(tUserProfileImage)),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.all(tDashboardPadding),
//           color: isDark ? tSecondaryColor : tCardBgColor,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //heading
//               Text(tDashboardTitle, style: Theme.of(context).textTheme.bodyLarge),
//               Text(tDashboardHeading, style: Theme.of(context).textTheme.headlineSmall),
//               const SizedBox(height: tDashboardPadding),

//               //search bar
//               Container(
//                 decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(tDashboardSearch, style: Theme.of(context).textTheme.headlineSmall?.apply(color: Colors.grey.withOpacity(0.5))),
//                     const Icon(Icons.mic, size: 25),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: tDashboardPadding),

//               //Categories
//               SizedBox(
//                 height: 45,
//                 child: ListView.builder(
//                   itemCount: list.length,
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) => GestureDetector(
//                     onTap: list[index].onPress,
//                     child: SizedBox(
//                       width: 170,
//                       height: 45,
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             height: 45,
//                             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: isDark ? tDarkColor : tWhiteColor),
//                             child: Center(
//                               child: Text(list[index].title, style: Theme.of(context).textTheme.headlineSmall?.apply(color: isDark ? tWhiteColor : tDarkColor)),
//                             ),
//                           ),
//                           const SizedBox(width: 5),
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text("Redcross", style: Theme.of(context).textTheme.headlineSmall, overflow: TextOverflow.ellipsis),
//                                 Text("Flood Victims", style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: tDashboardPadding),

//               // Banner
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //1st banner
//                   Expanded(
//                     child: SingleChildScrollView(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: isDark ? tSecondaryColor : tCardBgColor,
//                         ),
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: const [
//                                 Flexible(child: Image(image: AssetImage(tBookmarkIcon))),
//                                 Flexible(child: Image(image: AssetImage(tBannerImage1))),
//                               ],
//                             ),
//                             const SizedBox(height: 25),
//                             Text(tDashboardBannerTitle1, style: Theme.of(context).textTheme.headlineSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
//                             Text(tDashboardBannerSubTitle, style: Theme.of(context).textTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: tDashboardCardPadding),
//                   //2nd Banner
//                   Expanded(
//                     child: Column(
//                       children: [
//                         //Card
//                         SingleChildScrollView(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: isDark ? tSecondaryColor : tCardBgColor,
//                             ),
//                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: const [
//                                     Flexible(child: Image(image: AssetImage(tBookmarkIcon))),
//                                     Flexible(child: Image(image: AssetImage(tBannerImage2))),
//                                   ],
//                                 ),
//                                 Text(tDashboardBannerTitle2, style: Theme.of(context).textTheme.headlineSmall, overflow: TextOverflow.ellipsis),
//                                 Text(tDashboardBannerSubTitle, style: Theme.of(context).textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         SizedBox(
//                           width: double.infinity,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             child: OutlinedButton(onPressed: () {}, child: const Text(tDashboardButton)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Item {
//   final String title;
//   final VoidCallback onPress;

//   const Item({required this.title, required this.onPress});
// }
import 'package:flutter/material.dart';
import 'package:hisani/src/features/authentication/screens/login/login_screen.dart'; // Import your login screen file
import 'package:hisani/src/features/authentication/screens/profile/profile_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);
  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'HISANI',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(width: 16),
          // Navigate to profile on avatar press
          GestureDetector(
            onTap: () {
              _goToProfile(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CharityBanner(
                image: "assets/images/dashboard/dash-1.png",
                name: 'Redcross',
              ),
              CharityBanner(
                image: "assets/images/dashboard/bannerImage2.png",
                name: 'House of Charity',
              ),
              CharityBanner(
                image: "assets/images/dashboard/dash-1.png",
                name: 'Kwetu Boys',
              ),
              // Add more CharityBanner widgets as needed
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class CharityBanner extends StatelessWidget {
  final String image;
  final String name;

  const CharityBanner({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              image,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
