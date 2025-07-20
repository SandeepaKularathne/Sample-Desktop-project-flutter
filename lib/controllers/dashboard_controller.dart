import 'package:flutter/cupertino.dart';

import '../models/cart_item.dart';
import '../models/food.dart';

class DashboardController extends ChangeNotifier {
  // Private variables for data management
  List<Food> _foods = [];
  List<CartItem> _cartItems = [];
  String _selectedCategory = 'Hot Dishes';
  String _searchQuery = '';
  String _currentOrderId = '#34562';

  // Getters for accessing private data
  List<Food> get foods => _foods;
  List<CartItem> get cartItems => _cartItems;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get currentOrderId => _currentOrderId;

  // Constructor - initializes controller with sample data
  DashboardController() {
    _initializeSampleData();
  }

  // Initialize sample food data matching the design
  void _initializeSampleData() {
    _foods = [
      const Food(
        id: '1',
        name: 'Spicy seasoned seafood noodles',
        description: 'Delicious seafood noodles with spicy seasoning',
        price: 2.29,
        imagePath: 'assets/foods/Delicious seafood noodles with spicy seasoning.jpeg',
        category: 'Hot Dishes',
        bowlsAvailable: 20,
        isHot: true,
      ),
      const Food(
        id: '2',
        name: 'Salted Pasta with mushroom sauce',
        description: 'Creamy pasta with fresh mushroom sauce',
        price: 2.69,
        imagePath: 'assets/foods/Creamy pasta with fresh mushroom sauce.jpeg',
        category: 'Hot Dishes',
        bowlsAvailable: 11,
        isHot: true,
      ),
      const Food(
        id: '3',
        name: 'Beef dumpling in hot and sour soup',
        description: 'Traditional beef dumplings in spicy soup',
        price: 2.99,
        imagePath: 'assets/foods/Beef dumpling in hot and sour soup.jpeg',
        category: 'Hot Dishes',
        bowlsAvailable: 16,
        isHot: true,
      ),
      const Food(
        id: '4',
        name: 'Healthy noodle with spinach leaf',
        description: 'Nutritious noodles with fresh spinach',
        price: 3.29,
        imagePath: 'assets/foods/Healthy noodle with spinach leaf.jpg',
        category: 'Hot Dishes',
        bowlsAvailable: 22,
        isHot: true,
      ),
      const Food(
        id: '5',
        name: 'Hot spicy fried rice with omelet',
        description: 'Spicy fried rice topped with fluffy omelet',
        price: 3.49,
        imagePath: 'assets/foods/Hot spicy fried rice with omelet.jpg',
        category: 'Hot Dishes',
        bowlsAvailable: 13,
        isHot: true,
      ),
      const Food(
        id: '6',
        name: 'Spicy instant noodle with special omelette',
        description: 'Quick and delicious instant noodles',
        price: 3.59,
        imagePath: 'assets/foods/Spicy instant noodle with special omelette.jpeg',
        category: 'Hot Dishes',
        bowlsAvailable: 17,
        isHot: true,
      ),
    ];
    // Initialize cart with sample items matching the design
    _cartItems = [
      CartItem(
        id: 'cart1',
        food: _foods[0],
        quantity: 4,
        specialNote: 'Please, just a little bit spicy only.',
      ),
      CartItem(
        id: 'cart2',
        food: _foods[5],
        quantity: 4,
      ),
      CartItem(
        id: 'cart3',
        food: _foods[2],
        quantity: 1,
      ),
    ];
  }

  // Get filtered food items based on category and search
  List<Food> get filteredFoods {
    List<Food> filtered = _foods
        .where((item) => item.category == _selectedCategory)
        .toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  // Calculate cart subtotal
  double get cartSubtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate cart total (including any fees or discounts)
  double get cartTotal {
    // In a real app, you might add delivery fees, taxes, discounts here
    return cartSubtotal;
  }

  // Get cart item count
  int get cartItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Category selection handler
  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners(); // Notify UI to rebuild
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Add item to cart
  void addToCart(Food food) {
    final existingItemIndex = _cartItems.indexWhere(
          (item) => item.food.id == food.id,
    );

    if (existingItemIndex != -1) {
      // Item exists, increment quantity
      _cartItems[existingItemIndex].quantity++;
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        food: food,
      ));
    }
    notifyListeners();
  }

  // Remove item from cart
  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  // Update cart item quantity
  void updateCartItemQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(cartItemId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (itemIndex != -1) {
      _cartItems[itemIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  // Process order (placeholder for real implementation)
  void processOrder() {
    // In a real app, this would send the order to a backend service
    print('Processing order: $_currentOrderId');
    print('Items: ${_cartItems.length}');
    print('Total: \$${cartTotal.toStringAsFixed(2)}');

    // Clear cart after successful order
    _cartItems.clear();
    notifyListeners();
  }
}
