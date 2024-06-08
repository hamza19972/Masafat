import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class WelcomeData {
  Crud crud;
  WelcomeData(this.crud);
  postdata(String phone,) async {
    var response = await crud.postData(AppLink.welcome, {
      "phone" : phone , 
    });
    return response.fold((l) => l, (r) => r);
  }
}
