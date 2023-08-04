import 'dart:async';

import 'package:test_users_flutter/model/UserModel.dart';
import 'package:test_users_flutter/model/detail/DetailUserModel.dart';



abstract class ApiServicesNet {
  Future<UserModel> getUsers(int page);
  Future<DetailUserModel> getUser(String id);

}
