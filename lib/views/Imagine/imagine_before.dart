import 'dart:convert';
import 'package:ai_diffusion/views/Imagine/Assets_Management/Advanced_settings.dart';
import 'package:flutter/material.dart';
import 'package:ai_diffusion/requests/httprequest.dart';

class Imagine extends StatefulWidget {
  Imagine({super.key});
  @override
  State<Imagine> createState() => _ImagineState();
}

class _ImagineState extends State<Imagine> {
  String imageDataBase64 = 'NONE';
 

  double fontSize = 16.0;
  double numberOfLines = 10;
  @override
  void initState() {
    super.initState();    
  }

  @override
  void dispose() {
    super.dispose();
  }
  FocusNode myFocusNode = FocusNode();
  

  final List<Image> _rawimages = [
    // add more image paths here
  ];

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

            
          ],
        ),
      ),
    );
  }
}
