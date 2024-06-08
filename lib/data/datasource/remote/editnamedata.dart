import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class EditNameData {
  Crud crud;
  EditNameData(this.crud);
  postdata(String name,String surename ,String phone,String gender) async {
    var response = await crud.postData(AppLink.updatename, {
      "name" : name , 
      "surename" : surename, 
      "phone" : phone, 
      "gender" : gender, 
    });
    return response.fold((l) => l, (r) => r);
  }
}