import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/note_model.dart';

class AppProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Products
  List<Product> _products = [];
  List<Product> get products => _products;

  // Cart items
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  // Orders
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  // Notes
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error messages
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Theme mode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Profile picture
  String? _profilePicturePath;
  String? get profilePicturePath => _profilePicturePath;

  void setProfilePicture(String? path) {
    _profilePicturePath = path;
    notifyListeners();
  }

  void toggleThemeMode() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // Initialize database and load data
  Future<void> initialize() async {
    setLoading(true);
    try {
      await loadProducts();
      await loadCartItems();
      await loadOrders();
      clearError();
    } catch (e) {
      setError('Failed to initialize database: $e');
    } finally {
      setLoading(false);
    }
  }

  // Load products from database
  Future<void> loadProducts() async {
    try {
      _products = await _dbHelper.getProducts();
      notifyListeners();
    } catch (e) {
      setError('Failed to load products: $e');
    }
  }

  // Load cart items from database
  Future<void> loadCartItems() async {
    try {
      final cartData = await _dbHelper.getCartItems();
      _cartItems = cartData.map((item) {
        final product = Product.fromMap(item);
        return CartItem(product: product, quantity: item['quantity']);
      }).toList();
      notifyListeners();
    } catch (e) {
      setError('Failed to load cart items: $e');
    }
  }

  // Load orders from database
  Future<void> loadOrders() async {
    try {
      final orderData = await _dbHelper.getOrders();
      _orders = orderData.map((order) => Order.fromMap(order)).toList();
      notifyListeners();
    } catch (e) {
      setError('Failed to load orders: $e');
    }
  }

  // Load notes from database
  Future<void> loadNotes() async {
    try {
      final noteData = await _dbHelper.getNotes();
      _notes = noteData.map((note) => Note.fromMap(note)).toList();
      notifyListeners();
    } catch (e) {
      setError('Failed to load notes: $e');
    }
  }

  // Set current user
  void setCurrentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Products management
  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      _products.add(product);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to add product: $e');
      return false;
    }
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _dbHelper.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to delete product: $e');
      return false;
    }
  }

  Product? getProductById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  // Cart management
  Future<void> addToCart(Product product, int quantity) async {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Update existing item quantity
      final existingItem = _cartItems[existingIndex];
      final newQuantity = existingItem.quantity + quantity;

      if (newQuantity <= product.quantity) {
        // Decrease product quantity in database
        final updatedProduct = product.copyWith(
          quantity: product.quantity - quantity,
        );
        await _dbHelper.updateProduct(updatedProduct);
        updateProduct(updatedProduct);

        _cartItems[existingIndex] = existingItem.copyWith(
          quantity: newQuantity,
        );
        await _dbHelper.updateCartItemQuantity(product.id, newQuantity);
      }
    } else {
      // Add new item to cart
      if (quantity <= product.quantity) {
        // Decrease product quantity in database
        final updatedProduct = product.copyWith(
          quantity: product.quantity - quantity,
        );
        await _dbHelper.updateProduct(updatedProduct);
        updateProduct(updatedProduct);

        _cartItems.add(CartItem(product: product, quantity: quantity));
        await _dbHelper.insertCartItem(product.id, quantity);
      }
    }
    notifyListeners();
  }

  Future<void> updateCartItemQuantity(String productId, int newQuantity) async {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final item = _cartItems[index];
      final currentQuantity = item.quantity;
      final quantityDifference = newQuantity - currentQuantity;

      if (newQuantity <= 0) {
        // Remove from cart - restore full quantity
        final updatedProduct = item.product.copyWith(
          quantity: item.product.quantity + currentQuantity,
        );
        await _dbHelper.updateProduct(updatedProduct);
        updateProduct(updatedProduct);

        _cartItems.removeAt(index);
        await _dbHelper.removeFromCart(productId);
      } else {
        // Check if we have enough stock for the increase
        if (quantityDifference > 0 &&
            quantityDifference > item.product.quantity) {
          // Not enough stock
          return;
        }

        // Update product quantity
        final updatedProduct = item.product.copyWith(
          quantity: item.product.quantity - quantityDifference,
        );
        await _dbHelper.updateProduct(updatedProduct);
        updateProduct(updatedProduct);

        _cartItems[index] = item.copyWith(quantity: newQuantity);
        await _dbHelper.updateCartItemQuantity(productId, newQuantity);
      }
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String productId) async {
    final item = _cartItems.firstWhere((item) => item.product.id == productId);
    // Restore the quantity to the product
    final updatedProduct = item.product.copyWith(
      quantity: item.product.quantity + item.quantity,
    );
    await _dbHelper.updateProduct(updatedProduct);
    updateProduct(updatedProduct);

    _cartItems.removeWhere((item) => item.product.id == productId);
    await _dbHelper.removeFromCart(productId);
    notifyListeners();
  }

  Future<void> clearCart() async {
    // Restore all quantities back to products when clearing cart
    for (final item in _cartItems) {
      final updatedProduct = item.product.copyWith(
        quantity: item.product.quantity + item.quantity,
      );
      await _dbHelper.updateProduct(updatedProduct);
      updateProduct(updatedProduct);
    }

    _cartItems.clear();
    await _dbHelper.clearCart();
    notifyListeners();
  }

  // Get cart total
  double get cartTotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  // Get cart items count
  int get cartItemsCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Orders management
  void setOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  Future<bool> addOrder(Order order) async {
    try {
      await _dbHelper.insertOrder(order.toMap());
      _orders.add(order);

      // Note: Product quantities are already reduced when adding to cart
      // No need to reduce again here as the cart items represent reserved stock

      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to add order: $e');
      return false;
    }
  }

  Future<bool> addSale(
    String productName,
    int quantity,
    double price, {
    String? notes,
  }) async {
    try {
      // Find product by name
      final product = _products.firstWhere((p) => p.name == productName);

      // Check if enough quantity
      if (product.quantity < quantity) {
        setError('الكمية غير كافية');
        return false;
      }

      // Decrease product quantity
      final updatedProduct = product.copyWith(
        quantity: product.quantity - quantity,
      );
      await _dbHelper.updateProduct(updatedProduct);
      updateProduct(updatedProduct);

      // Create order
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final cartItem = CartItem(product: product, quantity: quantity);
      final order = Order(
        id: orderId,
        customerName: 'بيع مباشر - $productName',
        customerPhone: '',
        items: [cartItem],
        totalAmount: price * quantity,
        status: OrderStatus.delivered,
        notes: notes,
      );

      await _dbHelper.insertOrder(order.toMap());
      _orders.add(order);
      notifyListeners();
      return true;
    } on StateError {
      setError('المنتج غير موجود');
      return false;
    } catch (e) {
      setError('Failed to add sale: $e');
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      await _dbHelper.deleteOrder(orderId);
      _orders.removeWhere((o) => o.id == orderId);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to delete order: $e');
      return false;
    }
  }

  void updateOrder(Order updatedOrder) {
    final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  Order? getOrderById(String id) {
    return _orders.firstWhere((o) => o.id == id);
  }

  // Notes management
  void setNotes(List<Note> notes) {
    _notes = notes;
    notifyListeners();
  }

  Future<bool> addNote(Note note) async {
    try {
      await _dbHelper.insertNote(note.toMap());
      _notes.add(note);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to add note: $e');
      return false;
    }
  }

  Future<bool> updateNote(Note updatedNote) async {
    try {
      await _dbHelper.updateNote(updatedNote.id, updatedNote.toMap());
      final index = _notes.indexWhere((n) => n.id == updatedNote.id);
      if (index != -1) {
        _notes[index] = updatedNote;
        notifyListeners();
      }
      return true;
    } catch (e) {
      setError('Failed to update note: $e');
      return false;
    }
  }

  Future<bool> removeNote(String noteId) async {
    try {
      await _dbHelper.deleteNote(noteId);
      _notes.removeWhere((n) => n.id == noteId);
      notifyListeners();
      return true;
    } catch (e) {
      setError('Failed to delete note: $e');
      return false;
    }
  }

  Note? getNoteById(String id) {
    return _notes.firstWhere((n) => n.id == id);
  }

  // Get notes by category
  List<Note> getNotesByCategory(String category) {
    return _notes.where((note) => note.category == category).toList();
  }

  // Get important notes
  List<Note> get importantNotes =>
      _notes.where((note) => note.isImportant).toList();

  // Logout
  void logout() {
    _currentUser = null;
    _cartItems.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clearAllData() {
    _products.clear();
    _cartItems.clear();
    _orders.clear();
    _notes.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
