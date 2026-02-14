// core/database_schema.dart
class DatabaseSchema {
  // ชื่อตาราง
  static const String tableUsers = 'users';

  // ชื่อคอลัมน์ต่างๆ
  static const String colId = 'id';
  static const String colName = 'name';
  static const String colEmail = 'email';
  static const String colPassword = 'password';
  static const String colProvider = 'provider';

  // คำสั่งสร้างตาราง SQL
  static const String createUserTable = '''
    CREATE TABLE $tableUsers (
      $colId TEXT PRIMARY KEY,
      $colName TEXT,
      $colEmail TEXT UNIQUE,
      $colPassword TEXT,
      $colProvider TEXT
    )
  ''';
}