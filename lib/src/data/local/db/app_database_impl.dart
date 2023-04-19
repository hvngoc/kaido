import 'package:path/path.dart';
import 'package:propzy_home/src/data/local/db/app_database.dart';
import 'package:propzy_home/src/domain/model/city.dart';
import 'package:propzy_home/src/domain/model/district.dart';
import 'package:propzy_home/src/domain/model/street.dart';
import 'package:propzy_home/src/domain/model/ward.dart';
import 'package:sprintf/sprintf.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabaseImpl extends AppDatabase {
  static final String DB_NAME = "propzy.app.db";
  static final int DB_VERSION = 1;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDb();
    return _db!;
  }

  _initDb() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    var db = await openDatabase(path, version: DB_VERSION, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    final createDistrict = sprintf(
        "CREATE TABLE %s (%s INTEGER PRIMARY KEY, %s INTEGER, %s INTEGER, %s INTEGER, %s INTEGER,"
        " %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT)",
        [
          "District",
          "districtId",
          "countryId",
          "regionId",
          "cityId",
          "orders",
          "districtName",
          "districtShortName",
          "districtNameEn",
          "districtNameEnLower",
          "districtNameLower",
          "districtShortNameLower",
          "districtSlug"
        ]);
    final createWard = sprintf(
      "CREATE TABLE %s (%s INTEGER PRIMARY KEY, %s INTEGER, %s INTEGER, %s INTEGER, %s INTEGER,"
      " %s TEXT, %s INTEGER, %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT, %s TEXT,"
      " %s DOUBLE, %s DOUBLE)",
      [
        "Ward",
        "wardId",
        "countryId",
        "regionId",
        "cityId",
        "districtId",
        "districtName",
        "orders",
        "wardName",
        "wardShortName",
        "wardNameEn",
        "wardNameEnLower",
        "wardNameLower",
        "wardShortNameLower",
        "wardSlug",
        "latitude",
        "longitude",
      ],
    );
    final createStreet = sprintf(
      "CREATE TABLE %s (%s INTEGER PRIMARY KEY, %s INTEGER, %s INTEGER, %s INTEGER, %s INTEGER,"
      " %s INTEGER, %s TEXT, %s TEXT, %s TEXT, %s DOUBLE, %s DOUBLE)",
      [
        "Street",
        "streetId",
        "countryId",
        "regionId",
        "cityId",
        "districtId",
        "wardId",
        "streetName",
        "streetNameEn",
        "streetSlug",
        "latitude",
        "longitude",
      ],
    );
    await db.execute(createDistrict);
    await db.execute(createWard);
    await db.execute(createStreet);
  }

  @override
  Future<List<District>?> getListDistrict(int city) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("District", where: "cityId = ?", whereArgs: [city]);
    if (res.isNotEmpty == true) {
      return res.map((e) => District.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  @override
  Future<bool> hasDistrict() async {
    final database = await db;
    var x = await database.rawQuery('SELECT COUNT (*) from District');
    final count = Sqflite.firstIntValue(x) ?? 0;
    return count > 0;
  }

  @override
  Future<District?> getDistrict(int id) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("District", where: "districtId = ?", whereArgs: [id]);
    if (res.isNotEmpty == true) {
      final first = res.first;
      return District.fromJson(first);
    } else {
      return null;
    }
  }

  @override
  Future<List<Ward>?> getListWards(int district) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("Ward", where: "districtId = ?", whereArgs: [district]);
    if (res.isNotEmpty == true) {
      return res.map((e) => Ward.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<Street>?> getListStreets(int wardId) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("Street", where: "wardId = ?", whereArgs: [wardId]);
    if (res.isNotEmpty == true) {
      return res.map((e) => Street.fromJson(e)).toList();
    } else {
      return null;
    }
  }

  @override
  Future<bool> hasWard() async {
    final database = await db;
    var x = await database.rawQuery('SELECT COUNT (*) from Ward');
    final count = Sqflite.firstIntValue(x) ?? 0;
    return count > 0;
  }

  @override
  Future<Ward?> getWard(int id) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("Ward", where: "wardId = ?", whereArgs: [id]);
    if (res.isNotEmpty == true) {
      final first = res.first;
      return Ward.fromJson(first);
    } else {
      return null;
    }
  }

  @override
  Future<void> insertDistricts(List<District> list) async {
    final database = await db;
    final batch = database.batch();
    list.forEach((child) {
      batch.insert(
        'District',
        child.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit(noResult: true);
  }

  @override
  Future<void> insertStreets(List<Street> list) async {
    final database = await db;
    final batch = database.batch();
    list.forEach((child) {
      batch.insert(
        'Street',
        child.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit(noResult: true);
  }

  @override
  Future<bool> hasStreet() async {
    final database = await db;
    var x = await database.rawQuery('SELECT COUNT (*) from Street');
    final count = Sqflite.firstIntValue(x) ?? 0;
    return count > 0;
  }

  @override
  Future<void> insertWards(List<Ward> list) async {
    final database = await db;
    final batch = database.batch();
    list.forEach((child) {
      batch.insert(
        'Ward',
        child.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
    batch.commit(noResult: true);
  }

  @override
  Future<Street?> getStreetById(int streetId) async {
    final database = await db;
    final List<Map<String, dynamic>> res =
        await database.query("Street", where: "streetId = ?", whereArgs: [streetId]);
    if (res.isNotEmpty == true) {
      final first = res.first;
      return Street.fromJson(first);
    } else {
      return null;
    }
  }
}
