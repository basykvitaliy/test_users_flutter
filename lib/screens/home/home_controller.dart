
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_users_flutter/data/network/networking_client.dart';
import 'package:test_users_flutter/data/repositories/api_repositories.dart';
import 'package:test_users_flutter/data/sql_db/SqlDbRepository.dart';
import 'package:test_users_flutter/model/Data.dart';
import 'package:test_users_flutter/model/UserModel.dart';

class HomeController extends GetxController{
  static HomeController get to => Get.find();

  RxBool isConnect = false.obs;
  RxBool isAnimBtn = false.obs;
  List<Uint8List> listData = List.empty(growable: true);
  List<Data> userList = List.empty(growable: true);
  Uint8List? photoBytes;
  var currentPage = 0.obs;
  var perPage = 10;

  @override
  void onInit() {
    loadNextPage();
    super.onInit();
  }

  loadNextPage() async {
    isAnimBtn.value = true;
    var nextPage = currentPage.value + 1;
    var newData;
    final isConnected = await NetworkingClient().checkConnectivity();

    if (isConnected) {
      isConnect.value = true;
      newData = await ApiRepositories().getUsers(nextPage);
      await SqlDbRepository.instance.insertUser(newData);
      if (newData!.data!.isNotEmpty) {
        currentPage.value = nextPage;
        userList.addAll(newData.data!);
        isAnimBtn.value = false;
      }else{
        isAnimBtn.value = false;
        Get.showSnackbar(const GetSnackBar(
          titleText: Text("Увага!"),
          messageText: Text("Дані не надійшли"),
          snackPosition: SnackPosition.TOP,
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.grey,
        ));
      }
      return newData;
    } else {
      isConnect.value = false;
      newData = await SqlDbRepository.instance.getUsers(nextPage);
      for (var el in newData!.data!) {
        if (el.avatar != null) {
          photoBytes = base64Decode(el.avatar!);
          listData.add(photoBytes!);
        }
      }
      if (newData!.data!.isNotEmpty) {
        currentPage.value = nextPage;
        userList.addAll(newData.data!);
        isAnimBtn.value = false;
      }else{
        isAnimBtn.value = false;
        Get.showSnackbar(const GetSnackBar(
          titleText: Text("Увага!"),
          messageText: Text("Дані не надійшли"),
          snackPosition: SnackPosition.TOP,
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.grey,
        ));
      }
      return newData;
    }


  }

  // Future<UserModel?> getUsers(int nextPage) async {
  //   final isConnected = await NetworkingClient().checkConnectivity();
  //   if (isConnected) {
  //     isConnect.value = true;
  //     var result = await ApiRepositories().getUsers(nextPage);
  //     await SqlDbRepository.instance.insertUser(result);
  //     return result;
  //   } else {
  //     isConnect.value = false;
  //     var d = await SqlDbRepository.instance.getUsers(nextPage);
  //     for (var el in d!.data!) {
  //       if (el.avatar != null) {
  //         photoBytes = base64Decode(el.avatar!);
  //         listData.add(photoBytes!);
  //       }
  //     }
  //     return d;
  //   }
  // }

  Uint8List decodeAvatar(String base64Avatar) {
    return base64Decode(base64Avatar);
  }


}
