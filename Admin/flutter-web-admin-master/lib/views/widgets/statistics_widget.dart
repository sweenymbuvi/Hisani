import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsWidget extends StatefulWidget {
  const StatisticsWidget({super.key});

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> {
  Map<String, int> applicationCounts = {};
  Map<String, int> cashDonationsPerMonth = {};
  Map<String, int> physicalDonationsPerMonth = {};
  
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchApplicationCounts();
    fetchCashDonations();
    fetchPhysicalDonations();
  }

  Future<void> fetchApplicationCounts() async {
    final applicationsQuery = await FirebaseFirestore.instance.collection('Applications').get();
    final Map<String, int> counts = {};

    for (var doc in applicationsQuery.docs) {
      final timestamp = doc['submittedAt'] as Timestamp;
      final date = timestamp.toDate();
      final month = DateFormat.MMM().format(date);

      if (counts.containsKey(month)) {
        counts[month] = counts[month]! + 1;
      } else {
        counts[month] = 1;
      }
    }

    setState(() {
      applicationCounts = counts;
    });
  }

  Future<void> fetchCashDonations() async {
    final cashDonationsQuery = await FirebaseFirestore.instance.collection('donations').get();
    final Map<String, int> counts = {};

    for (var doc in cashDonationsQuery.docs) {
      final status = doc['status'];
      if (status == 'Approved') {
        final timestamp = doc['timestamp'] as Timestamp;
        final date = timestamp.toDate();
        final month = DateFormat.MMM().format(date);

        if (counts.containsKey(month)) {
          counts[month] = counts[month]! + 1;
        } else {
          counts[month] = 1;
        }
      }
    }
 print('Cash Donations per Month: $counts');
    setState(() {
      cashDonationsPerMonth = counts;
    });
  }

  Future<void> fetchPhysicalDonations() async {
    final physicalDonationsQuery = await FirebaseFirestore.instance.collection('PhysicalDonations').get();
    final Map<String, int> counts = {};

    for (var doc in physicalDonationsQuery.docs) {
      final timestamp = doc['timestamp'] as Timestamp;
      final date = timestamp.toDate();
      final month = DateFormat.MMM().format(date);

      if (counts.containsKey(month)) {
        counts[month] = counts[month]! + 1;
      } else {
        counts[month] = 1;
      }
    }
print('Physical Donations per Month: $counts');
    setState(() {
      physicalDonationsPerMonth = counts;
    });
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    String text = '';

    if (value.toInt() >= 0 && value.toInt() < months.length) {
      text = months[value.toInt()];
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.black, fontSize: 10);
    return Text(
      value.toInt().toString(),
      style: style,
      textAlign: TextAlign.center,
    );
  }

  BarChartGroupData generateGroup(int x, double value) {
    final isTouched = touchedIndex == x;
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: value,
          color: Colors.blue,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget buildBarChart(String title, Map<String, int> data) {
    List<BarChartGroupData> barGroups = [];
     const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
     double maxY = 0;
      for (int i = 0; i < months.length; i++) {
      final month = months[i];
      final value = data[month] ?? 0;
      if (value > maxY) {
        maxY = value.toDouble();
      }
      barGroups.add(generateGroup(i, value.toDouble()));
    }

    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 300,
          child: Container (
 color: Color.fromARGB(243, 255, 113, 52),  
          child:   BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: maxY + 5, 
              minY: 0,
              groupsSpace: 12,
              barTouchData: BarTouchData(
                handleBuiltInTouches: false,
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                    setState(() {
                      touchedIndex = -1;
                    });
                    return;
                  }
                  setState(() {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, getTitlesWidget: leftTitles, interval: 1, reservedSize: 42),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: bottomTitles),
                ),
              ),
              gridData: FlGridData(
                show: true,
                checkToShowHorizontalLine: (value) => value % 5 == 0,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return FlLine(color: Colors.orange.withOpacity(0.1), strokeWidth: 3);
                  }
                  return FlLine(color: Colors.orange.withOpacity(0.05), strokeWidth: 0.8);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: barGroups,
            ),
          ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return applicationCounts.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Number of Volunteer Applications per Month',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 400,
                  child: PieChart(
                    PieChartData(
                      sections: applicationCounts.entries.map((entry) {
                        return PieChartSectionData(
                          value: entry.value.toDouble(),
                          title: '${entry.key}: ${entry.value}',
                          color: Colors.primaries[applicationCounts.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildBarChart('Cash Donations per Month', cashDonationsPerMonth),
                const SizedBox(height: 20),
                buildBarChart('Physical Donations per Month', physicalDonationsPerMonth),
              ],
            ),
          );
  }
}
