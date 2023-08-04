import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_users_flutter/data/network/networking_client.dart';
import 'package:test_users_flutter/data/sql_db/SqlDbRepository.dart';
import 'package:test_users_flutter/helpers/constants.dart';
import 'package:test_users_flutter/model/Data.dart';
import 'package:test_users_flutter/model/UserModel.dart';
import 'package:test_users_flutter/model/detail/DetailUserModel.dart';

import 'api_services.dart';

class ApiRepositories implements ApiServicesNet {
  ApiRepositories({
    this.networkingClient,
  });

  NetworkingClient? networkingClient;

  @override
  Future<UserModel> getUsers(int page) async {
    var answer = UserModel();
    try {
      Response response = await NetworkingClient().get(
        '${BaseUrl.BASE_URL}${EndPoint.users}?page=$page',
      );
      answer = UserModel.fromJson(response.data);
      //await SqlDbRepository.instance.insertUser(answer);
    } catch (e) {
      print(e);
    }
    return answer;
  }

  @override
  Future<DetailUserModel> getUser(String id) async {
    var answer = DetailUserModel();
    try {
      Response response = await NetworkingClient().get(
        BaseUrl.BASE_URL + EndPoint.users + id,
      );
      answer = DetailUserModel.fromJson(response.data);
    } catch (e) {
      print(e);
    }
    return answer;
  }


// Future<void> saveUserToDB(List<Data> users) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   List<Data> listData = List.empty(growable: true);
//   for (var d in users) {
//     listData.add(Data(
//         id: d.id,
//         firstName: d.firstName,
//         lastName: d.lastName,
//         email: d.email,
//         avatar: await savePhoto(d.avatar.toString())
//     ));
//     String userJson = jsonEncode(d.toJson());
//     await prefs.setString(d.id.toString(), userJson);
//   }
//
//   // var u = UserModel(
//   //     page: user.page,
//   //     perPage: user.perPage,
//   //     total: user.total,
//   //     totalPages: user.totalPages,
//   //     support: user.support,
//   //     data: listData
//   // );
//
// }

}
