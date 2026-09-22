import 'package:flutter/material.dart';

void main() {
  runApp(const ShoppingCartApp());
}

class ShoppingCartApp extends StatelessWidget {
  const ShoppingCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const ShoppingCartPage(),
    );
  }
}

// 1. Model Data Produk Diperbarui
class Product {
  final String id;
  final String name;
  final String brand;
  final int price;
  final String imageUrl;
  int likes;
  bool isLiked;
  bool isSelected;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl, // Diubah
    required this.likes,
    this.isLiked = false,
    this.isSelected = false,
    this.quantity = 1,
  });
}

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  // 2. Inisialisasi Data Produk dengan URL Gambar
  final List<Product> products = [
    Product(
      id: 'p1',
      name: 'Wireless Headphone',
      brand: 'Sony WH-CH520',
      price: 350000,
      // Menggunakan URL gambar Headphone
      imageUrl: 'https://images.unsplash.com/photo-1520170350707-b2da59970118?q=80&w=765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      likes: 12,
    ),
    Product(
      id: 'p2',
      name: 'Laptop ASUS Vivobook',
      brand: 'ASUS',
      price: 7500000,
      // Menggunakan URL gambar Laptop
      imageUrl: 'https://images.unsplash.com/photo-1597672996375-4d21cad0cbb9?q=80&w=1629&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      likes: 8,
    ),
    Product(
      id: 'p3',
      name: 'Wireless Mouse',
      brand: 'Logitech M330',
      price: 250000,
      // Menggunakan URL gambar Mouse
      imageUrl: 'https://images.unsplash.com/photo-1629121291243-7b5e885cce9b?q=80&w=764&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      likes: 5,
    ),
  ];

  String? selectedProductName;
  bool showTopBanner = false;

  String formatRupiah(int number) {
    String numberString = number.toString();
    String formatted = '';
    int count = 0;
    for (int i = numberString.length - 1; i >= 0; i--) {
      formatted = numberString[i] + formatted;
      count++;
      if (count % 3 == 0 && i != 0) {
        formatted = '.$formatted';
      }
    }
    return 'Rp $formatted';
  }

  int get totalPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int get totalItems {
    return products.fold(0, (sum, item) => sum + item.quantity);
  }

  void _handleLongPress(String productName) {
    setState(() {
      selectedProductName = productName;
      showTopBanner = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showTopBanner = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0,
        leading: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Belanja lebih mudah setiap hari', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          for (var p in products) {
                            p.isSelected = false;
                          }
                          product.isSelected = true;
                        });
                      },
                      onDoubleTap: () {
                        setState(() {
                          if (!product.isLiked) {
                            product.likes += 1;
                            product.isLiked = true;
                          } else {
                            product.likes -= 1;
                            product.isLiked = false;
                          }
                        });
                      },
                      onLongPress: () => _handleLongPress(product.name),

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: product.isSelected ? Colors.blue : Colors.transparent,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 3. Menggunakan Image.network dengan ClipRRect
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Agar gambar mengikuti sudut membulat
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Munculkan ikon ini jika URL rusak atau gagal dimuat
                                    return Icon(Icons.image_not_supported, color: Colors.grey[400]);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    product.brand,
                                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    formatRupiah(product.price),
                                    style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            product.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: product.isLiked ? Colors.red : Colors.grey[400],
                                            size: 18,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${product.likes}',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (product.quantity > 1) {
                                                    product.quantity--;
                                                  }
                                                });
                                              },
                                              child: Icon(Icons.remove, size: 16, color: product.quantity > 1 ? Colors.blue[700] : Colors.blue[300]),
                                            ),
                                            const SizedBox(width: 12),
                                            Text('${product.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                            const SizedBox(width: 12),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  product.quantity++;
                                                });
                                              },
                                              child: Icon(Icons.add, size: 16, color: Colors.blue[700]),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total ($totalItems produk)',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatRupiah(totalPrice),
                          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),

          if (showTopBanner && selectedProductName != null)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D3748),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Produk dipilih!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('$selectedProductName telah dipilih.', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => showTopBanner = false),
                        child: const Icon(Icons.close, color: Colors.white54, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          const BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Kategori'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('$totalItems', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}