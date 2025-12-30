import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // Sample products by category
  final List<ProductItem> _allProducts = [
    // Sudaderas / Hoodies
    ProductItem(
      name: 'Pullover Hoodie',
      price: 45.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1551487180522-86e4fff3af7f?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Zip Hoodie',
      price: 52.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Fleece Hoodie',
      price: 38.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1578587018452-892bacefd3f2?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Graphic Hoodie',
      price: 41.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Classic Hoodie',
      price: 44.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1576871337622-98d48d1cf531?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Premium Hoodie',
      price: 59.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Sport Hoodie',
      price: 47.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Urban Hoodie',
      price: 49.99,
      category: 'Sudaderas',
      imageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=322&h=440&fit=crop',
    ),

    // Shorts
    ProductItem(
      name: 'Classic Shorts',
      price: 29.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Cargo Shorts',
      price: 34.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Running Shorts',
      price: 24.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1552902865-b72c031ac5ea?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Denim Shorts',
      price: 39.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1506634572416-48cdfe530110?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Athletic Shorts',
      price: 27.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Chino Shorts',
      price: 32.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-15158866570179-0f358da154a0?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'High Waisted Shorts',
      price: 36.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1588169908258-36b4d2c0eb64?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Striped Shorts',
      price: 28.99,
      category: 'Shorts',
      imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7c97db31?w=322&h=440&fit=crop',
    ),

    // Zapatos / Shoes
    ProductItem(
      name: 'Running Shoes',
      price: 89.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Casual Sneakers',
      price: 75.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Sport Shoes',
      price: 95.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Walking Shoes',
      price: 82.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Training Shoes',
      price: 99.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Canvas Sneakers',
      price: 65.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Basketball Shoes',
      price: 120.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Leather Sneakers',
      price: 110.99,
      category: 'Zapatos',
      imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=322&h=440&fit=crop',
    ),

    // Bolsos / Bags
    ProductItem(
      name: 'Backpack',
      price: 55.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Crossbody Bag',
      price: 42.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Tote Bag',
      price: 38.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Travel Bag',
      price: 72.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1534269285838-0d1c659e8180?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Shoulder Bag',
      price: 48.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1566150905458-1bf1fc113f0d?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Messenger Bag',
      price: 65.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1597484661643-2f5fef26aa4b?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Mini Backpack',
      price: 45.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1594223274512-ad4803739b7c?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Leather Bag',
      price: 85.99,
      category: 'Bolsos',
      imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=322&h=440&fit=crop',
    ),

    // Accesorios / Accessories
    ProductItem(
      name: 'Watch Classic',
      price: 129.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Sunglasses',
      price: 45.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Leather Belt',
      price: 28.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1553704571-c32d20e6c74e?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Wallet',
      price: 35.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Cap',
      price: 22.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Bracelet',
      price: 18.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Necklace',
      price: 25.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=322&h=440&fit=crop',
    ),
    ProductItem(
      name: 'Smart Watch',
      price: 199.99,
      category: 'Accesorios',
      imageUrl: 'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=322&h=440&fit=crop',
    ),
  ];

  List<ProductItem> get _filteredProducts {
    if (_selectedCategory != null) {
      return _allProducts.where((product) => product.category == _selectedCategory).toList();
    }
    return _allProducts;
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

  Widget _buildProductCard(ProductItem product) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 220,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surface,
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Favorite Icon
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      // Toggle favorite
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                    height: 1.6,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
