import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;

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
  final images = <Uint8List>[];

  bool _isLoading = false;
  int page = 1;
  // Method to fetch images from the Civitai API
  void fetchImages(
      {int limit = 10, int page = 1, String query = "dragon"}) async {
    // Set the base URL for the Civitai API
    final base_url = "https://civitai.com/api/v1";

    // Set the endpoint for the images
    final endpoint = "/images";

    // Set the query parameters
    final params = {
      "limit": limit.toString(),
      "page": page.toString(),
      "query": query,
    };

    // Build the query string from the params map
    final queryString =
        params.entries.map((e) => "${e.key}=${e.value}").join("&");

    // Make the GET request to the Civitai API
    final response =
        await http.get(Uri.parse("$base_url$endpoint?$queryString"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Iterate over the image data
      for (final model in data["items"]) {
        print("Image ID: ${model['id']}");
        print("Image Name: ${model['name']}");

        // Get the image URL
        final imageUrl = model['url'];

        // Make a GET request to fetch the image data
        final imageResponse = await http.get(Uri.parse(imageUrl));

        // Check if the request was successful
        if (imageResponse.statusCode == 200) {
          // Add the image data to the list of images
          setState(() {
            images.add(imageResponse.bodyBytes);
            _isLoading = false;
          });
        }
      }
    } else {
      print("An error occurred while fetching data from the Civitai API");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isLoading = true;
          page++;
          fetchImages(page: page);
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
          MasonryGridView.builder(
            controller: _scrollController,
            itemCount: images.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                          ImageFullScreen(imageBytes: images[index]),
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
                                  child: Image.memory(images[index]),
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
                  child: Image.memory(images[index]),
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
  }
}

//Image click to full screen - click to go back
class ImageFullScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageFullScreen({required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Image.memory(imageBytes),
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