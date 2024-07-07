import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stage2_product_app/models/product.dart';
import 'package:stage2_product_app/services/timbu_api_service.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TimbuApiService _apiService = TimbuApiService();
  List<Product> products = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String? organizationId; // Replace with your organization ID
  final String imageBaseUrl = 'https://api.timbu.cloud/images/';

  @override
  void initState() {
    super.initState();
    organizationId = '2d75e315be3449b582428837ea8e9e1b';
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });
    try {
      if (organizationId != null) {
        products =
            await _apiService.fetchProducts(organizationId: organizationId!);
        setState(() {
          isLoading = false;
        });
      } else {
        // Handle the case where organizationId is null
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Invalid organization ID';
        });
      }
    } catch (error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Failed to load products. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Timbu Products',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.blueGrey.shade600,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchProducts,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(errorMessage),
                        ElevatedButton(
                          onPressed: _fetchProducts,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        print(product); // Print the product to the console

                        if (product.photos.isNotEmpty) {
                          final firstPhoto = product.photos[0];
                          final fullImageUrl = imageBaseUrl + firstPhoto.url!;
                          return ListTile(
                            minTileHeight: product.photos.isNotEmpty
                                ? 100
                                : 100, // Adjust tile height based on photo size
                            leading: product.photos.isNotEmpty
                                ? Hero(
                                    tag: product
                                        .id!, // Use product ID for hero tag
                                    child: Image.network(
                                      fullImageUrl,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                      width: 80, // Adjust image width
                                      height: 80, // Adjust image height
                                      fit: BoxFit
                                          .fill, // Ensure image covers the space
                                    ),
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(
                              product.name ?? 'No name',
                              style: TextStyle(
                                fontSize: 18, // Adjust font size
                                fontWeight: FontWeight.bold, // Make title bold
                                color: Colors.blueGrey.shade900,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.description ?? 'No description',
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                const SizedBox(
                                    height:
                                        4), // Add some spacing between title and price
                                product.currentPrice.isNotEmpty
                                    ? Text(
                                        'Price: \$${product.currentPrice[0].amount ?? 0.0}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors
                                              .red, // Make price slightly bold
                                        ),
                                      )
                                    : const Text(
                                        'Price: Not Available',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors
                                              .grey, // Make unavailable price grey
                                        ),
                                      ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to product details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsScreen(product: product),
                                ),
                              );
                            },
                          );
                        } else {
                          return const ListTile(
                            title: Text('No image'),
                          );
                        }
                      },
                    ),
                  ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product images using a GridView or a similar widget
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: product.photos.length,
              itemBuilder: (context, index) {
                final String imageBaseUrl = 'https://api.timbu.cloud/images/';
                final firstPhoto = product.photos[0];
                final fullImageUrl = imageBaseUrl + firstPhoto.url!;
                return Image.network(
                      fullImageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      width: 80, // Adjust image width
                      height: 80, // Adjust image height
                      fit: BoxFit.fill, // Ensure image covers the space
                    ) ??
                    const Icon(Icons.image_not_supported)!;
              },
            ),
            const SizedBox(height: 16.0),
            Text(
              product.description ?? 'No description',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            product.currentPrice.isNotEmpty
                ? Text(
                    'Price: \$${product.currentPrice[0].amount ?? 0.0}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.red, // Make price slightly bold
                    ),
                  )
                : const Text(
                    'Price: Not Available',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey, // Make unavailable price grey
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
