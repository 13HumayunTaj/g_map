import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as loc;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //

  LocationData? locationData;
  List<loc.Placemark>? placeMarkList;
  bool isLoading = false;

  void getLocationFunction() async {
    if (await Permission.location.isGranted) {
      //
      setState(() {
        isLoading = true;
      });
      locationData = await Location.instance.getLocation();
      locationData!.latitude;
      locationData!.longitude;
      setState(() {
        isLoading = false;
      });
      getAddressFunction(locationData!);
    } else {
      //
      Permission.location.request();
    }
  }

  void getAddressFunction(LocationData locationData) async {
    setState(() {
      isLoading = true;
    });
    placeMarkList = await loc.placemarkFromCoordinates(
        locationData.latitude!, locationData.longitude!);

    setState(() {
      isLoading = false;
    });
  }

// Function to open Google Maps with specific latitude and longitude
  // void openMap(double latitude, double longitude) async {
  //   String googleMapsUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  //   if (await canLaunch(googleMapsUrl)) {
  //     await launch(googleMapsUrl);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }

//   void openMap(double latitude, double longitude) async {
//   String googleMapsUrl =
//       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

//   if (await canLaunchUrl(googleMapsUrl)) {
//     await launchUrl(googleMapsUrl);
//   } else {
//     throw 'Could not open the map.';
//   }
// }

  // void openMap(double latitude, double longitude) async {
  //   String googleMapsUrl =
  //       'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

  //   try {
  //     Uri uri = Uri.parse(googleMapsUrl);

  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri);
  //     } else {
  //       throw 'Could not launch the map.';
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw 'An error occurred while opening the map.';
  //   }
  // }

  void openMap(double latitude, double longitude) async {
    String genericMapUrl = 'https://www.google.com';

    try {
      Uri uri = Uri.parse(genericMapUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch the map.';
      }
    } catch (e) {
      print('Error: $e');
      throw 'An error occurred while opening the map.';
    }
  }

  void openBrowser(String url) async {
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print('Error: $e');
      throw 'An error occurred while opening the URL.';
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Current Location'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        getLocationFunction();
                      },
                      child: Text(
                        'Get Location Button',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      locationData == null
                          ? 'Latitude: null'
                          : 'Latitude: ' + '${locationData!.latitude}',
                      style: TextStyle(fontSize: 18),
                    ),
                    //longitude
                    Text(
                      locationData == null
                          ? 'longitude: null'
                          : 'longitude: ' + '${locationData!.longitude}',
                      style: TextStyle(fontSize: 18),
                    ),

                    //
                    SizedBox(height: 50),
                    locationData != null
                        ? Text(
                            'Address: ${placeMarkList![0].street}, ${placeMarkList![0].subLocality}, ${placeMarkList![0].locality}, ${placeMarkList![0].administrativeArea}, ${placeMarkList![0].country}',
                            style: TextStyle(fontSize: 20),
                          )
                        : Text('data is null'),

                    //
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        // openMap(31.5953569,
                        //     74.3429118);

                        openBrowser('https://www.google.com');
                      },
                      child: Text('Open Google Maps'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
