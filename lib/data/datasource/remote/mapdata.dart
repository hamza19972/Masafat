import 'package:masafat/core/class/crud.dart';
import 'package:masafat/linkapi.dart';

class MapData {
  Crud crud;
  MapData(this.crud);
  postdata(String userid,String dropoff ,String pickup,String time,String date,String seats,String price,String pickupName,String dropoffName,String gender) async {
    var response = await crud.postData(AppLink.riderequest, {
      "userid" : userid , 
      "dropoff" : dropoff, 
      "pickup" : pickup, 
      "time" : time, 
      "date" : date, 
      "seats" : seats.toString(), 
      "price" : price.toString(), 
      "pickupName" : pickupName, 
      "dropoffName" : dropoffName, 
      "gender" : gender.toString(), 
    });
    return response.fold((l) => l, (r) => r);
  }

  
}