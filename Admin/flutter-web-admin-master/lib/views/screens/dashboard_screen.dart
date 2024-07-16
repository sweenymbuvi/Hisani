import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/app_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/theme/theme_extensions/app_data_table_theme.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/organisations_widget.dart';
import 'package:web_admin/views/widgets/physical_donations_widget.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dataTableHorizontalScrollController = ScrollController();
final _formKey = GlobalKey<FormBuilderState>();


  int organizationsCount = 0;
  int usersCount = 0;
    int applicationsCount = 0;


   @override
  void initState() {
    super.initState();
    // Fetch counts when the widget initializes
    fetchCounts();
  }
 // Function to fetch counts from Firestore
  void fetchCounts() async {
    // Example query to get counts from Firestore
    final organizationsQuery = await FirebaseFirestore.instance.collection('organizations').get();
    final usersQuery = await FirebaseFirestore.instance.collection('Users').get();
final applicationsQuery = await FirebaseFirestore.instance.collection('Applications').get();
    setState(() {
      organizationsCount = organizationsQuery.docs.length;
      usersCount = usersQuery.docs.length;
       applicationsCount = applicationsQuery.docs.length;
    });
  }
  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.dashboard,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth - (kDefaultPadding * (summaryCardCrossAxisCount - 1))) / summaryCardCrossAxisCount);

                return Wrap(
                  direction: Axis.horizontal,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: [
                    SummaryCard(
                      title: lang.newOrders(2),
                      value:organizationsCount.toString(),
                      
                      icon: Icons.business_rounded,

                      backgroundColor: appColorScheme.info,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: lang.todaySales,
                      value:applicationsCount.toString(),
                      icon: Icons.ssid_chart_rounded,
                      backgroundColor: appColorScheme.success,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: lang.newUsers(2),
                      value:usersCount.toString(),
                      icon: Icons.group_add_rounded,
                      backgroundColor: appColorScheme.warning,
                      textColor: appColorScheme.buttonTextBlack,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      title: lang.pendingIssues(2),
                      value: '0',
                      icon: Icons.report_gmailerrorred_rounded,
                      backgroundColor: appColorScheme.error,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                  ],
                );
              },
            ),
          ),
                   Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CardHeader(
                    title: 'Recent Organizations',
                  ),
                  CardBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: kDefaultPadding * 2.0),
                          child: FormBuilder(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: kDefaultPadding,
                                runSpacing: kDefaultPadding,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 300.0,
                                    // child: Padding(
                                    //   padding: const EdgeInsets.only(right: kDefaultPadding * 1.5),
                                    //   child: FormBuilderTextField(
                                    //     name: 'search',
                                    //     decoration: InputDecoration(
                                    //       labelText: 'Search',
                                    //       hintText: 'Search',
                                    //       border: const OutlineInputBorder(),
                                    //       floatingLabelBehavior: FloatingLabelBehavior.always,
                                    //       isDense: true,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: kDefaultPadding),
                                      //   child: SizedBox(
                                      //     height: 40.0,
                                      //     child: ElevatedButton(
                                      //       style: themeData.extension<AppButtonTheme>()!.infoElevated,
                                      //       onPressed: () {},
                                      //       child: Row(
                                      //         mainAxisSize: MainAxisSize.min,
                                      //         crossAxisAlignment: CrossAxisAlignment.start,
                                      //         children: [
                                      //           Padding(
                                      //             padding: const EdgeInsets.only(right: kDefaultPadding * 0.5),
                                      //             child: Icon(
                                      //               Icons.search,
                                      //               size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
                                      //             ),
                                      //           ),
                                      //           const Text('Search'),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        height: 40.0,
                                        child: ElevatedButton(
                                          style: themeData.extension<AppButtonTheme>()!.successElevated,
                                          onPressed: () => GoRouter.of(context).go(RouteUri.organisations),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: kDefaultPadding * 0.5),
                                                child: Icon(
                                                  Icons.add,
                                                  size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
                                                ),
                                              ),
                                              const Text('New'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        OrganisationsWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120.0,
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: kDefaultPadding * 0.5,
              right: kDefaultPadding * 0.5,
              child: Icon(
                icon,
                size: 80.0,
                color: iconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                    child: Text(
                      value,
                      style: textTheme.headlineMedium!.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: textTheme.labelLarge!.copyWith(
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
