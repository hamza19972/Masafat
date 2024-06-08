import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class Tripv2Data {
  Crud crud;
  Tripv2Data(this.crud);
  getData(int userID) async {
    var response = await crud.postData(AppLink.mytripsv2, {
     "passenger_id":userID.toString()
    });
    return response.fold((l) => l, (r) => r);
  }

   canceleData(int id) async {
    var response = await crud.postData(AppLink.canceltripv2, {
     "id":id.toString()
    });
    return response.fold((l) => l, (r) => r);
  }
}
