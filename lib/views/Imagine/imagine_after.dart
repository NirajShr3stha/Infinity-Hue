import 'dart:convert';
import 'package:ai_diffusion/views/Imagine/Assets_Management/Advanced_settings.dart';
import 'package:flutter/material.dart';
import 'package:ai_diffusion/requests/httprequest.dart';

class imagine_after extends StatefulWidget {
  imagine_after({super.key});
  @override
  State<imagine_after> createState() => _imagine_afterState();
}

class _imagine_afterState extends State<imagine_after> {
  String imageDataBase64 = 'NONE';
  bool val2 = false;
  onChangeFunction2(bool newValue2) {
    setState(() {
      val2 = newValue2;
    });
  }

  double fontSize = 16.0;
  double numberOfLines = 10;
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

  FocusNode myFocusNode = FocusNode();
  final List<String> _imagePaths = [
    'assets/image_placeholder.png',
    // 'assets/2.jpg',
    // 'assets/3.webp',
    // 'assets/1.webp',
    // 'assets/2.jpg',
    // 'assets/3.webp',
    // 'assets/4.png',
    // 'assets/5.jpeg',
    // 'assets/6.jpeg',
    // 'assets/7.jpg',
    // 'assets/8.jpg',
    // 'assets/9.jpeg',
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
          title: const Text('Imagine after'),
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

            // Define a FocusNode

            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                // Use the hasFocus property of the FocusNode to change the color of the border
                border: Border.all(
                    color: myFocusNode.hasFocus ? Colors.blue : Colors.grey),
              ),
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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 250,
                  ),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      // Call setState to rebuild the widget with the new color
                      setState(() {});
                    },
                    child: TextField(
                      focusNode: myFocusNode,
                      controller: promptController,
                      decoration: InputDecoration(
                        hintText: 'Prompt',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide
                              .none, // This makes the border invisible but keeps the rounded corners
                        ),
                      ),
                      maxLines: null,
                      minLines: 20, // Add this
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
                doProgress();
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
                      if (imageDataBase64 != 'NONE') {
                        _rawimages
                            .add(Image.memory(base64Decode(imageDataBase64)));
                      }
                      print(_rawimages.length);
                      print("_rawimages.length)");
                    }),
                    if (!inProgress)
                      {
                        Navigator.pop(context),
                      }
                  },
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Image Generation Progress'),
                      content: ValueListenableBuilder(
                        valueListenable: progressValue,
                        builder: (BuildContext context, double value,
                            Widget? child) {
                          return SizedBox(
                            height: 20,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.grey[200],
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.blue),
                              ),
                            ),
                          );
                        },
                      ),
                    );
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
