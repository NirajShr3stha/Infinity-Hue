import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final List<AssetImage> images = const [
    AssetImage('assets/1.webp'),
    AssetImage('assets/2.jpg'),
    AssetImage('assets/3.webp'),
    AssetImage('assets/4.png'),
    AssetImage('assets/5.jpeg'),
    AssetImage('assets/6.jpeg'),
    AssetImage('assets/7.jpg'),
    AssetImage('assets/8.jpg'),
    AssetImage('assets/9.jpeg'),
    // ...
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            )),
        body: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, top: 9.0, right: 4.0, bottom: 4.0),
          child: MasonryGridView.builder(
            itemCount: images.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(3.5),
              child: GestureDetector(
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
                                    color: Colors.black.withOpacity(0.5)),
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
                                  child: Image(image: images[index]),
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
                  child: Image(image: images[index]),
                ),
              ),
            ),
          ),
        ));
  }
}