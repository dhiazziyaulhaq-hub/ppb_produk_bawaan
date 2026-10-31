import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://dummyjson.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // 1. Mengambil semua produk dengan limit dan skip
  Future<List<ProductModel>> getProducts({
    int limit = 10,
    int skip = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      final List products = response.data['products'];

      return products
          .map(
            (product) => ProductModel.fromJson(
              Map<String, dynamic>.from(product),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  // 2. Mengambil satu produk berdasarkan ID
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');

      return ProductModel.fromJson(
        Map<String, dynamic>.from(response.data),
      );
    } catch (e) {
      throw Exception('Gagal mengambil detail produk: $e');
    }
  }

  // 3. Mencari produk berdasarkan kata kunci
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {'q': query},
      );

      final List products = response.data['products'];

      return products
          .map(
            (product) => ProductModel.fromJson(
              Map<String, dynamic>.from(product),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari produk: $e');
    }
  }

  // 4. Mengambil daftar kategori
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      final List categories = response.data;

      return categories.map<String>((category) {
        if (category is Map) {
          return category['slug'].toString();
        }
        return category.toString();
      }).toList();
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  // 5. Mengambil daftar kategori dalam bentuk slug
  Future<List<String>> getCategoryList() async {
    try {
      final response = await _dio.get('/products/category-list');
      final List categories = response.data;

      return categories.map((category) => category.toString()).toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar kategori: $e');
    }
  }

  // 6. Mengambil produk berdasarkan kategori
  Future<List<ProductModel>> getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await _dio.get(
        '/products/category/${Uri.encodeComponent(category)}',
      );

      final List products = response.data['products'];

      return products
          .map(
            (product) => ProductModel.fromJson(
              Map<String, dynamic>.from(product),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil produk kategori: $e');
    }
  }

  // 7. Mengambil produk dengan pilihan field
  Future<List<ProductModel>> getProductsWithOptions({
    int limit = 10,
    int skip = 0,
    List<String> selectFields = const [
      'id',
      'title',
      'description',
      'category',
      'price',
      'thumbnail',
      'rating',
    ],
    String? sortBy,
    String order = 'asc',
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'limit': limit,
        'skip': skip,
        'select': selectFields.join(','),
      };

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParameters['sortBy'] = sortBy;
        queryParameters['order'] = order;
      }

      final response = await _dio.get(
        '/products',
        queryParameters: queryParameters,
      );

      final List products = response.data['products'];

      return products
          .map(
            (product) => ProductModel.fromJson(
              Map<String, dynamic>.from(product),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil produk: $e');
    }
  }
}