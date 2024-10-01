import 'package:flutter/material.dart';
import '../models/document.dart';

class DocumentList extends StatelessWidget {
  final List<Document> documents;
  final Function(Document) onDownload;

  const DocumentList(
      {super.key, required this.documents, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('Document Name')),
        DataColumn(label: Text('Upload Date')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Action')),
      ],
      rows: documents
          .map(
            (document) => DataRow(cells: [
              DataCell(Text(document.documentName)),
              DataCell(Text(document.uploadedAt.toLocal().toString())),
              DataCell(Text(document.status)),
              DataCell(
                ElevatedButton(
                  onPressed: () {
                    onDownload(document);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Download'),
                ),
              ),
            ]),
          )
          .toList(),
    );
  }
}
