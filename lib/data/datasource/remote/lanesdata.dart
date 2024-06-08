import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class LanesData {
  Crud crud;
  LanesData(this.crud);
  getData() async {
    var response = await crud.postData(AppLink.cites, {});
    return response.fold((l) => l, (r) => r);
  }

  getRoutes(String start, String end) async {
    var response =
        await crud.postData(AppLink.routes, {"start": start, "end": end});
    return response.fold((l) => l, (r) => r);
  }

  getTrips(String routeID, String gender,int seats) async {
    var response = await crud
        .postData(AppLink.trips, {"routeID": routeID, "gender": gender,"seats":seats.toString()});
    return response.fold((l) => l, (r) => r);
  }

  sendData(String tripID, String gender,String id,
      String phone, String driverId, String pickup,String dropoff,int seats,double price,String name,String voucher) async {
    var response = await crud.postData(AppLink.bookingsb, {
      "trip_id": tripID,
      "gender": gender,
      "passenger_id": id,
      "user_phone": phone,
      "driverId": driverId,
      "pickup": pickup,
      "dropoff": dropoff,
      "seats_booked": seats.toString(),
      "price": price.toString(),
      "name": name,
      "voucher": voucher,
    });
    return response.fold((l) => l, (r) => r);
  }
}
