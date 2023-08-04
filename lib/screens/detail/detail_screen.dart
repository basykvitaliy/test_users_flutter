
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_users_flutter/model/detail/DetailUserModel.dart';
import 'package:test_users_flutter/screens/detail/detail_controller.dart';

class DetailScreen extends GetView<DetailController> {
  DetailScreen( {Key? key, required this.id}) : super(key: key);
  String id;
  @override
  var controller = Get.put(DetailController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future:  controller.getUserDataById(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var user = snapshot.data as DetailUserModel;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    controller.isConnect.value ? Image.network(user.data!.avatar.toString()) : Image.memory(controller.photoBytes!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Id: ", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                        Text(user.data!.id.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(user.data!.firstName.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                        SizedBox(width: 8),
                        Text(user.data!.lastName.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                      ],
                    ),

                    Text(user.data!.email.toString()),
                  ],
                ),
              );
            }
          }),
    );
  }
}


