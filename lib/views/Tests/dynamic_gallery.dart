import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class DynamicGallery extends StatefulWidget {
  const DynamicGallery({Key? key}) : super(key: key);

  @override
  State<DynamicGallery> createState() => _GalleryState();
}

class _GalleryState extends State<DynamicGallery> {
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    loadImagesFromDevice();
  }

  Future<void> loadImagesFromDevice() async {
    final appDir = await getApplicationDocumentsDirectory();
    final galleryDir = Directory('$appDir/Pictures');
    final imageFiles = galleryDir.listSync();

    setState(() {
      images = imageFiles
          .whereType<File>()
          .map((file) => file)
          .toList();
    });
  }

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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 4.0,
          top: 9.0,
          right: 4.0,
          bottom: 4.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) => GestureDetector(
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
                                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 2.5),
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
                                  child: Image.file(images[index]),
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
                    child: Image.file(images[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}