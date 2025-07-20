import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/dashboard_controller.dart';
import '../../models/cart_item.dart';
import '../../models/food.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DashboardController _controller;
  late TextEditingController _searchController;
  String _selectedCategory = 'Hot Dishes';

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false; //Declare a FocusNode and listener for hide the hintText automatically

  @override
  void initState() {
    super.initState();
    _controller = DashboardController();
    _searchController = TextEditingController();

    // Listen to search input changes
    _searchController.addListener(() {
      _controller.updateSearchQuery(_searchController.text);
    });

    //hide the hintText automatically
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          _buildSidebar(context),

          // Main Content Area
          Expanded(flex: 3, child: _buildMainContent(context)),

          // Right Cart Panel
          _buildCartPanel(context),
        ],
      ),
    );
  }

  // Build left sidebar with navigation and categories
  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          // Header with logo and restaurant info
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Restaurant info
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jaegar Resto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'CODY ZEA',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Menu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNavItem(Icons.access_time, 'Recent Orders', false),
                _buildNavItem(Icons.bar_chart, 'Statistics', false),
                _buildNavItem(Icons.restaurant_menu, 'Menu', false),
                _buildNavItem(Icons.people, 'Customers', false),
                _buildNavItem(Icons.receipt, 'Orders', false),
                _buildNavItem(Icons.notifications, 'Notifications', true),
                _buildNavItem(Icons.settings, 'Settings', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build individual navigation item
  Widget _buildNavItem(IconData icon, String title, bool hasNotification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 14)),
        trailing: hasNotification
            ? Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {},
      ),
    );
  }

  // Build main content area with categories and food items
  Widget _buildMainContent(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Top bar with search and categories
          _buildTopBar(context),

          // Food items grid
          Expanded(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return _buildFoodItemsGrid(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build top bar with search and category tabs
  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Row(
            children: [
              const Spacer(), // Pushes the search bar to the right
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2, // 40% width
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: _isSearchFocused ? '' : 'Search for food, coffee, etc.',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Category tabs
          Row(
            children: [
              _buildCategoryTab('Hot Dishes'),
              _buildCategoryTab('Cold Dishes'),
              _buildCategoryTab('Soup'),
              _buildCategoryTab('Grill'),
              _buildCategoryTab('Appetizer'),
              _buildCategoryTab('Dessert'),
            ],
          ),

          const SizedBox(height: 10),

          Divider(
            color: Colors.grey, // or use Theme.of(context).dividerColor
            thickness: 1,
          ),

          const SizedBox(height: 10),

          // Section title
          const Text(
            'Choose Dishes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Build category tab button
  Widget _buildCategoryTab(String title) {
    final bool isSelected = title == _selectedCategory;

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = title;
          });
          _controller.selectCategory(title);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          foregroundColor: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyLarge?.color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(title),
      ),
    );
  }

  // Build food items grid
  Widget _buildFoodItemsGrid(BuildContext context) {
    final items = _controller.filteredFoods;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildFoodItemCard(context, items[index]);
      },
    );
  }

  // Build individual food item card
  Widget _buildFoodItemCard(BuildContext context, Food item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _controller.addToCart(item),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Full-width, full-height image with hot indicator
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.asset(item.imagePath, fit: BoxFit.cover),
                    ),
                  ),

                  // Hot indicator
                  if (item.isHot)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Centered food details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${item.bowlsAvailable} Bowls Available',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build right cart panel
  Widget _buildCartPanel(BuildContext context) {
    return Container(
      width: 350,
      color: Theme.of(context).cardColor,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            children: [
              // Cart header
              _buildCartHeader(context),

              // Cart items list
              Expanded(child: _buildCartItemsList(context)),

              // Cart summary and checkout
              _buildCartSummary(context),
            ],
          );
        },
      ),
    );
  }

  // Build cart header with order number and status
  Widget _buildCartHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Orders ${_controller.currentOrderId}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Dine In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build list of cart items
  Widget _buildCartItemsList(BuildContext context) {
    if (_controller.cartItems.isEmpty) {
      return const Center(
        child: Text(
          'No items in cart',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _controller.cartItems.length,
      itemBuilder: (context, index) {
        return _buildCartItemCard(context, _controller.cartItems[index]);
      },
    );
  }

  // Build individual cart item card
  Widget _buildCartItemCard(BuildContext context, CartItem cartItem) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item header with image, name, and remove button
          Row(
            children: [
              // Food image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.food.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${cartItem.food.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Remove button
              IconButton(
                onPressed: () => _controller.removeFromCart(cartItem.id),
                icon: const Icon(Icons.close, size: 16),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),

          // Special note if exists
          if (cartItem.specialNote != null) ...[
            const SizedBox(height: 8),
            Text(
              cartItem.specialNote!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Quantity controls and total price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Quantity controls
              Row(
                children: [
                  IconButton(
                    onPressed: () => _controller.updateCartItemQuantity(
                      cartItem.id,
                      cartItem.quantity - 1,
                    ),
                    icon: const Icon(Icons.remove, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      minimumSize: const Size(32, 32),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Text(
                      '${cartItem.quantity}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  IconButton(
                    onPressed: () => _controller.updateCartItemQuantity(
                      cartItem.id,
                      cartItem.quantity + 1,
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                ],
              ),

              // Total price for this item
              Text(
                '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build cart summary with totals and checkout button
  Widget _buildCartSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Subtotal and total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Discount'),
              Text('\$${0.toStringAsFixed(2)}'),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sub total',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${_controller.cartSubtotal.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Checkout button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.cartItems.isNotEmpty
                  ? _controller.processOrder
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue to Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
