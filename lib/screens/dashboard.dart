import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:telemed/screens/documents.dart';
import 'package:telemed/screens/unvalidated_user.dart';
import 'package:telemed/screens/validated_user.dart';
import 'package:telemed/widgets/reusablebutton.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> translateAnimation;
  late Animation<Offset> translatex1Animation;
  late Animation<Offset> translatex2Animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int totalPatients = 0;
  int totalPractitioners = 0;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(vsync: this);
    _fetchDashboardData();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          setState(() {});
        }
      });

    translateAnimation =
        Tween<Offset>(begin: Offset(0, 1.5.h), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );

    translatex1Animation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    translatex2Animation =
        Tween<Offset>(begin: const Offset(1.5, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );

    _controller.forward();
    super.initState();
  }

  Future<void> _fetchDashboardData() async {
    try {
      var apiService = Provider.of<ApiService>(context, listen: false);
      var patientsData = await apiService.getTotalPatients();
      var practitionersData = await apiService.getTotalPractitioners();

      setState(() {
        totalPatients = patientsData ?? 100;
        totalPractitioners = practitionersData ?? 50;
      });
    } catch (e) {
      setState(() {
        totalPatients = 100;
        totalPractitioners = 50;
      });
    }
  }

  final gap = SizedBox(height: 10.h);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SlideTransition(
                    position: translatex1Animation,
                    child: _buildCountCard('Total Patients', totalPatients)),
                SlideTransition(
                    position: translatex2Animation,
                    child: _buildCountCard(
                        'Total Practitioners', totalPractitioners)),
              ],
            ),
            gap,
            SlideTransition(
              position: translateAnimation,
              child: ReusableButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnvalidatedUsersScreen(),
                    ),
                  );
                },
                text: "Unvalidated Users",
              ),
            ),
            gap,
            SlideTransition(
              position: translateAnimation,
              child: ReusableButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ValidatedUsersScreen(),
                    ),
                  );
                },
                text: "Validated Users",
              ),
            ),
            gap,
            SlideTransition(
              position: translateAnimation,
              child: ReusableButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DocumentsScreen(),
                    ),
                  );
                },
                text: "Documents",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountCard(String title, int count) {
    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
            gap,
            Text('$count',
                style: TextStyle(color: Colors.white, fontSize: 32.sp)),
          ],
        ),
      ),
    );
  }
}
