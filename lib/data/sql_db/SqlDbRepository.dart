import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_users_flutter/helpers/constants.dart';
import 'package:test_users_flutter/model/UserModel.dart';

import '../../model/Data.dart';


class SqlDbRepository {
  static final SqlDbRepository instance = SqlDbRepository._instance();
  static Database? _db;
  SqlDbRepository._instance();

  AuthStatus? _status = AuthStatus.unknown;

  /// User model.
  String userTable = "user_table";
  String colId = "id";
  String colPage = "page";
  String colPerPage = "per_page";
  String colTotal = "total";
  String colTotalPages = "total_pages";
  String colData = "data";
  String colSupport = "support";
  /// User model.


  Future<Database> get db async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    //String path = dir.path + "db";
    String path = p.join(dir.toString(),"db");
    final table = await openDatabase(path, version: 1, onCreate: _onCreate);
    return table;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $userTable("
        "$colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colPage INTEGER, "
        "$colPerPage INTEGER, "
        "$colTotal INTEGER, "
        "$colTotalPages INTEGER, "
        "$colData TEXT, "
        "$colSupport TEXT) "
    );

  }

  Future<UserModel?> getUsers(int nextPage) async {
    try {
      Database db = await this.db;
      final List<Map<String, dynamic>> userModelMap = await db.query(userTable);

      if (userModelMap.isNotEmpty) {
        var element = userModelMap[nextPage];

        List<Data> dataList = (jsonDecode(element[colData]) as List)
            .map((network) => Data.fromJson(network))
            .toList();


        UserModel user = UserModel(
          page: element[colPage],
          data: dataList,
          perPage: element[colPerPage],
          total: element[colTotal],
          totalPages: element[colTotalPages],
        );

        return user;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Data?> getUserDataById(String userId) async {
    try {
      Database db = await this.db;
      final List<Map<String, dynamic>> userModelMap = await db.query(
        userTable
      );

      if (userModelMap.isNotEmpty) {
        var element = userModelMap.first;

        List<Data> dataList = (jsonDecode(element[colData]) as List)
            .map((network) => Data.fromJson(network))
            .toList();

        Data? userData = dataList.firstWhere((data) => data.id.toString() == userId);
        return userData;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<AuthStatus> insertUser(UserModel userModel) async {
    Database db = await this.db;
    List<Data> listData = List.empty(growable: true);
    Map<String, dynamic> user = userModel.toJson();
    for(var u in userModel.data!){
      listData.add(Data(
                id: u.id,
          firstName: u.firstName,
          lastName: u.lastName,
          email: u.email,
          avatar: await savePhoto(u.avatar.toString())
      ));
    }
    user[colData] = jsonEncode(listData);

    final result = await db.insert(userTable, user);

    if(result != null){
      _status = AuthStatus.successful;
    }else{
      _status = AuthStatus.error;
    }
    print("Save user");
    return _status!;
  }

  Future<void> deleteAllUser() async {
    Database db = await this.db;
    await db.delete(userTable);
  }

  Future<String> savePhoto(String imageUrl) async {
    Uint8List photoBytes = await getPhotoBytes(imageUrl);
    String base64Photo = base64Encode(photoBytes);
    return base64Photo;
  }

  Future<Uint8List> getPhotoBytes(String imageUrl) async {
    try {
      Dio dio = Dio();
      Response<Uint8List> response = await dio.get<Uint8List>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      return response.data!;
    } catch (e) {
      print(e);
      throw e;
    }
  }}

