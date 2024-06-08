import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masafat/controller/mapdropoff_controller.dart';
import 'package:masafat/core/class/statusrequest.dart';

class MapDropOff extends StatelessWidget {
  final MapControllerDropOff mapController = Get.put(MapControllerDropOff());
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (mapController.statusRequest.value == StatusRequest.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (mapController.statusRequest.value == StatusRequest.failure) {
          return Center(child: Text('92'.tr));
        } else {
          return Stack(
            children: [
              Obx(() {
                return GoogleMap(
                  zoomControlsEnabled: false,
                  initialCameraPosition: mapController.cameraPosition.value,
                  onMapCreated: (GoogleMapController controller) {
                    mapController.completercontroller.complete(controller);
                  },
                  onCameraMove: (CameraPosition position) {
                    mapController.updateCameraPosition(position);
                  },
                  onCameraIdle: () {
                    mapController.updateLocation(mapController.cameraPosition.value.target);
                  },
                );
              }),
              const Center(
                child: Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Colors.red,
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showSearch(
                            context: context,
                            delegate: DataSearch(_places),
                          );
                          if (result != null) {
                            print('Selected place: $result');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  '93'.tr,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '99'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle the selection confirmation
                            mapController.getTrips();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            '95'.tr,
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class DataSearch extends SearchDelegate<String?> {
  final GoogleMapsPlaces placesService;

  DataSearch(this.placesService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query == "") {
            close(context, null);
          } else {
            query = ""; // Clear the search query
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // You can show the selected place's details or navigate the map to the selected place
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final MapControllerDropOff mapController = Get.find<MapControllerDropOff>();

    if (query.isNotEmpty) {
      return FutureBuilder(
        future: placesService.searchByText(query),
        builder: (context, AsyncSnapshot<PlacesSearchResponse> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.status == "OK") {
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                title: Text(snapshot.data!.results[index].name),
                subtitle: Text(snapshot.data!.results[index].formattedAddress ?? ''), // Optional: Display address
                onTap: () async {
                  final lat = snapshot.data!.results[index].geometry!.location.lat;
                  final lng = snapshot.data!.results[index].geometry!.location.lng;

                  LatLng newLocation = LatLng(lat, lng);
                  mapController.updateLocation(newLocation);
                  mapController.updateCameraPosition(CameraPosition(target: newLocation, zoom: 15));

                  final GoogleMapController googleMapController = await mapController.completercontroller.future;
                  googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newLocation, zoom: 15)));

                  close(context, snapshot.data!.results[index].name);
                },
              ),
              itemCount: snapshot.data!.results.length,
            );
          } else {
            return  Center(child: Text("96".tr));
          }
        },
      );
    } else {
      return  Center(child: Text("97".tr));
    }
  }
}
