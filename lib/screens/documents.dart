import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/document.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<Document> documents = [];

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
  }

  Future<void> _fetchDocuments() async {
    var apiService = Provider.of<ApiService>(context, listen: false);
    try {
      var docs = await apiService.getPractitionerDocuments();
      setState(() {
        documents = docs ?? _getDummyDocuments();
      });
    } catch (e) {
      setState(() {
        documents = _getDummyDocuments(); 
      });
    }
  }

  List<Document> _getDummyDocuments() {
    return [
      Document(
        practitionerId: 1,
        documentName: 'MedicalLicense.pdf',
        uploadedAt: DateTime.parse('2024-09-30T12:00:00Z'),
        status: 'pending',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Documents'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: _buildDocumentTable(),
    );
  }

  Widget _buildDocumentTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Document Name')),
          DataColumn(label: Text('Upload Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Action')),
        ],
        rows: documents
            .map((document) => DataRow(cells: [
                  DataCell(Text(document.documentName)),
                  DataCell(Text(document.uploadedAt.toString())),
                  DataCell(Text(document.status)),
                  DataCell(
                    ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: const Text('Download'),
                    ),
                  ),
                ]))
            .toList(),
      ),
    );
  }
}
