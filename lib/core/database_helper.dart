import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/user.dart';
import 'database_schema.dart'; // 1. Import ไฟล์ที่เพิ่งสร้าง

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food_fridge.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // แนะนำ: หากมีการเพิ่มตารางใหม่ในอนาคต อย่าลืมเปลี่ยนเลข version
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // 2. ปรับฟังก์ชันสร้างตารางให้เรียกใช้จาก Schema
  Future _createDB(Database db, int version) async {
    await db.execute(DatabaseSchema.createUsersTable);
    
    // ถ้ามีหลายตาราง ก็ใส่ต่อกันได้เลย
    // await db.execute(DatabaseSchema.createIngredientsTable);
  }

  // ตัวอย่างการใช้ชื่อตารางจาก Schema ในฟังก์ชันต่างๆ
  Future<void> saveUser(User user) async {
    final db = await instance.database;
    await db.insert(
      DatabaseSchema.tableUsers, // ใช้ค่าคงที่แทนการพิมพ์ 'users'
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );   
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      DatabaseSchema.tableUsers,
      where: '${DatabaseSchema.colEmail} = ?', // ปลอดภัยกว่าการพิมพ์สตริงเอง
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}