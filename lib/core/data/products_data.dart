
class Product {
  final String id;
  final String name;
  final String price; // Keeping as String to match existing UI, or could parse to double
  final String imageUrl;
  final String category;
  final String description;
  final List<String> colors;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.description = 'Built for life and made to last, this product is crafted with premium materials to ensure comfort and durability.',
    this.colors = const ['Orange', 'Black', 'Red', 'Yellow', 'Blue'],
  });
}

class ProductsData {
  static const List<Product> allProducts = [
    // Hoodies / Sudaderas
    Product(
      id: 'h1',
      name: 'Mohair Blouse',
      price: '\$24.55',
      imageUrl: 'assets/images/products/hoodies/mohair_blouse.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h2',
      name: 'Original Premium T-Shirt',
      price: '\$34.99',
      imageUrl: 'assets/images/products/hoodies/carl_max_cardigan.jpg',
      category: 'Sudaderas',
      description: 'Experience the ultimate comfort with our Original Premium T-Shirt. Crafted from the finest materials, this piece features a timeless design that blends sophistication with casual style. A must-have for the modern wardrobe.',
      colors: ['Cream'],
    ),
    Product(
      id: 'h3',
      name: 'Cotton T-Shirt',
      price: '\$19.99',
      imageUrl: 'assets/images/products/hoodies/cotton_tshirt.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h4',
      name: 'Denim Jacket',
      price: '\$89.99',
      imageUrl: 'assets/images/products/hoodies/denim_jacket.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h5',
      name: 'Pullover Hoodie',
      price: '\$45.99',
      imageUrl: 'assets/images/products/hoodies/pullover_hoodie.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h6',
      name: 'Zip Hoodie',
      price: '\$52.99',
      imageUrl: 'assets/images/products/hoodies/zip_hoodie.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h7',
      name: 'Fleece Hoodie',
      price: '\$38.99',
      imageUrl: 'assets/images/products/hoodies/fleece_hoodie.jpg',
      category: 'Sudaderas',
    ),
    Product(
      id: 'h8',
      name: 'Graphic Hoodie',
      price: '\$41.99',
      imageUrl: 'assets/images/products/hoodies/graphic_hoodie.jpg',
      category: 'Sudaderas',
    ),

    // Shorts
    Product(
      id: 's1',
      name: 'Classic Shorts',
      price: '\$29.99',
      imageUrl: 'assets/images/products/shorts/classic_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's2',
      name: 'Cargo Shorts',
      price: '\$34.99',
      imageUrl: 'assets/images/products/shorts/cargo_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's3',
      name: 'Running Shorts',
      price: '\$24.99',
      imageUrl: 'assets/images/products/shorts/running_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's4',
      name: 'Denim Shorts',
      price: '\$39.99',
      imageUrl: 'assets/images/products/shorts/denim_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's5',
      name: 'Athletic Shorts',
      price: '\$27.99',
      imageUrl: 'assets/images/products/shorts/athletic_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's6',
      name: 'Chino Shorts',
      price: '\$32.99',
      imageUrl: 'assets/images/products/shorts/chino_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's7',
      name: 'High Waisted Shorts',
      price: '\$36.99',
      imageUrl: 'assets/images/products/shorts/high_waisted_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's8',
      name: 'Striped Shorts',
      price: '\$28.99',
      imageUrl: 'assets/images/products/shorts/striped_shorts.jpg',
      category: 'Shorts',
    ),
    Product(
      id: 's9',
      name: 'Blue Denim Shorts',
      price: '\$31.99',
      imageUrl: 'assets/images/products/shorts/blue_distressed_shorts.jpg',
      category: 'Shorts',
      description: 'Classic blue denim shorts with a comfortable fit. Perfect for casual summer days.',
      colors: ['Blue'],
    ),

    // Shoes / Zapatos
    Product(
      id: 'sh1',
      name: 'Running Shoes',
      price: '\$89.99',
      imageUrl: 'assets/images/products/shoes/running_shoes.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh2',
      name: 'Casual Sneakers',
      price: '\$75.99',
      imageUrl: 'assets/images/products/shoes/casual_sneakers.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh3',
      name: 'Sport Shoes',
      price: '\$95.99',
      imageUrl: 'assets/images/products/shoes/sport_shoes.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh4',
      name: 'Walking Shoes',
      price: '\$82.99',
      imageUrl: 'assets/images/products/shoes/walking_shoes.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh5',
      name: 'Training Shoes',
      price: '\$99.99',
      imageUrl: 'assets/images/products/shoes/training_shoes.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh6',
      name: 'Canvas Sneakers',
      price: '\$65.99',
      imageUrl: 'assets/images/products/shoes/canvas_sneakers.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh7',
      name: 'Basketball Shoes',
      price: '\$120.99',
      imageUrl: 'assets/images/products/shoes/basketball_shoes.jpg',
      category: 'Zapatos',
    ),
    Product(
      id: 'sh8',
      name: 'Leather Sneakers',
      price: '\$110.99',
      imageUrl: 'assets/images/products/shoes/leather_sneakers.jpg',
      category: 'Zapatos',
    ),

    // Bags / Bolsos
    Product(
      id: 'b1',
      name: 'Backpack',
      price: '\$55.99',
      imageUrl: 'assets/images/products/bags/backpack.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b2',
      name: 'Crossbody Bag',
      price: '\$42.99',
      imageUrl: 'assets/images/products/bags/crossbody_bag.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b3',
      name: 'Tote Bag',
      price: '\$38.99',
      imageUrl: 'assets/images/products/bags/tote_bag.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b4',
      name: 'Travel Bag',
      price: '\$72.99',
      imageUrl: 'assets/images/products/bags/travel_bag.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b5',
      name: 'Shoulder Bag',
      price: '\$48.99',
      imageUrl: 'assets/images/products/bags/shoulder_bag.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b6',
      name: 'Messenger Bag',
      price: '\$65.99',
      imageUrl: 'assets/images/products/bags/messenger_bag.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b7',
      name: 'Mini Backpack',
      price: '\$45.99',
      imageUrl: 'assets/images/products/bags/mini_backpack.jpg',
      category: 'Bolsos',
    ),
    Product(
      id: 'b8',
      name: 'Leather Bag',
      price: '\$85.99',
      imageUrl: 'assets/images/products/bags/leather_bag.jpg',
      category: 'Bolsos',
    ),

    // Accessories / Accesorios
    Product(
      id: 'a1',
      name: 'Watch Classic',
      price: '\$129.99',
      imageUrl: 'assets/images/products/accessories/watch_classic.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a2',
      name: 'Sunglasses',
      price: '\$45.99',
      imageUrl: 'assets/images/products/accessories/sunglasses.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a3',
      name: 'Leather Belt',
      price: '\$28.99',
      imageUrl: 'assets/images/products/accessories/leather_belt.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a4',
      name: 'Wallet',
      price: '\$35.99',
      imageUrl: 'assets/images/products/accessories/wallet.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a5',
      name: 'Cap',
      price: '\$22.99',
      imageUrl: 'assets/images/products/accessories/cap.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a6',
      name: 'Bracelet',
      price: '\$18.99',
      imageUrl: 'assets/images/products/accessories/bracelet.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a7',
      name: 'Necklace',
      price: '\$25.99',
      imageUrl: 'assets/images/products/accessories/necklace.jpg',
      category: 'Accesorios',
    ),
    Product(
      id: 'a8',
      name: 'Smart Watch',
      price: '\$199.99',
      imageUrl: 'assets/images/products/accessories/smart_watch.jpg',
      category: 'Accesorios',
    ),
  ];
}
