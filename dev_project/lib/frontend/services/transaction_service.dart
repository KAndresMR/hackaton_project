import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/transaction_model.dart';

class TransactionService {
  const TransactionService();

  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/transactions'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load transactions');
    }

    final data = json.decode(response.body) as List<dynamic>;
    return data
        .map((item) => TransactionModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
