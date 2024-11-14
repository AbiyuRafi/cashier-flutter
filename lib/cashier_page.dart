import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'package:intl/intl.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> products = [
    {
      'image': 'assets/images/2.jpg',
      'name': 'MacBook Air M2',
      'price': 17000000,
      'stock': 10,
      'quantity': 0,
    },
    {
      'image': 'assets/images/1.jpeg',
      'name': 'Ultra Milk',
      'price': 12000,
      'stock': 8,
      'quantity': 0,
    },
    {
      'image': 'assets/images/3.jpg',
      'name': 'Nescafe',
      'price': 30000,
      'stock': 5,
      'quantity': 0,
    },
    {
      'image': 'assets/images/chitato.jpg',
      'name': 'Chitato',
      'price': 25000,
      'stock': 4,
      'quantity': 0,
    },
    {
      'image': 'assets/images/eskrim.jpg',
      'name': 'Es Krim',
      'price': 5000,
      'stock': 20,
      'quantity': 0,
    },
  ];

String formatPrice(int price) {
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'id_ID');
    String formattedPrice = formatCurrency.format (price);

    if (formattedPrice.endsWith(',00')) {
      formattedPrice = formattedPrice.substring(0, formattedPrice.length - 3);
    }

    return formattedPrice;
  }
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);

    searchController.addListener(() {
      filterProducts();
    });
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  void updateCart(Map<String, dynamic> product, bool isAdding) {
    setState(() {
      if (isAdding) {
        if (product['stock'] > 0) {
          product['quantity']++;
          product['stock']--;
          if (!selectedItems.contains(product)) {
            selectedItems.add(product);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${product['name']} stok habis')),
          );
        }
      } else {
        if (product['quantity'] > 0) {
          product['quantity']--;
          product['stock']++;
          if (product['quantity'] == 0) {
            selectedItems.remove(product);
          }
        }
      }
    });
  }

  void showNoItemsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Keranjang Kosong"),
          content: const Text("Silakan pilih produk untuk checkout."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Reset cashier page function
  void resetPage() {
    setState(() {
      selectedItems.clear();
      products.forEach((product) {
        product['quantity'] = 0;
        product['stock'] = 10; // Reset the stock to the original value or max
      });
      searchController.clear(); // Reset the search field
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItems =
        selectedItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
    int totalPrice = selectedItems.fold(
      0,
      (sum, item) => sum + ((item['quantity'] as int) * (item['price'] as int)),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Cashier App",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  "Semoga harimu menyenangkan :)",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Cari Produk',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Positioned(
            top: 210,
            left: 20,
            right: 20,
            bottom: 70,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = filteredProducts[index];
                return Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          image: DecorationImage(
                            image: AssetImage(product['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Stok: ${product['stock']}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              " ${formatPrice(product['price'])}", // Use formatPrice for product price
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => updateCart(product, false),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  child: const Icon(Icons.remove,
                                      color: Colors.black, size: 18),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    vertical:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                ),
                                child: Text(
                                  '${product['quantity']}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => updateCart(product, true),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  child: const Icon(Icons.add,
                                      color: Colors.black, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (selectedItems.isEmpty) {
                      showNoItemsDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            selectedItems: selectedItems,
                            totalPrice: totalPrice,
                            resetCashierPage: resetPage,
                          ),
                        ),
                      );

                    }
                  },
                  label: Text(
                    'Total Items: $totalItems = ${formatPrice(totalPrice)}', // Format total price here
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
