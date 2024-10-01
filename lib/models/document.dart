class Document {
  final int practitionerId;
  final String documentName;
  final DateTime uploadedAt;
  final String status;

  Document({
    required this.practitionerId,
    required this.documentName,
    required this.uploadedAt,
    required this.status,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      practitionerId: json['practitionerId'],
      documentName: json['documentName'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      status: json['status'],
    );
  }
}
