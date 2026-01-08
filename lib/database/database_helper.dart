import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'store_app.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      // Add createdAt and updatedAt columns to products table
      await db.execute('ALTER TABLE products ADD COLUMN createdAt TEXT');
      await db.execute('ALTER TABLE products ADD COLUMN updatedAt TEXT');
    }
    if (oldVersion < 4) {
      // Add orders table
      await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        customerName TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        items TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        notes TEXT
      )
    ''');

      await db.execute('''
      CREATE TABLE notes(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        isImportant INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
    }
    if (oldVersion < 5) {
      // Add notes table
      await db.execute('''
        CREATE TABLE notes(
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          category TEXT NOT NULL,
          isImportant INTEGER NOT NULL DEFAULT 0,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        category TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (productId) REFERENCES products (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id TEXT PRIMARY KEY,
        customerName TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        items TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  // Product operations
  Future<int> insertProduct(Product product) async {
    Database db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    Database db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    Database db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Cart operations
  Future<int> insertCartItem(String productId, int quantity) async {
    Database db = await database;
    return await db.insert('cart_items', {
      'productId': productId,
      'quantity': quantity,
    });
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    Database db = await database;
    return await db.rawQuery('''
      SELECT ci.*, p.name, p.description, p.price, p.quantity as stock_quantity, p.category, p.imageUrl
      FROM cart_items ci
      INNER JOIN products p ON ci.productId = p.id
    ''');
  }

  Future<int> updateCartItemQuantity(String productId, int quantity) async {
    Database db = await database;
    return await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<int> removeFromCart(String productId) async {
    Database db = await database;
    return await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<int> clearCart() async {
    Database db = await database;
    return await db.delete('cart_items');
  }

  // Order operations
  Future<int> insertOrder(Map<String, dynamic> orderData) async {
    Database db = await database;
    return await db.insert('orders', orderData);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    Database db = await database;
    return await db.query('orders', orderBy: 'createdAt DESC');
  }

  Future<int> updateOrderStatus(String orderId, String status) async {
    Database db = await database;
    return await db.update(
      'orders',
      {'status': status, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  Future<int> deleteOrder(String orderId) async {
    Database db = await database;
    return await db.delete('orders', where: 'id = ?', whereArgs: [orderId]);
  }

  Future<int> updateProductQuantity(String productId, int newQuantity) async {
    Database db = await database;
    return await db.update(
      'products',
      {'quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }

  // User operations
  Future<int> insertUser(String name, String email, String password) async {
    Database db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Notes operations
  Future<int> insertNote(Map<String, dynamic> noteData) async {
    Database db = await database;
    return await db.insert('notes', noteData);
  }

  Future<List<Map<String, dynamic>>> getNotes() async {
    Database db = await database;
    return await db.query('notes', orderBy: 'createdAt DESC');
  }

  Future<int> updateNote(String noteId, Map<String, dynamic> noteData) async {
    Database db = await database;
    return await db.update(
      'notes',
      noteData,
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<int> deleteNote(String noteId) async {
    Database db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [noteId]);
  }
}
