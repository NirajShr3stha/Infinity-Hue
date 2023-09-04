import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Img_discover extends StatefulWidget {
  const Img_discover({Key? key}) : super(key: key);

  @override
  State<Img_discover> createState() => _Img_discoverState();
}

// -- NSFW API --
class _Img_discoverState extends State<Img_discover> {
  final ScrollController _scrollController = ScrollController();
  final imagess = <Uint8List>[];
  List images = <String>[];

  bool _isLoading = false;
  int page = 1;

  // Method to fetch images from the Civitai API
  Future<void> fetchImages(
      {int limit = 20, int page = 1, String query = "dragon"}) async {
    setState(() {
      _isLoading = true;
    });

    // Set the base URL for the Civitai API
    final base_url = "https://civitai.com/api/v1";
    print(limit.toString() + "   " + page.toString());

    // Set the endpoint for the images
    final endpoint = "/images";

    // Create the query parameters map
    final params = {
      "limit": limit.toString(),
      "page": page.toString(),
      "query": query,
    };

    // Build the query string from the params map
    final queryString = Uri(queryParameters: params).query;

    // Make the GET request to the Civitai API
    final response =
        await http.get(Uri.parse("$base_url$endpoint?$queryString"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imagesss = await processData(data["items"]);

      setState(() {
        images.addAll(imagesss.cast<String>());
        _isLoading = false;
      });
    } else {
      print("An error occurred while fetching data from the Civitai API");
      print(response.statusCode);
      setState(() {
        _isLoading = false;
      });
    }
  }

  static void processChunk(List args) async {
    final sendPort = args[0] as SendPort;
    final chunk = args[1] as List;
    final images = [];
    for (final model in chunk) {
      final response = await http.get(Uri.parse(model['url']));
      final contentType = response.headers['content-type'];
      if (contentType == 'image/jpeg' ||
          contentType == 'image/png' ||
          contentType == 'image/webp') {
        images.add(model['url']);
        FastCachedImage(url: model['url']);
      } else {
        print("video found");
        print(model['url']);
      }
    }
    sendPort.send(images);
  }

  // Function to process the data using isolates
  Future<List> processData(List data) async {
    // Number of isolates to use
    final numIsolates = 4;
    // Divide the data into chunks
    final chunkSize = (data.length / numIsolates).ceil();
    final chunks = List.generate(
        numIsolates, (i) => data.sublist(i * chunkSize, (i + 1) * chunkSize));
    // Create a list to store the results
    final results = [];
    // Create a list to store the receive ports
    final receivePorts = [];
    for (int i = 0; i < numIsolates; i++) {
      // Create a receive port
      final receivePort = ReceivePort();
      receivePorts.add(receivePort);
      // Spawn an isolate
      await Isolate.spawn(processChunk, [receivePort.sendPort, chunks[i]]);
    }
    // Wait for all isolates to finish
    final messages = await Future.wait(receivePorts.map((port) => port.first));
    for (final message in messages) {
      results.addAll(message);
    }
    return results;
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          page < 6) {
        setState(() {
          _isLoading = true;
          print(images.length.toString() + "image number");
          page++;
          fetchImages(page: page);
          if(page == 2){
            print(images);
          }
        });
      }
      else if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          page < 6) {
        setState(() {
          _isLoading = true;
          print(images.length.toString() + "image number");
          page++;
          fetchImages(page: page);
          if(page == 2){
            print(images);
          }
        });
      }
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Community Showcase'),
    ),
    body: Stack(
      children: [
        GridView.builder(
          controller: _scrollController,
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(3.5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageFullScreen(imageUrl: images[index]),
                  ),
                );
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 1, sigmaY: 1.5),
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                        Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child:
                                    FastCachedImage(url: images[index]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child:
                    FastCachedImage(url: images[index]),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ),
  );
}}


//Image click to full screen - click to go back
class ImageFullScreen extends StatelessWidget {
  final String imageUrl;

  const ImageFullScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}

// ######################################################################
//NSFW FILTER : PROBLEM REPEATING IMAGES

// class _Img_discoverState extends State<Img_discover> {
//   final ScrollController _scrollController = ScrollController();
//   final images = <Uint8List>[];
  
//   bool _isLoading = false;
// int page = 1;

// // Method to fetch images from the Civitai API
// void fetchImages({int limit = 10, String query = "dragon"}) async {
//   // Set the base URL for the Civitai API
//   final base_url = "https://civitai.com/api/v1";

//   // Set the endpoint for the images
//   final endpoint = "/images";

//   // Set the query parameters
//   final params = {
//     "limit": limit.toString(),
//     "query": query,
//     "nsfw": "None",
//   };

//   // Build the query string from the params map
//   final queryString = params.entries.map((e) => "${e.key}=${e.value}").join("&");

//   // Make the GET request to the Civitai API
//   final response = await http.get(Uri.parse("$base_url$endpoint?$queryString"));

//   // Check if the request was successful
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);

//     // Iterate over the image data
//     for (final model in data["items"]) {
//       print("Image ID: ${model['id']}");
//       print("Image Name: ${model['name']}");

//       // Get the image URL
//       final imageUrl = model['url'];

//       // Make a GET request to fetch the image data
//       final imageResponse = await http.get(Uri.parse(imageUrl));

//       // Check if the request was successful
//       if (imageResponse.statusCode == 200) {
//         // Add the image data to the list of images
//         setState(() {
//           images.add(imageResponse.bodyBytes);
//           _isLoading = false;
//         });
//       }
//     }
//   } else {
//     print("An error occurred while fetching data from the Civitai API");
//   }
// }


//  @override
// void initState() {
//   super.initState();
//   fetchImages();
//   _scrollController.addListener(() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       setState(() {
//         _isLoading = true;
//         fetchImages();
//       });
//     }
//   });
// }
// ######################################################################


  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {
  //       _loadMore();
  //     }
  //   });
  // }


  // Future<void> _loadMore() async {
  //   if (!_isLoading) {
  //     setState(() {
  //       _isLoading = true;
  //     });

      // Set the base URL for the Civitai API
      // Set the base URL for the Civitai API
  //     final base_url = "https://civitai.com/api/v1";

  //     // Set the endpoint for the models
  //     final endpoint = "/images";

  //     // Set the query parameters
  //     final params = {
  //       "limit": "10", // The number of results to be returned per page
  //       "page": "1", // The page from which to start fetching models
  //       "query": "dragon" // Search query to filter models by name
  //     };

  //     // Build the query string from the params map
  //     final query = params.entries.map((e) => "${e.key}=${e.value}").join("&");

  //     // Make the GET request to the Civitai API
  //     final response = await http.get(Uri.parse("$base_url$endpoint?$query"));
  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       // Print the model data
  //       for (final model in data["items"]) {
  //         print("Image ID: ${model['id']}");
  //         print("Image Name: ${model['name']}");

  //         //Get the image URL
  //         final imageUrl = model['url'];

  //         // Make a GET request to fetch the image data
  //         final imageResponse = await http.get(Uri.parse(imageUrl));

  //         // Check if the request was successful
  //         if (imageResponse.statusCode == 200) {
  //           // Add the image data to the list of images

  //           setState(() {
  //             images.add(imageResponse.bodyBytes);
  //             _isLoading = false;
  //           });
  //         }
  //       }
  //     } else {
  //       print("An error occurred while fetching data from the Civitai API");
  //     }
  //   }
  
 