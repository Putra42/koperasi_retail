import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppUser {
  const AppUser({required this.id, required this.name, required this.identifier});

  final int id;
  final String name;
  final String identifier;
}

class DuplicateUserException implements Exception {
  const DuplicateUserException();
}

class AuthDatabase {
  AuthDatabase._();
  static final AuthDatabase instance = AuthDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final directory = await getDatabasesPath();
    _database = await openDatabase(
      p.join(directory, 'koperasi_retail.db'),
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          identifier TEXT NOT NULL UNIQUE,
          password_hash TEXT NOT NULL,
          password_salt TEXT NOT NULL,
          created_at TEXT NOT NULL
        )''');
        await db.execute('CREATE TABLE app_session (key TEXT PRIMARY KEY, value TEXT NOT NULL)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS app_session (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
          );
        }
      },
      onOpen: (db) async {
        // Repair databases created by an earlier build, even when their stored
        // schema version already matches the current version.
        await db.execute(
          'CREATE TABLE IF NOT EXISTS app_session (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
      },
    );
    return _database!;
  }

  String _hash(String password, String salt) => sha256.convert(utf8.encode('$salt:$password')).toString();

  Future<AppUser?> activeUser() async {
    final db = await database;
    final session = await db.query('app_session', where: 'key = ?', whereArgs: ['user_id'], limit: 1);
    if (session.isEmpty) return null;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [int.tryParse(session.first['value'] as String) ?? -1], limit: 1);
    return rows.isEmpty ? null : _userFromRow(rows.first);
  }

  Future<AppUser?> signIn(String identifier, String password) async {
    final db = await database;
    final rows = await db.query('users', where: 'identifier = ?', whereArgs: [identifier.trim().toLowerCase()], limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    final valid = _hash(password, row['password_salt'] as String) == row['password_hash'];
    if (!valid) return null;
    final user = _userFromRow(row);
    await _saveSession(user.id);
    return user;
  }

  Future<AppUser> register({required String name, required String identifier, required String password}) async {
    final db = await database;
    final normalizedIdentifier = identifier.trim().toLowerCase();
    final existing = await db.query(
      'users',
      where: 'identifier = ?',
      whereArgs: [normalizedIdentifier],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      final row = existing.first;
      final passwordMatches =
          _hash(password, row['password_salt'] as String) == row['password_hash'];
      if (!passwordMatches) throw const DuplicateUserException();
      final user = _userFromRow(row);
      await _saveSession(user.id);
      return user;
    }

    final salt = List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final saltText = base64UrlEncode(salt);
    try {
      final id = await db.transaction((txn) async {
        final userId = await txn.insert('users', {
          'name': name.trim(),
          'identifier': normalizedIdentifier,
          'password_hash': _hash(password, saltText),
          'password_salt': saltText,
          'created_at': DateTime.now().toIso8601String(),
        });
        await txn.insert(
          'app_session',
          {'key': 'user_id', 'value': '$userId'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return userId;
      });
      return AppUser(id: id, name: name.trim(), identifier: identifier.trim());
    } on DatabaseException catch (error) {
      if (error.toString().contains('UNIQUE constraint failed: users.identifier')) {
        throw const DuplicateUserException();
      }
      rethrow;
    }
  }

  Future<void> _saveSession(int userId) async {
    final db = await database;
    await db.insert('app_session', {'key': 'user_id', 'value': '$userId'}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> signOut() async {
    final db = await database;
    await db.delete('app_session', where: 'key = ?', whereArgs: ['user_id']);
  }

  AppUser _userFromRow(Map<String, Object?> row) => AppUser(
        id: row['id'] as int,
        name: row['name'] as String,
        identifier: row['identifier'] as String,
      );
}
