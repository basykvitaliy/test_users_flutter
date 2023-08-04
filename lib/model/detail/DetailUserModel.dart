import 'DetailData.dart';
import 'Support.dart';

class DetailUserModel {
  DetailData? data;
  Support? support;

  DetailUserModel({
      this.data, 
      this.support,});

  DetailUserModel.fromJson(dynamic json) {
    data = json['data'] != null ? DetailData.fromJson(json['data']) : null;
    support = json['support'] != null ? Support.fromJson(json['support']) : null;
  }


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    if (support != null) {
      map['support'] = support?.toJson();
    }
    return map;
  }

}