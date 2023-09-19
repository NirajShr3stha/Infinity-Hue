import 'dart:convert';
import 'package:ai_diffusion/views/Imagine/Advanced_settings.dart';
import 'package:flutter/material.dart';
import 'package:ai_diffusion/requests/txt_img.dart';

class Imagine extends StatefulWidget {
  Imagine({super.key});
  @override
  State<Imagine> createState() => _ImagineState();
}

class _ImagineState extends State<Imagine> {
  String imageDataBase64 = 'NONE';
  bool val2 = false;
  onChangeFunction2(bool newValue2) {
    setState(() {
      val2 = newValue2;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);
    _scrollController = ScrollController();
    _pageController.addListener(() {
      _currentPageNotifier.value = _pageController.page!.round();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<String> _imagePaths = [
    'assets/1.webp',
    'assets/2.jpg',
    'assets/3.webp',
    'assets/1.webp',
    'assets/2.jpg',
    'assets/3.webp',
    'assets/4.png',
    'assets/5.jpeg',
    'assets/6.jpeg',
    'assets/7.jpg',
    'assets/8.jpg',
    'assets/9.jpeg',
    // add more image paths here
  ];

  final List<Image> _rawimages = [
    // add more image paths here
  ];
  late final PageController _pageController;
  late final ValueNotifier<int> _currentPageNotifier;
  late final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Learn Flutters'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300, // Specify your container height
              child: PageView.builder(
                controller:
                    _pageController, // Add the controller to your PageView

                itemCount: (_rawimages.isNotEmpty)
                    ? _rawimages.length
                    : _imagePaths.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      width: 360, // Specify your container width
                      height: 350, // Specify your container height
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the radius as needed
                            child: (_rawimages.isNotEmpty)
                                ? _rawimages[index]
                                : Image.asset(_imagePaths[index],
                                    fit: BoxFit.scaleDown),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: SizedBox(
                height: 80, // Specify your container height for the preview
                child: ValueListenableBuilder<int>(
                    valueListenable: _currentPageNotifier,
                    builder: (context, currentPage, child) {
                      return ListView.builder(
                        controller: _scrollController, // Add this line
                        scrollDirection: Axis.horizontal,
                        itemCount: (_rawimages.isNotEmpty)
                            ? _rawimages.length
                            : _imagePaths.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 4.0,
                              top: 9.0,
                              right: 4.0,
                              bottom: 5.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                                _scrollController.animateTo(
                                  // Add these lines
                                  index * 65.0, // Adjust as needed
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                width: 65,
                                height: 50,
                                decoration: currentPage == index
                                    ? BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue, width: 3),
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      10), // Adjust as needed
                                  child: _rawimages.isNotEmpty
                                      ? _rawimages[index]
                                      : Image.asset(_imagePaths[index],
                                          fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.black,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              color: Colors.blueGrey,
              width: double.infinity,
              child: const Center(
                child: Text(
                  "This is testing",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     debugPrint('Reroll button');
            //   },
            //   child: const Text('Reroll Button'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     debugPrint('Upscaling button');
            //   },
            //   child: const Text('Upscaling Button'),
            // ), //delete this

            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              width: double.infinity,
              child: Column(children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Prompt",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0), //this is for creating space
                TextField(
                  controller: promptController,
                  decoration: InputDecoration(
                    hintText: 'Prompt',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ]),
            ),

            ElevatedButton(
              onPressed: () {
                saveConfig(context);
                //.then((value) =>
                //     Navigator.pushNamedAndRemoveUntil(
                //         context, "/", (route) => false)); this navigates to homepage
                debugPrint('Imagine');
                createImage(context, promptController.text).then(
                  (value) => {
                    setState(() {
                      var image = value;
                      if (image == "ERROR") {
                        return;
                      }
                      if (value.contains(",")) {
                        image = value.split(",")[1];
                      }
                      imageDataBase64 = image;
                      imageDataBase64 = image;
                      if (imageDataBase64 != 'NONE') {
                        _rawimages
                            .add(Image.memory(base64Decode(imageDataBase64)));
                      }
                      print(_rawimages.length);
                      print("_rawimages.length)");
                    })
                  },
                );
              },
              child: const Text('Imagine'),
            ),

            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true, // Set isScrollControlled to true
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: Colors.transparent,

                  builder: (context) => Advanced_settings(),
                );
              },
              child: Text('Advanced Settings'),
            ),

            // DraggableScrollableSheet(
            //   initialChildSize: 0.3,
            //   maxChildSize: 0.7,
            //   builder:
            //       (BuildContext context, ScrollController scrollController) {
            //     return Container(
            //       color: Colors.blue[100],
            //       child: ListView.builder(
            //         controller: scrollController,
            //         itemCount: 25,
            //         itemBuilder: (BuildContext context, int index) {
            //           return ListTile(title: Text('Item $index'));
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
