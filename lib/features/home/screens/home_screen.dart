import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../features/search/screens/search_filter_screen.dart';
import '../../../features/product/screens/product_detail_screen.dart';
import '../../../features/cart/screens/cart_screen.dart';
import 'categories_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'Men';
  final List<String> _categories = ['Men', 'Women'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 24),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppSearchBar(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchFilterScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Categories Section
            _buildCategoriesSection(context),
            const SizedBox(height: 24),

            // Top Selling Section
            _buildSectionHeader(
              context,
              title: 'Más Vendidos',
              onSeeAll: () {},
            ),
            const SizedBox(height: 16),
            _buildProductCarousel(context),
            const SizedBox(height: 24),

            // New In Section
            _buildSectionHeader(
              context,
              title: 'Nuevos',
              onSeeAll: () {},
            ),
            const SizedBox(height: 16),
            _buildNewProductsCarousel(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Avatar (left)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop&crop=face'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Spacer para empujar el selector al centro
          const Spacer(),

          // Category Selector (CENTERED)
          GestureDetector(
            onTap: () => _showCategoryBottomSheet(context),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCategory,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/arrow-down.svg',
                    width: 16,
                    height: 16,
                  ),
                ],
              ),
            ),
          ),

          // Spacer para empujar el carrito a la derecha
          const Spacer(),

          // Cart Icon (right)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return ListTile(
                title: Text(
                  category,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Categories Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categorías',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                },
                child: const Text('Ver todo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Categories Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryItem(
                context,
                icon: Icons.checkroom_outlined,
                label: 'Sudaderas',
              ),
              _buildCategoryItem(
                context,
                icon: Icons.shortcut_outlined,
                label: 'Shorts',
              ),
              _buildCategoryItem(
                context,
                icon: Icons.shopping_bag_outlined,
                label: 'Zapatos',
              ),
              _buildCategoryItem(
                context,
                icon: Icons.work_outline,
                label: 'Bolsos',
              ),
              _buildCategoryItem(
                context,
                icon: Icons.diamond_outlined,
                label: 'Accesorios',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchFilterScreen(
              initialCategory: label,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCarousel(BuildContext context) {
    // Lista de productos con imágenes reales de Unsplash
    final products = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=322&h=440&fit=crop',
        'name': 'Mohair Blouse',
        'price': '\$24.55',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=322&h=440&fit=crop',
        'name': 'Carl max Cardigan',
        'price': '\$34.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=322&h=440&fit=crop',
        'name': 'Cotton T-Shirt',
        'price': '\$19.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=322&h=440&fit=crop',
        'name': 'Denim Jacket',
        'price': '\$89.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1551487180522-86e4fff3af7f?w=322&h=440&fit=crop',
        'name': 'Pullover Hoodie',
        'price': '\$45.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=322&h=440&fit=crop',
        'name': 'Zip Hoodie',
        'price': '\$52.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?w=322&h=440&fit=crop',
        'name': 'Fleece Hoodie',
        'price': '\$38.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=322&h=440&fit=crop',
        'name': 'Graphic Hoodie',
        'price': '\$41.99',
      },
    ];

    return SizedBox(
      height: 281,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: EdgeInsets.only(right: index < products.length - 1 ? 12 : 0),
            child: ProductCard(
              imageUrl: product['imageUrl']!,
              name: product['name']!,
              price: product['price']!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productName: product['name']!,
                      productPrice: product['price']!,
                      imageUrl: product['imageUrl']!,
                    ),
                  ),
                );
              },
              onFavoriteTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewProductsCarousel(BuildContext context) {
    // Productos nuevos: Shorts, Zapatos, Bolsos, Accesorios
    final products = [
      {
        'imageUrl': 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=322&h=440&fit=crop',
        'name': 'Classic Shorts',
        'price': '\$29.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=322&h=440&fit=crop',
        'name': 'Cargo Shorts',
        'price': '\$34.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=322&h=440&fit=crop',
        'name': 'Running Shorts',
        'price': '\$24.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1506634572416-48cdfe530110?w=322&h=440&fit=crop',
        'name': 'Denim Shorts',
        'price': '\$39.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=322&h=440&fit=crop',
        'name': 'Athletic Shorts',
        'price': '\$27.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-15158866570179-0f358da154a0?w=322&h=440&fit=crop',
        'name': 'Chino Shorts',
        'price': '\$32.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1588169908258-36b4d2c0eb64?w=322&h=440&fit=crop',
        'name': 'High Waisted Shorts',
        'price': '\$36.99',
      },
      {
        'imageUrl': 'https://images.unsplash.com/photo-1594633312681-425c7c97db31?w=322&h=440&fit=crop',
        'name': 'Striped Shorts',
        'price': '\$28.99',
      },
    ];

    return SizedBox(
      height: 281,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: EdgeInsets.only(right: index < products.length - 1 ? 12 : 0),
            child: ProductCard(
              imageUrl: product['imageUrl']!,
              name: product['name']!,
              price: product['price']!,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productName: product['name']!,
                      productPrice: product['price']!,
                      imageUrl: product['imageUrl']!,
                    ),
                  ),
                );
              },
              onFavoriteTap: () {},
            ),
          );
        },
      ),
    );
  }
}
