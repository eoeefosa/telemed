import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/document.dart';

class ApiService {
  static const String baseUrl = '';

  Future<int?> getTotalPatients() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/api/admin/patients/count'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['totalPatients'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> getTotalPractitioners() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/api/admin/practitioners/count'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['totalPractitioners'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> getValidatedUsers() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/api/admin/users/validated'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<User>?> getUnvalidatedUsers() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/api/admin/users/unvalidated'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Document>?> getPractitionerDocuments() async {
    try {
      var response = await http
          .get(Uri.parse('$baseUrl/api/admin/practitioners/documents'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Document.fromJson(json)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> validatePractitioner(int practitionerId) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/api/admin/practitioners/validate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'practitionerId': practitionerId}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
