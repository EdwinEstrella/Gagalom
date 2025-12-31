import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/products_data.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../features/product/screens/product_detail_screen.dart';

enum SearchScreenMode {
  categories,  // Shop by Categories
  results,     // Search results with products
  empty,       // No results found
}

class SearchFilterScreen extends ConsumerStatefulWidget {
  final String? initialCategory;

  const SearchFilterScreen({super.key, this.initialCategory});

  @override
  ConsumerState<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends ConsumerState<SearchFilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SearchScreenMode _mode;
  String? _selectedCategory;

  // Filter states
  String _selectedSort = 'Recommended';
  String _selectedGender = 'Men';
  bool _onSale = false;
  bool _freeShipping = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _mode = widget.initialCategory != null
        ? SearchScreenMode.results
        : SearchScreenMode.categories;
  }

  // Categories data
  final List<CategoryItem> _categories = [
    CategoryItem(
      name: 'Sudaderas',
      icon: Icons.checkroom_outlined,
      imageUrl: 'https://via.placeholder.com/40',
    ),
    CategoryItem(
      name: 'Shorts',
      icon: Icons.shortcut_outlined,
      imageUrl: 'https://via.placeholder.com/40',
    ),
    CategoryItem(
      name: 'Zapatos',
      icon: Icons.shopping_bag_outlined,
      imageUrl: 'https://via.placeholder.com/40',
    ),
    CategoryItem(
      name: 'Bolsos',
      icon: Icons.work_outline,
      imageUrl: 'https://via.placeholder.com/40',
    ),
    CategoryItem(
      name: 'Accesorios',
      icon: Icons.watch_outlined,
      imageUrl: 'https://via.placeholder.com/40',
    ),
  ];

  List<Product> get _filteredProducts {
    List<Product> products = ProductsData.allProducts;

    // Filter by Category
    if (_selectedCategory != null) {
      products = products.where((product) => product.category == _selectedCategory).toList();
    }
    
    // Filter by Search Text
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      products = products.where((product) => product.name.toLowerCase().contains(query)).toList();
    }

    // Filter by Gender (Mock logic as data doesn't have gender yet)
    if (_selectedGender != 'All') {
      // products = products.where((p) => p.gender == _selectedGender).toList();
    }

    return products;
  }

  int get _resultsCount => _filteredProducts.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header with Search Bar
            _buildHeader(context),

            // Content based on mode
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      style: const TextStyle(fontSize: 12),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            _selectedCategory = null;
                            _mode = SearchScreenMode.results;
                          } else {
                            _mode = SearchScreenMode.categories;
                          }
                        });
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _selectedCategory = null;
                          _mode = SearchScreenMode.categories;
                        });
                      },
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_mode) {
      case SearchScreenMode.categories:
        return _buildCategoriesList();
      case SearchScreenMode.results:
        return _buildResults();
      case SearchScreenMode.empty:
        return _buildEmptyState();
    }
  }

  Widget _buildCategoriesList() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          Text(
            'Shop by Categories',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 40),

          // Categories List
          ..._categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category.name;
                    _mode = SearchScreenMode.results;
                  });
                },
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Category Icon/Image
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.icon,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Category Name
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_filteredProducts.isEmpty) {
      return _buildEmptyState();
    }

    final theme = Theme.of(context);

    return Column(
      children: [
        // Category Name or Filter Pills Row
        _buildFilterPills(),

        const SizedBox(height: 8),

        // Results Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (_selectedCategory != null) ...[
                  Text(
                    _selectedCategory!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_resultsCount Results',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ] else
                  Text(
                    '$_resultsCount Results Found',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Products Grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 161 / 288,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_filteredProducts[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterPills() {
    final theme = Theme.of(context);
    final activeFilterCount = [_onSale, _freeShipping].where((e) => e).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Filter button with count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 16,
                  color: theme.colorScheme.onPrimary,
                ),
                if (activeFilterCount > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    activeFilterCount.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 4),

          // Category filter (if selected)
          if (_selectedCategory != null) ...[
            _buildFilterChip(
              label: _selectedCategory!,
              isSelected: true,
              onTap: () {
                setState(() {
                  _selectedCategory = null;
                  _mode = SearchScreenMode.categories;
                });
              },
            ),
            const SizedBox(width: 4),
          ],

          // On Sale
          _buildFilterChip(
            label: 'On Sale',
            isSelected: _onSale,
            onTap: () => _showDealsSheet(),
          ),

          const SizedBox(width: 4),

          // Price
          _buildFilterChip(
            label: 'Price',
            hasArrow: true,
            isSelected: true,
            onTap: () => _showPriceSheet(),
          ),

          const SizedBox(width: 4),

          // Sort by
          _buildFilterChip(
            label: 'Sort by',
            hasArrow: true,
            isSelected: false,
            onTap: () => _showSortBySheet(),
          ),

          const SizedBox(width: 4),

          // Gender
          _buildFilterChip(
            label: _selectedGender,
            hasArrow: true,
            isSelected: true,
            onTap: () => _showGenderSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
    bool hasArrow = false,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            if (hasArrow) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return ProductCard(
      name: product.name,
      price: product.price,
      imageUrl: product.imageUrl,
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
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Search Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 50,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Message
          Text(
            'Sorry, we couldn\'t find any\nmatching result for your Search.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          // Explore Categories Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = null;
                _mode = SearchScreenMode.categories;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text('Explore Categories'),
          ),
        ],
      ),
    );
  }

  void _showSortBySheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 397,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Options
              ...['Recommended', 'Newest', 'Lowest - Highest Price', 'Highest - Lowest Price']
                  .map((option) {
                final isSelected = _selectedSort == option;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSort = option;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: theme.colorScheme.onPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showGenderSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 397,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Options
              ...['Men', 'Women', 'kids'].map((option) {
                final isSelected = _selectedGender == option;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = option;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 34),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: theme.colorScheme.onPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showDealsSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 397,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Deals',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _onSale = !_onSale;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    decoration: BoxDecoration(
                      color: _onSale ? theme.colorScheme.primary : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'On sale',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _onSale
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (_onSale)
                          Icon(
                            Icons.check,
                            color: theme.colorScheme.onPrimary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _freeShipping = !_freeShipping;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    decoration: BoxDecoration(
                      color: _freeShipping ? theme.colorScheme.primary : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Free Shipping Eligible',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: _freeShipping
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        if (_freeShipping)
                          Icon(
                            Icons.check,
                            color: theme.colorScheme.onPrimary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPriceSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 397,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Min Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      'Min',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Max Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 34),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      'Max',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final String imageUrl;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.imageUrl,
  });
}

class ProductItem {
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  ProductItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}
