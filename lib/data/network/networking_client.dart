import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/route_manager.dart';
import 'package:test_users_flutter/helpers/session.dart';

class NetworkingClient extends GetxService {
  NetworkingClient();
  bool skipErrorDisplay = true;
  Dio _dio = Dio();
  String _apiUrl = "https://api.contacts.design/api/";
  //factory NetworkingClient() => _instance;
  NetworkingClient.init(this._apiUrl) {
    // _dio = Dio(BaseOptions(
    //   baseUrl: _apiUrl,
    //   connectTimeout: 1000 * 30,
    //   receiveTimeout: 1000 * 30,
    //   headers: {
    //     'Content-Type': 'application/x-www-form-urlencoded',
    //     'Accept': 'application/json',
    //   },
    // ));
    // if (Session.authToken != null) setBearerToken(Session.authToken!);

    if (!kReleaseMode) _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        final contentLength = request.headers['Content-Length'];
      },
      onResponse: (resp, handler) async {
        if (resp == null || resp.data == null) throw 'Response is null!';
        final contentLength = resp.headers['Content-Length'];

        return resp.data;
      },
    ));
    //_instance = this;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, Object>? queryParameters,
  }) async {
    final isConnected = await checkConnectivity();
    if (!isConnected) throw checkConnectivity().toString();
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<bool> checkConnectivity() async {
    final bool isConnected = await isConnectedToInternet();
    if (!isConnected) {
      if (Get.isSnackbarOpen) {
        Get.back();
      }
      // Get.showSnackbar(const GetSnackBar(
      //   backgroundColor: Colors.red,
      //   message: "Connection Error!!!",
      //   titleText: Text("Error"),
      //   icon: Icon(
      //     Icons.warning_amber_rounded,
      //     color: Colors.transparent,
      //   ),
      // ));
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isConnectedToInternet() async {
    var connectivityResult =
        await (Connectivity().checkConnectivity().timeout(const Duration(seconds: 10), onTimeout: () {
      return ConnectivityResult.none;
    }));
    if (connectivityResult == ConnectivityResult.none) {
      ConnectionState.done;
      return false;
    }
    return true;
  }
}
