import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_diffusion/requests/txt_img.dart';

class Imagine extends StatefulWidget {
  const Imagine({super.key});

  @override
  State<Imagine> createState() => _ImagineState();
}

class _ImagineState extends State<Imagine> {
  String imageDataBase64 = 'NONE';
  double _stepsValue = 0;
  double _batchValue = 1;
  double _scfValue = 1;

  bool _isFocusedTextfield = false;
  bool _isCheckedCheckbox = false;

  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocusedTextfield = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  //for switch
  bool val1 = false;
  onChangeFunction1(bool newValue1) {
    setState(() {
      val1 = newValue1;
    });
  }

  bool val2 = false;
  onChangeFunction2(bool newValue2) {
    setState(() {
      val2 = newValue2;
    });
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
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  if(imageDataBase64 == 'NONE'){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(_imagePaths[index]),
                  );}
                  else{
                    return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _rawimages[0],
                  ); 
                  }
                },
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
                debugPrint('Imagine');
                sendRequest("dog eating", "cat, dog").then((value) => {
                      setState(() {
                        var image = value;
                        if (image == "Error") {
                          return;
                        }
                        if (value.contains(",")) {
                          image = value.split(",")[1];
                        }
                        imageDataBase64 = image;
                        if (imageDataBase64 != 'NONE'){
                          _rawimages.add(Image.memory(base64Decode(imageDataBase64)));
                        }
                      })
                    });
              },
              child: const Text('Imagine'),
            ),

            ExpansionTile(
              title: const Text('Advanced Option'),
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Negative Prompt",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), //this is for creating space
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Negative Prompt',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sampling Steps",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      _stepsValue.round().toString(),
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8.0),
                    //this is for creating space
                    Slider(
                        value: _stepsValue,
                        min: 0,
                        max: 150,
                        divisions: 150,
                        label: _stepsValue.round().toString(),
                        activeColor: Colors.blue,
                        inactiveColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            _stepsValue = value.round().toDouble();
                          });
                        })
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "CFG scale",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      _scfValue.round().toString(),
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8.0),
                    //this is for creating space
                    Slider(
                        value: _scfValue,
                        min: 0,
                        max: 30,
                        divisions: 60,
                        label: _scfValue.round().toString(),
                        activeColor: Colors.blue,
                        inactiveColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            _scfValue = value.round().toDouble();
                          });
                        })
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sampler Name",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), //this is for creating space
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Sampler Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Model Name",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), //this is for creating space
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Model Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Restore faces",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    //this is for creating space
                    customSwitch('Restore faces', val1, onChangeFunction1),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  //color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Seed",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), //this is for creating space

                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Seed',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.deepOrange),
                        ),
                        suffixIcon: _isFocusedTextfield
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _controller.clear();
                                  setState(() {
                                    //_isFocusedTextfield = false;
                                  });
                                },
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Fixed'),
                                  Checkbox(
                                    value: _isCheckedCheckbox,
                                    onChanged: (value) {
                                      setState(() {
                                        _isCheckedCheckbox = value ?? false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                      ),
                    )
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Number of image",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      _batchValue.round().toString(),
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8.0),
                    //this is for creating space

                    Slider(
                        value: _batchValue,
                        min: 1,
                        max: 4,
                        divisions: 3,
                        label: _batchValue.round().toString(),
                        activeColor: Colors.blue,
                        inactiveColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            _batchValue = value.round().toDouble();
                          });
                        })
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget customSwitch(String text, bool val, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(text,
            style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                color: Colors.black)),
        const Spacer(),
        CupertinoSwitch(
          trackColor: Colors.grey,
          activeColor: Colors.green,
          value: val,
          onChanged: (newValue) {
            onChangeMethod(newValue);
          },
        )
      ]),
    );
  }
}
