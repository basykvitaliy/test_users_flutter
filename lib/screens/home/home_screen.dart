
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_users_flutter/screens/detail/detail_screen.dart';
import 'package:test_users_flutter/widget/button_loading_widget.dart';

import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  @override
  var controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: controller.isConnect.value ? Colors.green : Colors.red,
                ),
                SizedBox(width: 4,),
                Text(controller.isConnect.value ? "Online" : "Offline")
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body:Obx((){
        if (controller.currentPage.value <= controller.perPage) {
          return ListView.builder(
            itemCount: controller.userList.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.userList.length) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: ButtonLoadingWidget(
                    height: 40,
                    onTap: ()async{
                      await controller.loadNextPage();
                    },
                    textButton: 'Завантажити більше', isChangeBtn: true, isDisabledBtn: true, large: controller.isAnimBtn.value,
                  ),
                );
              } else {
                return OpenContainer(
                  transitionType: _transitionType,
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return DetailScreen(id: controller.userList[index].id.toString());
                  },
                  closedElevation: 0.0,
                  closedColor: Colors.white,
                  closedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  transitionDuration: const Duration(milliseconds: 700),
                  closedBuilder: (BuildContext context, VoidCallback openContainer) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          controller.isConnect.value ? Image.network(controller.userList[index].avatar.toString()): Image.memory(controller.listData[index]),
                          SizedBox(width: 24),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(controller.userList[index].firstName.toString()),
                                  const SizedBox(width: 4),
                                  Text(controller.userList[index].lastName.toString()),
                                ],
                              ),
                              Text(controller.userList[index].email.toString())
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            },
          );
        } else {
          return Center(child: Text('Всі дані завантажено'));
        }
      })
    );
  }
}
