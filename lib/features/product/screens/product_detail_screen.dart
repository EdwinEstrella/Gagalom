import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productName;
  final String productPrice;
  final String imageUrl;
  final String description;
  final List<String> availableColors;

  const ProductDetailScreen({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.imageUrl,
    this.description = '',
    this.availableColors = const [],
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String _selectedSize = 'S';
  late String _selectedColor;
  int _quantity = 1;
  bool _isFavorite = false;

  final List<String> _sizes = ['S', 'M', 'L', 'XL', '2XL'];
  final Map<String, Color> _colors = {
    'Orange': const Color(0xFFEC6D26),
    'Black': const Color(0xFF272727),
    'Red': const Color(0xFFFA3636),
    'Yellow': const Color(0xFFF4BD2F),
    'Blue': const Color(0xFF4468E5),
    'Cream': const Color(0xFFFFFDD0),
  };

  final List<String> _productImages = [];

  @override
  void initState() {
    super.initState();
    // Initialize selected color
    if (widget.availableColors.isNotEmpty) {
      _selectedColor = widget.availableColors.first;
    } else {
      _selectedColor = _colors.keys.first;
    }

    // Add the main image 3 times for demo
    _productImages.add(widget.imageUrl);
    _productImages.add(widget.imageUrl);
    _productImages.add(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 72),

                  // Product Images
                  _buildProductImages(),

                  const SizedBox(height: 24),

                  // Product Name and Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.productPrice,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 52),

                  // Size Selector
                  _buildSizeSelector(theme),

                  const SizedBox(height: 12),

                  // Color Selector
                  _buildColorSelector(theme),

                  const SizedBox(height: 12),

                  // Quantity Selector
                  _buildQuantitySelector(theme),

                  const SizedBox(height: 80),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.description.isNotEmpty
                          ? widget.description
                          : 'Built for life and made to last, this product is crafted with premium materials to ensure comfort and durability.',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Shipping & Returns
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping & Returns',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Free standard shipping and free 60-day returns',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Reviews
                  _buildReviewsSection(theme),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Top Buttons
            Positioned(
              top: 8,
              left: 24,
              child: _buildTopButton(
                Icons.arrow_back_ios,
                () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 8,
              right: 24,
              child: _buildTopButton(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
            ),

            // Bottom Add to Bag Button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: _buildAddToBagButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImages() {
    return SizedBox(
      height: 248,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _productImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < _productImages.length - 1 ? 10 : 0),
            child: Container(
              width: 161,
              height: 248,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: _productImages[index].startsWith('http')
                      ? NetworkImage(_productImages[index]) as ImageProvider
                      : AssetImage(_productImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSizeSelector(ThemeData theme) {
    return GestureDetector(
      onTap: () => _showSizeBottomSheet(theme),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Text(
              'Size',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              _selectedSize,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(ThemeData theme) {
    return GestureDetector(
      onTap: () => _showColorBottomSheet(theme),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Text(
              'Color',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: _colors[_selectedColor],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // Minus Button
          GestureDetector(
            onTap: () {
              setState(() {
                if (_quantity > 1) _quantity--;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.remove,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _quantity.toString(),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          // Plus Button
          GestureDetector(
            onTap: () {
              setState(() {
                _quantity++;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '4.5 Ratings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '213 Reviews',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 16),
          _buildReviewItem(theme, 'Alex Morgan', 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. From staple items to distinctive accessories.', '12days ago'),
          const SizedBox(height: 12),
          _buildReviewItem(theme, 'Alex Morgan', 'Gucci transcribes its heritage, creativity, and innovation into a plenitude of collections. From staple items to distinctive accessories.', '12days ago'),
        ],
      ),
    );
  }

  Widget _buildReviewItem(ThemeData theme, String name, String review, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            // Rating stars (simplified)
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 16,
                  color: theme.colorScheme.primary,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          review,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTopButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildAddToBagButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                widget.productPrice,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: Text(
                'Add to Bag',
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSizeBottomSheet(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._sizes.map((size) {
                    final isSelected = _selectedSize == size;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = size;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                            ),
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
      },
    );
  }

  void _showColorBottomSheet(ThemeData theme) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Color',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._colors.entries.where((entry) {
                    if (widget.availableColors.isEmpty) return true;
                    return widget.availableColors.contains(entry.key);
                  }).map((entry) {
                    final colorName = entry.key;
                    final color = entry.value;
                    final isSelected = _selectedColor == colorName;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 4,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorName;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              Text(
                                colorName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: theme.colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.check,
                                  size: 24,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ],
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
      },
    );
  }
}
