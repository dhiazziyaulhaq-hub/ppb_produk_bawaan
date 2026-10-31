
import 'package:flutter/material.dart';
import 'models/product_model.dart';
import 'services/api_service_products.dart';
import 'screens/product_detail_screen.dart';

// Fungsi utama untuk menjalankan aplikasi Flutter
void main() {
  runApp(const MyApp());
}

// Konstanta warna yang digunakan pada tampilan aplikasi
const Color cream = Color(0xFFFAF5EF);
const Color coffeeBrown = Color(0xFF65351F);
const Color softBrown = Color(0xFFEDE1D5);

// Class utama untuk mengatur tema dan halaman awal aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      title: 'Katalog Produk',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: coffeeBrown),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: coffeeBrown,
        ),
      ),
      home: const ProductPage(), // Menampilkan halaman utama
    );
  }
}

// Halaman utama menggunakan StatefulWidget karena tampilannya berubah
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

// Class untuk mengatur proses dan tampilan halaman produk
class _ProductPageState extends State<ProductPage> {
  final ApiServiceProducts apiService = ApiServiceProducts(); // Menghubungkan layanan API
  final TextEditingController searchController = TextEditingController(); // Mengontrol input pencarian

  late Future<List<ProductModel>> futureProducts; // Menampung data produk dari API
  late Future<List<String>> futureCategories; // Menampung data kategori dari API

  String selectedCategory = 'all'; // Kategori yang sedang dipilih
  String selectedSort = 'default'; // Metode pengurutan produk

  // Mengambil data produk dan kategori saat halaman pertama dibuka
  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
    futureCategories = apiService.getCategories();
  }

  // Mengambil produk berdasarkan pencarian atau kategori
  Future<List<ProductModel>> loadProducts() {
    final query = searchController.text.trim();

    if (query.isNotEmpty) {
      return apiService.searchProducts(query);
    }

    if (selectedCategory != 'all') {
      return apiService.getProductsByCategory(selectedCategory);
    }

    return apiService.getProducts();
  }

  // Memperbarui daftar produk setelah terjadi perubahan
  void updateProducts() {
    setState(() {
      futureProducts = loadProducts();
    });
  }

  // Memilih kategori dan menghapus kata pencarian
  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      searchController.clear();
      futureProducts = loadProducts();
    });
  }

  // Menampilkan pilihan pengurutan produk
  void showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: cream,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Urutkan Produk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: coffeeBrown,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Nama produk A–Z'),
                  onTap: () {
                    setState(() => selectedSort = 'name');
                    Navigator.pop(context); // Menutup menu pengurutan
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Harga terendah'),
                  onTap: () {
                    setState(() => selectedSort = 'priceAsc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Harga tertinggi'),
                  onTap: () {
                    setState(() => selectedSort = 'priceDesc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Urutan awal'),
                  onTap: () {
                    setState(() => selectedSort = 'default');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Menentukan ikon berdasarkan nama kategori
  IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'all':
        return Icons.grid_view_rounded;
      case 'beauty':
        return Icons.face_retouching_natural;
      case 'fragrances':
        return Icons.spa_outlined;
      case 'furniture':
        return Icons.chair_outlined;
      case 'groceries':
        return Icons.local_grocery_store_outlined;
      case 'laptops':
        return Icons.laptop_mac;
      case 'mens-shirts':
      case 'mens-shoes':
      case 'mens-watches':
        return Icons.checkroom_outlined;
      case 'womens-bags':
      case 'womens-dresses':
      case 'womens-jewellery':
      case 'womens-shoes':
      case 'womens-watches':
        return Icons.shopping_bag_outlined;
      case 'smartphones':
        return Icons.phone_iphone;
      case 'tablets':
        return Icons.tablet_mac;
      case 'vehicle':
      case 'motorcycle':
        return Icons.directions_car_outlined;
      case 'home-decoration':
        return Icons.weekend_outlined;
      case 'kitchen-accessories':
        return Icons.kitchen_outlined;
      case 'sports-accessories':
        return Icons.sports_basketball_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  // Mengubah nama kategori menjadi format yang mudah dibaca
  String categoryName(String category) {
    if (category == 'all') return 'Semua';

    return category
        .split('-')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  // Membersihkan controller ketika halaman tidak digunakan
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Mengatur seluruh komponen tampilan halaman utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header: nama aplikasi berada di tengah
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Katalog Produk'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu_rounded),
                    color: coffeeBrown,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.shopping_bag_outlined,
                          size: 25,
                          color: coffeeBrown,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Katalog Produk',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            color: coffeeBrown,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 85,
                          height: 2,
                          color: const Color(0xFFB99A7B),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: updateProducts,
                    icon: const Icon(Icons.refresh_rounded),
                    color: coffeeBrown,
                    tooltip: 'Muat ulang',
                  ),
                ],
              ),
            ),

            // Search bar untuk mencari produk berdasarkan nama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: softBrown),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (_) => updateProducts(), // Mencari ulang saat teks berubah
                        decoration: InputDecoration(
                          hintText: 'Cari produk...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: coffeeBrown,
                          ),
                          suffixIcon: searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    updateProducts();
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: softBrown),
                    ),
                    child: IconButton(
                      onPressed: showSortOptions,
                      icon: const Icon(Icons.tune_rounded),
                      color: coffeeBrown,
                      tooltip: 'Urutkan produk',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Judul kategori
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Kategori',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: coffeeBrown,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Menampilkan kategori yang diperoleh dari API
            SizedBox(
              height: 100,
              child: FutureBuilder<List<String>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Gagal memuat kategori'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: coffeeBrown),
                    );
                  }

                  // Menggabungkan kategori Semua dengan kategori dari API
                  final categories = ['all', ...snapshot.data!];

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final selected = selectedCategory == category;

                      return GestureDetector(
                        onTap: () => selectCategory(category), // Memilih kategori
                        child: SizedBox(
                          width: 64,
                          child: Column(
                            children: [
                              // Animasi dan warna ikon kategori terpilih
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: selected ? coffeeBrown : Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected ? coffeeBrown : softBrown,
                                  ),
                                  boxShadow: selected
                                      ? [
                                          BoxShadow(
                                            color: coffeeBrown.withValues(alpha: 0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  categoryIcon(category),
                                  color: selected ? Colors.white : coffeeBrown,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                categoryName(category),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selected ? coffeeBrown : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Judul bagian daftar produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Produk Pilihan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: coffeeBrown,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => selectCategory('all'),
                    icon: const Icon(Icons.arrow_forward, size: 15),
                    label: const Text('Semua'),
                    style: TextButton.styleFrom(
                      foregroundColor: coffeeBrown,
                    ),
                  ),
                ],
              ),
            ),

            // Mengambil dan menampilkan daftar produk dari API
            Expanded(
              child: FutureBuilder<List<ProductModel>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  // Menampilkan loading selama data sedang diambil
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: coffeeBrown),
                    );
                  }

                  // Menampilkan pesan jika pengambilan data gagal
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_outlined,
                            size: 48,
                            color: coffeeBrown,
                          ),
                          const SizedBox(height: 8),
                          const Text('Gagal memuat produk'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: updateProducts,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Membuat salinan data produk agar dapat diurutkan
                  final products = List<ProductModel>.from(snapshot.data ?? []);

                  // Mengurutkan produk berdasarkan nama atau harga
                  if (selectedSort == 'name') {
                    products.sort((a, b) => a.title.compareTo(b.title));
                  } else if (selectedSort == 'priceAsc') {
                    products.sort((a, b) => a.price.compareTo(b.price));
                  } else if (selectedSort == 'priceDesc') {
                    products.sort((a, b) => b.price.compareTo(a.price));
                  }

                  // Menampilkan pesan jika tidak ada produk
                  if (products.isEmpty) {
                    return const Center(
                      child: Text('Produk tidak ditemukan'),
                    );
                  }

                  // Menampilkan produk dalam bentuk grid dua kolom
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.67,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index]; // Mengambil produk sesuai indeks

                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          // Membuka halaman detail ketika produk ditekan
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(
                                  product: product,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Menampilkan gambar produk dari URL
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  color: const Color(0xFFF0E9E1),
                                  padding: const EdgeInsets.all(8),
                                  child: Image.network(
                                    product.thumbnail,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 55,
                                        color: coffeeBrown,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              // Menampilkan nama, rating, dan harga produk
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFE5A13A),
                                          size: 15,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          product.rating.toString(),
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: coffeeBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
