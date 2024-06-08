import 'package:flutter/material.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masafat/controller/finalmapcontroller.dart';
import 'package:masafat/core/class/handlingdataview.dart';

class FinalMap extends StatelessWidget {
  const FinalMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FinalMapController controllerpage = Get.put(FinalMapController());
    return Scaffold(
      appBar: AppBar(
        title: Text('13'.tr),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Trigger the search functionality here
              showSearch(
                  context: context,
                  delegate: DataSearch(controllerpage.places));
            },
          ),
        ],
      ),
      body: Container(
        child: GetBuilder<FinalMapController>(
            builder: ((controllerpage) => HandlingDataView(
                statusRequest: controllerpage.statusRequest,
                widget: Column(children: [
                  if (controllerpage.kGooglePlex != null)
                    Expanded(
                        child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GoogleMap(
                            zoomControlsEnabled: false,
                            polylines: controllerpage.polylines,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            mapType: MapType.normal,
                            markers: controllerpage.markers.toSet(),
                            onTap: (latlong) {
                              if (controllerpage.pickUp == null) {
                                controllerpage.addMarkersPickUp(latlong);
                              } else {
                                controllerpage.addMarkersDropOff(latlong);
                                controllerpage.calculateFaretow(
                                    controllerpage.pickUpPrice!,
                                    controllerpage.dropOffPrice!);
                              }
                            },
                            initialCameraPosition: controllerpage.kGooglePlex!,
                            onMapCreated: (GoogleMapController controllermap) {
                              if (!controllerpage
                                  .completercontroller!.isCompleted) {
                                controllerpage.completercontroller!
                                    .complete(controllermap);
                              }
                            }),
                        DraggableScrollableSheet(
                          initialChildSize:
                              0.3, // Initial height of the sheet while opening
                          minChildSize:
                              0.1, // Minimum height of the sheet when user drags down
                          maxChildSize:
                              0.5, // Maximum height of the sheet when user drags up
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return Container(
                                padding: const EdgeInsets.all(
                                    16), // Add some padding around our sheet
                                decoration: const BoxDecoration(
                                  color: Colors
                                      .white, // Background color of the sheet
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        20), // Rounded corners at the top
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: ListView(
                                    controller: scrollController,
                                    children: [
                                      Center(
                                        child: Text(
                                          "54".tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Divider(),
                                      controllerpage.placemarksPickUp != null
                                          ? ListTile(
                                              leading: const Icon(Icons.location_on,
                                                  color: Colors
                                                      .green), // Pickup Icon
                                              title: Text("18".tr),
                                              subtitle: Text(
                                                  "${controllerpage.placemarksPickUp![0].locality}"),
                                            )
                                          : ListTile(
                                              leading: const Icon(Icons.location_on,
                                                  color: Colors
                                                      .grey), // Greyed out icon
                                              title: Text("18".tr),
                                              subtitle: Text("19"
                                                  .tr), // Displayed when placemarksPickUp is null
                                            ),

                                      // Displaying Dropoff Address
                                      controllerpage.placemarksDropOff != null
                                          ? ListTile(
                                              leading: const Icon(Icons.location_on,
                                                  color: Colors
                                                      .red), // Dropoff Icon
                                              title: Text("17".tr),
                                              subtitle: Text(
                                                  "${controllerpage.placemarksDropOff![0].locality}"),
                                            )
                                          : ListTile(
                                              leading: const Icon(Icons.location_on,
                                                  color: Colors
                                                      .grey), // Greyed out icon
                                              title: Text("17".tr),
                                              subtitle: Text("20".tr),
                                            ),

                                      // Displaying Estimated Price
                                      ListTile(
                                        leading: const Icon(Icons
                                            .price_check_sharp), // Price Icon
                                        title: Text("16".tr),
                                        subtitle: Text(
                                          controllerpage.totalFare != null
                                              ? "${double.parse(controllerpage.totalFare!.toStringAsFixed(2)) * (controllerpage.selectedSeats)} JOD"
                                              : "15".tr,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // Seats selection
                                      ListTile(
                                        title: Text("46".tr),
                                        trailing: DropdownButton<int>(
                                          value: controllerpage.selectedSeats,
                                          icon: const Icon(Icons.arrow_drop_down),
                                          onChanged: (int? newValue) {
                                            controllerpage
                                                .setSelectedSeats(newValue!);
                                          },
                                          items: <int>[1, 2, 3, 4]
                                              .map<DropdownMenuItem<int>>(
                                                  (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            );
                                          }).toList(),
                                        ),
                                      ),

                                      // Continue button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Expanded widget used to give the ElevatedButton a flexible width
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                // Perform action when Continue is pressed
                                                if (controllerpage
                                                        .selectedTime.isEmpty ||
                                                    controllerpage.dropoff ==
                                                        null) {
                                                  Get.snackbar("44".tr,
                                                      "45".tr);
                                                } else {
                                                  controllerpage.continueAction();
                                                }
                                              },
                                              child: Text("8".tr),
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .primaryColor, // Background color
                                                onPrimary:
                                                    Colors.white, // Text color
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  8), // Spacing between the buttons
                                          IconButton(
                                            icon: const Icon(Icons.access_time_sharp),
                                            color: Theme.of(context)
                                                .primaryColor, // Icon color
                                            onPressed: () {
                                              // Perform action when this IconButton is pressed
                                              // For example, show a date picker or another dialog
                                              controllerpage
                                                  .showDatePickertow();
                                            },
                                            iconSize: 30,
                                          ),
                                        ],
                                      ),
                                    ]));
                          },
                        )
                      ],
                    ))
                ])))),
      ),
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

  Widget buildSuggestions(BuildContext context) {
        FinalMapController controllerpage = Get.put(FinalMapController());

  // The search happens as the user types
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
                // Assuming you have access to GoogleMapController
                final GoogleMapController mapController = await controllerpage.completercontroller!.future;

                // Get latitude and longitude of the selected place
                final lat = snapshot.data!.results[index].geometry!.location.lat;
                final lng = snapshot.data!.results[index].geometry!.location.lng;

                // Create a new CameraPosition
                final CameraPosition position = CameraPosition(
                  target: LatLng(lat, lng),
                  zoom: 15, // Adjust zoom level as needed
                );

                // Move and zoom the map to the selected place
                mapController.animateCamera(CameraUpdate.newCameraPosition(position));

                // Optionally close the search with the selected place name or any other relevant data
                close(context, snapshot.data!.results[index].name);
              },
            ),
            itemCount: snapshot.data!.results.length,
          );
        } else {
          return const Center(child: Text("No results found."));
        }
      },
    );
  } else {
    return const Center(child: Text("Start typing to search"));
  }
}}