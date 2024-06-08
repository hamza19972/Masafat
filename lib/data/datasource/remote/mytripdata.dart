import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class MyTripData {
  Crud crud;
  MyTripData(this.crud);
  getData(int userid) async {
    var response = await crud.postData(AppLink.mytripuser, {
      "userid":userid.toString()
    });
    return response.fold((l) => l, (r) => r);
  }

  cancelTrip(int userid,int requestId) async {
    var response = await crud.postData(AppLink.canceltrip, {
      "userId":userid.toString(),
      "requestId":requestId.toString()
    });
    return response.fold((l) => l, (r) => r);
  }

  driverview(int driverid) async {
    var response = await crud.postData(AppLink.driverview, {
      "driverid":driverid.toString(),
    });
    return response.fold((l) => l, (r) => r);
  }
}
