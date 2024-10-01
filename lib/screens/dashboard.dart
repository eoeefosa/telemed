import 'package:flutter/material.dart';
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

class _DashboardScreenState extends State<DashboardScreen> {
  int totalPatients = 0;
  int totalPractitioners = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCountCard('Total Patients', totalPatients),
                _buildCountCard('Total Practitioners', totalPractitioners),
              ],
            ),
            ReusableButton(
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
            const SizedBox(height: 10),
            ReusableButton(
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
            const SizedBox(height: 10),
            ReusableButton(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCountCard(String title, int count) {
    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10),
            Text('$count',
                style: const TextStyle(color: Colors.white, fontSize: 40)),
          ],
        ),
      ),
    );
  }
}
