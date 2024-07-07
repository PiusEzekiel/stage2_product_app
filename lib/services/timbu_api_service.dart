import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:stage2_product_app/models/product.dart';

import 'dart:convert';

class TimbuApiService {
  final String _apiKey = dotenv.env['Api_Key']!;
  // final String _apiKey = 'cdea3e60c982437ca0bf3e254d7e39d620240706132400564359';
  final String _appId = '0V43DCDJIRHEQH3';
  final String _baseUrl = dotenv.env['Base_Url']!;
  // final String _baseUrl = 'https://api.timbu.cloud';

  Future<List<Product>> fetchProducts({
    required String organizationId,
    String? supplierId,
    String? categoryId,
    String? searchValue,
    String? sortingKey,
    DateTime? startDt,
    DateTime? endDt,
    int page = 1,
    int size = 50,
    String? currencyCode,
    bool reverseSort = true,
  }) async {
    final uri = Uri.parse('$_baseUrl/products').replace(queryParameters: {
      'organization_id': organizationId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (categoryId != null) 'category_id': categoryId,
      if (searchValue != null) 'search_value': searchValue,
      if (sortingKey != null) 'sorting_key': sortingKey,
      if (startDt != null)
        'start_dt': startDt.toIso8601String().substring(0, 19),
      if (endDt != null) 'end_dt': endDt.toIso8601String().substring(0, 19),
      'page': page.toString(),
      'size': size.toString(),
      if (currencyCode != null) 'currency_code': currencyCode,
      'reverse_sort': reverseSort.toString(),
      'Appid': _appId,
      'Apikey': _apiKey,
      // Add 'fields' parameter to specify the required fields
      'fields':
          'id,name,description,unique_id,url_slug,is_available,is_service,photos,current_price,is_deleted' // Example - adjust based on your Product model
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;
      final products =
          items.map((product) => Product.fromJson(product)).toList();
      print('Fetched Products: $products'); // Print the fetched products
      return products;
    } else {
      print('Error fetching products: ${response.statusCode}');
      print(response.body); // Print the response body for additional debugging
      throw Exception('Failed to load products: ${response.statusCode}');
    }
  }
}
