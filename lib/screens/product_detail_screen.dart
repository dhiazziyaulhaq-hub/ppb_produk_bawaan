
import 'package:flutter/material.dart';
import '../models/product_model.dart';

// Class untuk menampilkan halaman detail produk
class ProductDetailScreen extends StatelessWidget {
  final ProductModel product; // Menyimpan data produk yang dipilih

  const ProductDetailScreen({
    super.key,
    required this.product, // Menerima data produk dari halaman utama
  });

  // Mengatur tampilan halaman detail produk
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sebagai judul halaman detail
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: const Color(0xFF65351F),
        foregroundColor: Colors.white,
      ),

      // SingleChildScrollView agar halaman bisa digulir
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan gambar produk dari API
            Center(
              child: Image.network(
                product.thumbnail,
                height: 220,
                width: double.infinity,
                fit: BoxFit.contain,

                // Menampilkan ikon jika gambar gagal dimuat
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 220,
                    child: Icon(
                      Icons.shopping_bag,
                      size: 100,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Menampilkan nama produk
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Menampilkan harga produk dalam format dua angka desimal
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Menampilkan kategori produk
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.category,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Menampilkan rating produk
            const Text(
              'Rating Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                const SizedBox(width: 6),
                Text(
                  product.rating.toString(), // Mengubah rating menjadi teks
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Menampilkan deskripsi produk
            const Text(
              'Deskripsi Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
