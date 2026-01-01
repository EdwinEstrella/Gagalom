import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/app_search_bar.dart';
import '../../../features/search/screens/search_filter_screen.dart';
import '../../../features/product/screens/product_detail_screen.dart';
import '../../../features/cart/screens/cart_screen.dart';
import '../../../core/data/products_data.dart';
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/arrow-down.svg',
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
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
    final theme = Theme.of(context);
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
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        size: 20,
                        color: theme.colorScheme.primary,
                      )
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
    // Top Selling - Hoodies
    final products = ProductsData.allProducts.where((p) => p.category == 'Sudaderas').take(5).toList();

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
              imageUrl: product.imageUrl,
              name: product.name,
              price: product.price,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productName: product.name,
                      productPrice: product.price,
                      imageUrl: product.imageUrl,
                      description: product.description,
                      availableColors: product.colors,
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
    // New Products - Mixed categories (Shorts, Shoes, etc.)
    final products = ProductsData.allProducts.where((p) => p.category != 'Sudaderas').take(8).toList();

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
              imageUrl: product.imageUrl,
              name: product.name,
              price: product.price,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productName: product.name,
                      productPrice: product.price,
                      imageUrl: product.imageUrl,
                      description: product.description,
                      availableColors: product.colors,
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
