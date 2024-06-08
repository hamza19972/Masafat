import 'package:masafat/core/class/statusrequest.dart';
import 'package:flutter/material.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataView(
      {Key? key, required this.statusRequest, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? const Center(
            child: CircularProgressIndicator(color: Colors.green,))
            //  Lottie.network(AppImageAsset.loading, width: 250, height: 250))
        : statusRequest == StatusRequest.offlinefailure
            ? const Center(
                child: Text("offlinefailure"))
                // Lottie.network(AppImageAsset.offline,width: 250, height: 250))
            : statusRequest == StatusRequest.serverfailure
                ? const Center(
                    child: Text("serverfailure"))
                    // Lottie.network(AppImageAsset.server, width: 250, height: 250))
                : statusRequest == StatusRequest.failure
                    ? const Center(
                        child:Text("no data"))
                        //  Lottie.network(AppImageAsset.noData,width: 250, height: 250, repeat: true))
                    : widget;
  }
}

class HandlingDataRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  const HandlingDataRequest(
      {Key? key, required this.statusRequest, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? const Center(
            child: Text("loading..."))
            // Lottie.asset(AppImageAsset.loading, width: 250, height: 250))
        : statusRequest == StatusRequest.offlinefailure
            ? const Center(
                child: Text("offlinefailure")) 
                // Lottie.asset(AppImageAsset.offline,
                //     width: 250, height: 250))
            : statusRequest == StatusRequest.serverfailure
                ? const Center(
                    child: Text("serverfailure"))
                    // Lottie.asset(AppImageAsset.server,
                    //     width: 250, height: 250))
                : widget;
  }
}
