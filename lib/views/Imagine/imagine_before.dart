import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_diffusion/requests/txt_img.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool hasDataLoaded = false;
var host = TextEditingController();
var _stepsValue = ValueNotifier<int>(10);
var _batchValue = ValueNotifier<int>(1);
var _scfValue = ValueNotifier<int>(10);
var restoreFaces = ValueNotifier<bool>(false);
var seedfixed = ValueNotifier<bool>(false);
var sampler = ValueNotifier("DPM++ 2M Karras");
var defaultPrompt = TextEditingController(text: "");
var width = ValueNotifier<int>(512);
var height = ValueNotifier<int>(512);
var promptController = TextEditingController();

var defaultNegativePrompt = TextEditingController(text: "");

Future<void> loadLastPrompt() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('last-prompt')) {
    promptController.text = prefs.getString('last-prompt')!;
  }
}

class Imagine extends StatefulWidget {
  Imagine({super.key});

  @override
  State<Imagine> createState() => _ImagineState();
  final hostController = TextEditingController();
}

class _ImagineState extends State<Imagine> {
  String imageDataBase64 = 'NONE';
  //double _scfValue = 1;

  bool _isFocusedTextfield = false;
  bool _seedfixed = false;

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
  bool _restoreFace = false;
  onChangeFunction1(bool newValue1) {
    setState(() {
      _restoreFace = newValue1;
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
                  if (imageDataBase64 == 'NONE') {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(_imagePaths[index]),
                    );
                  } else {
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

                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Negative prompt',
                      ),
                      controller: defaultNegativePrompt,
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    ValueListenableBuilder(
                      valueListenable: _stepsValue,
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                "Steps: ${_stepsValue.value}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Slider(
                                value: value.toDouble(),
                                min: 1,
                                max: 150,
                                divisions: 150,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.red,
                                label: value.toString(),
                                onChanged: (double newValue) {
                                  _stepsValue.value = newValue.round();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: Column(children: [
                    ValueListenableBuilder(
                      valueListenable: _scfValue,
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                "CFG: ${_scfValue.value}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Slider(
                                value: value.toDouble(),
                                min: 1,
                                max: 40,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.red,
                                divisions: 39,
                                label: value.toString(),
                                onChanged: (double newValue) {
                                  _scfValue.value = newValue.round();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: ValueListenableBuilder(
                    valueListenable: sampler,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: DropdownButton(
                          onChanged: (String? newValue) {
                            sampler.value = newValue!;
                          },
                          items: const [
                            DropdownMenuItem(
                              value: "Euler a",
                              child: Text("Euler a"),
                            ),
                            DropdownMenuItem(
                              value: "Euler",
                              child: Text("Euler"),
                            ),
                            DropdownMenuItem(
                              value: "LMS",
                              child: Text("LMS"),
                            ),
                            DropdownMenuItem(
                              value: "Heun",
                              child: Text("Heun"),
                            ),
                            DropdownMenuItem(
                              value: "DPM2",
                              child: Text("DPM2"),
                            ),
                            DropdownMenuItem(
                              value: "DPM2 a",
                              child: Text("DPM2 a"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ 2S a",
                              child: Text("DPM++ 2S a"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ 2M",
                              child: Text("DPM++ 2M"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ SDE",
                              child: Text("DPM++ SDE"),
                            ),
                            DropdownMenuItem(
                              value: "DPM fast",
                              child: Text("DPM fast"),
                            ),
                            DropdownMenuItem(
                              value: "DPM adaptive",
                              child: Text("DPM adaptive"),
                            ),
                            DropdownMenuItem(
                              value: "LMS Karras",
                              child: Text("LMS Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DPM2 Karras",
                              child: Text("DPM2 Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DPM2 a Karras",
                              child: Text("DPM2 a Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ 2S a Karras",
                              child: Text("DPM++ 2S a Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ 2M Karras",
                              child: Text("DPM++ 2M Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DPM++ SDE Karras",
                              child: Text("DPM++ SDE Karras"),
                            ),
                            DropdownMenuItem(
                              value: "DDIM",
                              child: Text("DDIM"),
                            ),
                            DropdownMenuItem(
                              value: "PLMS",
                              child: Text("PLMS"),
                            ),
                          ],
                          hint: const Text("Select item"),
                          style: const TextStyle(color: Colors.white),
                          dropdownColor: Colors.blueGrey.shade900,
                          isExpanded: true,
                          value: sampler.value,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.blueGrey,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(
                          40), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    onPressed: () {
                      // modal
                      getSDModels().then(
                        (value) => {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Select SD model"),
                                backgroundColor: Colors.blueGrey.shade900,
                                contentTextStyle:
                                    const TextStyle(color: Colors.white),
                                titleTextStyle:
                                    const TextStyle(color: Colors.white),
                                content: Container(
                                  width: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(value[index]["title"]),
                                        textColor: Colors.white,
                                        onTap: () {
                                          //Navigator.pop(context);
                                          // display loader
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              setSDModel(value[index]["title"],
                                                  context);
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.blueGrey.shade900,
                                                titleTextStyle: const TextStyle(
                                                    color: Colors.white),
                                                title:
                                                    const Text("Loading model"),
                                                content:
                                                    const CircularProgressIndicator(),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        },
                      );
                    },
                    child: const Text("Change SD model"),
                  ),
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
                    customSwitch(
                        'Restore faces', _restoreFace, onChangeFunction1),
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
                                  ValueListenableBuilder(
                                    valueListenable: seedfixed,
                                    builder: (context,value, child){
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                        child: Checkbox(
                                      
                                      value: _seedfixed,
                                      onChanged: (value) {
                                        setState(() {
                                          _seedfixed = value ?? false;
                                        });
                                      },
                                    ),
                                      );
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
                    ValueListenableBuilder(
                      valueListenable: _batchValue,
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Text(
                                "Number of images: ${_batchValue.value}",
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Slider(
                                value: value.toDouble(),
                                min: 1,
                                max: 4,
                                divisions: 3,
                                activeColor: Colors.blue,
                                inactiveColor: Colors.red,
                                label: value.toString(),
                                onChanged: (double newValue) {
                                  _batchValue.value = newValue.round();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
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

Future<void> saveConfig(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("has-data", true);
  prefs.setString("host", host.text);
  prefs.setInt('steps', _stepsValue.value);
  prefs.setInt('cfg', _scfValue.value);
  prefs.setString('sampler', sampler.value);
  prefs.setString('defaultPrompt', defaultPrompt.text);
  prefs.setString('defaultNegativePrompt', defaultNegativePrompt.text);
  prefs.setBool('restore-faces', restoreFaces.value);
  prefs.setInt("width", width.value);
  prefs.setInt("height", height.value);

  print(
      "Saving: ${host.value}, ${_stepsValue.value}, ${_scfValue.value}, ${sampler.value}, ${defaultPrompt.value};;; ${defaultNegativePrompt.value}");
}

Future<void> loadSavedData() async {
  final prefs = await SharedPreferences.getInstance();
  if (!hasDataLoaded) {
    if (prefs.getBool("has-data") ?? false) {
      _stepsValue.value = prefs.getInt("steps") ?? 20;
      host.text = prefs.getString("host") ?? "";
      _scfValue.value = prefs.getInt("cfg") ?? 20;
      restoreFaces.value = prefs.getBool("restore-faces") ?? false;
      sampler.value = prefs.getString("sampler") ?? "Euler";
      defaultPrompt.text = prefs.getString("defaultPrompt") ?? "";
      defaultNegativePrompt.text =
          prefs.getString("defaultNegativePrompt") ?? "";
      width.value = prefs.getInt("width") ?? 512;
      height.value = prefs.getInt("height") ?? 512;
      hasDataLoaded = true;
    }
  }
}
