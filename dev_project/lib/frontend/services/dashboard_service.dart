import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/dashboard_model.dart';

class DashboardService {
  const DashboardService();

  Future<DashboardModel> fetchDashboard() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/dashboard'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load dashboard');
    }

    return DashboardModel.fromJson(json.decode(response.body) as Map<String, dynamic>);
  }
}
