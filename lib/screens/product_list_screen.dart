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
        backgroundColor: Colors.blueGrey.shade200,
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
                : Container(
                    color: Colors.blueGrey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  //will change the aspect ratio to 9/18
                                  childAspectRatio: 9 / 17),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            print(product); // Print the product to the console

                            if (product.photos.isNotEmpty) {
                              final firstPhoto = product.photos[0];
                              final fullImageUrl =
                                  imageBaseUrl + firstPhoto.url!;
                              return Material(
                                elevation: 3,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to product details screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                                product: product),
                                      ),
                                    );
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ), // Only top corners rounde
                                          child: Image.network(
                                            fullImageUrl,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.error);
                                            },
                                            // width: 80, // Adjust image width
                                            // height: 80, // Adjust image height
                                            // fit: BoxFit
                                            //     .fill, // Ensure image covers the space
                                          ),
                                        ),
                                        //   ??
                                        // const Icon(Icons.image_not_supported);
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),

                                          //name of the product
                                          child: Text(
                                            product.name ?? 'No name',
                                            style: TextStyle(
                                              fontSize: 18, // Adjust font size
                                              fontWeight: FontWeight
                                                  .bold, // Make title bold
                                              color: Colors.blueGrey.shade900,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),

                                          //description of the product
                                          child: Text(
                                            product.description ??
                                                'No description',
                                            style:
                                                const TextStyle(fontSize: 16.0),
                                          ),
                                        ),

                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 1,
                                            ), // Add some spacing between title and price

                                            child: Text(
                                              '\$${product.currentPrice[0].amount ?? 0.0}',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors
                                                    .red, // Make price slightly bold
                                              ),
                                            )),
                                        Spacer(),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: IconButton(
                                            onPressed: () {
                                              // Add product to cart
                                            },
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }),
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
    final String imageBaseUrl = 'https://api.timbu.cloud/images/';
    final firstPhoto = product.photos[0];
    final fullImageUrl = imageBaseUrl + firstPhoto.url!;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text("Buy ${product.name}!         ",
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 25,
                  // fontWeight: FontWeight.bold,
                ))),
      ),
      //
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(
                      2,
                      2,
                    ),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                // Match the Container's borderRadius
                child: Image.network(
                  fullImageUrl, // Make sure you have the correct URL here
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit.cover, // Ensure the image fills the space
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //     vertical: 4,
            //   ),

            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width - (130),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
              ), //name of the product
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.name ?? 'No name',
                          style: TextStyle(
                            fontSize: 30, // Adjust font size
                            fontWeight: FontWeight.bold, // Make title bold
                            color: Colors.blueGrey.shade900,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '\$${product.currentPrice[0].amount ?? 0.0}',
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.red, // Make price slightly bold
                          ),
                        )
                      ],
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 12,
                    //     vertical: 4,
                    //   ),

                    SizedBox(
                        height:
                            10), // Add some spacing between title and description
                    //description of the product
                    Text(
                      product.description ?? 'No description',
                      style: const TextStyle(fontSize: 22.0),
                    ),

                    Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade600,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                        ),
                        child: Text(
                          'Buy Now',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    )
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
