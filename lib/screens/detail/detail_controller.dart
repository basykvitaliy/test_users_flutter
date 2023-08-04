
import 'dart:convert';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:test_users_flutter/data/network/networking_client.dart';
import 'package:test_users_flutter/data/repositories/api_repositories.dart';
import 'package:test_users_flutter/data/sql_db/SqlDbRepository.dart';
import 'package:test_users_flutter/model/detail/DetailData.dart';
import 'package:test_users_flutter/model/detail/DetailUserModel.dart';

class DetailController extends GetxController{
  static DetailController get to => Get.find();

  DetailUserModel model = DetailUserModel();
  Uint8List? photoBytes;
  RxBool isConnect = false.obs;


  Future<DetailUserModel?> getUserDataById(String id)async{
    final isConnected = await NetworkingClient().checkConnectivity();
    if (isConnected) {
      isConnect.value = true;
      return await ApiRepositories().getUser(id);
    } else {
      isConnect.value = false;
      var d = await SqlDbRepository.instance.getUserDataById(id);
      photoBytes = base64Decode(d!.avatar!);
      var m = DetailUserModel(
        data: DetailData(
          id: d.id,
          firstName: d.firstName,
          lastName: d.lastName,
          email: d.email,
        ),
        support: null
      );
      return m;
    }
  }

  Future<DetailUserModel> getUser(String id)async{
    return await ApiRepositories().getUser(id);
  }
  Uint8List decodeAvatar(String base64Avatar) {
    return base64Decode(base64Avatar);
  }
}
