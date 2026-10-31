
 // Class untuk menampung data produk dari API
class ProductModel {
  final int id; // ID unik produk
  final String title; // Nama produk
  final String description; // Deskripsi produk
  final String category; // Kategori produk
  final double price; // Harga produk
  final String thumbnail; // URL gambar produk
  final double rating; // Rating produk

  // Constructor untuk mengisi seluruh data produk
  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.rating,
  });

  // Factory untuk mengubah data JSON dari API menjadi objek ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0, // Mengambil ID, default 0 jika kosong
      title: json['title'] ?? '', // Mengambil nama produk
      description: json['description'] ?? '', // Mengambil deskripsi
      category: json['category'] ?? '', // Mengambil kategori
      price: (json['price'] as num? ?? 0).toDouble(), // Mengubah harga menjadi double
      thumbnail: json['thumbnail'] ?? '', // Mengambil URL gambar
      rating: (json['rating'] as num? ?? 0).toDouble(), // Mengubah rating menjadi double
    );
  }
}
