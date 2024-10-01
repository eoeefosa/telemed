import 'package:flutter/material.dart';
import '../models/user.dart';

class UserListTable extends StatelessWidget {
  final List<User> users;
  final bool showValidateButton;
  final Function(User)? onValidate;

  const UserListTable({
    super.key,
    required this.users,
    this.showValidateButton = false,
    this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Role')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Action')),
      ],
      rows: users.map((user) {
        return DataRow(cells: [
          DataCell(Text(user.name)),
          DataCell(Text(user.email)),
          DataCell(Text(user.role)),
          DataCell(Text(user.status)),
          DataCell(
            showValidateButton && user.status == 'unvalidated'
                ? ElevatedButton(
                    onPressed: () => onValidate?.call(user),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Validate'),
                  )
                : const SizedBox.shrink(),
          ),
        ]);
      }).toList(),
    );
  }
}
