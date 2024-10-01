import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class UnvalidatedUsersScreen extends StatefulWidget {
  const UnvalidatedUsersScreen({super.key});

  @override
  State<UnvalidatedUsersScreen> createState() => _UnvalidatedUsersScreenState();
}

class _UnvalidatedUsersScreenState extends State<UnvalidatedUsersScreen> {
  List<User> unvalidatedUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUnvalidatedUsers();
  }

  Future<void> _fetchUnvalidatedUsers() async {
    var apiService = Provider.of<ApiService>(context, listen: false);
    try {
      var users = await apiService.getUnvalidatedUsers();
      setState(() {
        unvalidatedUsers = users ?? _getDummyUsers();
      });
    } catch (e) {
      setState(() {
        unvalidatedUsers = _getDummyUsers(); 
      });
    }
  }

  List<User> _getDummyUsers() {
    return [
      User(
          id: 2,
          name: 'Jane Doe',
          email: 'jane@example.com',
          role: 'practitioner',
          status: 'unvalidated'),
    ];
  }

  Future<void> _validateUser(int userId) async {
    var apiService = Provider.of<ApiService>(context, listen: false);
    try {
      await apiService.validatePractitioner(userId);
      setState(() {
        unvalidatedUsers = unvalidatedUsers.map((user) {
          if (user.id == userId) {
            return User(
                id: user.id,
                name: user.name,
                email: user.email,
                role: user.role,
                status: 'validated');
          }
          return user;
        }).toList();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unvalidated Users'),
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
          DataColumn(label: Text('Action')),
        ],
        rows: unvalidatedUsers
            .map((user) => DataRow(cells: [
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.role)),
                  DataCell(Text(user.status)),
                  DataCell(
                    ElevatedButton(
                      onPressed: () => _validateUser(user.id),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Validate'),
                    ),
                  ),
                ]))
            .toList(),
      ),
    );
  }
}
