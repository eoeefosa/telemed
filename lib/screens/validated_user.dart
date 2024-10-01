import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class ValidatedUsersScreen extends StatefulWidget {
  const ValidatedUsersScreen({super.key});

  @override
  _ValidatedUsersScreenState createState() => _ValidatedUsersScreenState();
}

class _ValidatedUsersScreenState extends State<ValidatedUsersScreen> {
  List<User> validatedUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchValidatedUsers();
  }

  Future<void> _fetchValidatedUsers() async {
    var apiService = Provider.of<ApiService>(context, listen: false);
    try {
      var users = await apiService.getValidatedUsers();
      setState(() {
        validatedUsers = users ?? _getDummyUsers();
      });
    } catch (e) {
      setState(() {
        validatedUsers = _getDummyUsers(); // Use dummy data
      });
    }
  }

  List<User> _getDummyUsers() {
    return [
      User(
          id: 1,
          name: 'John Doe',
          email: 'john@example.com',
          role: 'patient',
          status: 'validated'),
      User(
          id: 3,
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          role: 'practitioner',
          status: 'validated'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validated Users'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: _buildUserTable(),
    );
  }

  Widget _buildUserTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Status')),
        ],
        rows: validatedUsers
            .map((user) => DataRow(cells: [
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.role)),
                  DataCell(Text(user.status)),
                ]))
            .toList(),
      ),
    );
  }
}
