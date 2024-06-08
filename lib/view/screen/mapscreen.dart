import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:masafat/controller/mapscreen_controller.dart';



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
    final MapControllerPickup controller = Get.find<MapControllerPickup>();

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
                subtitle: Text(snapshot.data!.results[index].formattedAddress ??
                    ''), // Optional: Display address
                onTap: () async {
                  final GoogleMapController mapController =
                      await controller.completercontroller.future;

                  final lat =
                      snapshot.data!.results[index].geometry!.location.lat;
                  final lng =
                      snapshot.data!.results[index].geometry!.location.lng;

                  final CameraPosition position = CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 15, // Adjust zoom level as needed
                  );

                  mapController
                      .animateCamera(CameraUpdate.newCameraPosition(position));

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

class MapScreenPickUp extends StatelessWidget {
  final MapControllerPickup controller = Get.put(MapControllerPickup());

   MapScreenPickUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
            
    onMapCreated: (GoogleMapController googleMapController) {
      controller.completercontroller.complete(googleMapController);
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: controller.currentLocation.value!, zoom: 15),
        ),
      );
    },
    initialCameraPosition: CameraPosition(
      target: controller.currentLocation.value,  // Ensuring initial position is set
      zoom: 15,
    ),
    markers: {
      Marker(
        markerId: MarkerId('m1'),
        position: controller.currentLocation.value,  // Marker uses the controller's current location
        icon: controller.markerIcon.value ?? BitmapDescriptor.defaultMarker,
        draggable: true,  // Allowing the marker to be draggable
        onDragEnd: (newPosition) {
          controller.updateLocation(newPosition);  // Updating location on drag end
        },
      ),
    },
    onCameraMove: (CameraPosition position) {
      // This can be used to update a position indicator or similar
    },
  )),
          _buildBackButton(context),
          _buildSearchBar(context, 'From', 40, () {
            // Custom action for 'From' search bar
            showSearch(
              context: context,
              delegate: DataSearch(GoogleMapsPlaces(apiKey: "")),
            );
          }),
          _buildSearchBar(context, 'To', 90, () {
            // Custom action for 'To' search bar
            showSearch(
              context: context,
              delegate: DataSearch(GoogleMapsPlaces(apiKey: "")),
            );
          }),
          _buildSetPickupButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      child: FloatingActionButton(
        mini: true,
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.white,
        child: Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, String hint, double topOffset, VoidCallback onTap) {
    return Positioned(
      top: topOffset,
      left: 60,
      right: 10,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 2.0),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.black),
              SizedBox(width: 10),
              Text(
                hint,
                style: TextStyle(
                    color: Colors.black.withOpacity(0.5), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetPickupButton(BuildContext context) {
  final MapControllerPickup controller = Get.find<MapControllerPickup>();
  return Positioned(
    bottom: 30,
    left: 20,
    right: 20,
    child: Obx(() {
      String buttonText = controller.pickup.value == null ? 'Set Pickup Point' : 'Set Drop-off Point';
      return ElevatedButton(
        onPressed: () {
          if (controller.pickup.value == null) {
            // Perhaps add logic here to ensure a default pickup is set if none has been dragged
          } else if (controller.dropoff.value == null) {
            // Ensure that if there's no drop-off set by dragging, set it now
            controller.dropoff.value = controller.pickup.value;  // Optional: set drop-off as pickup if not set
          }
        },
        child: Text(buttonText, style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
    }),
  );
}

}
