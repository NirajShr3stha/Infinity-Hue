import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ai_diffusion/requests/txt_img.dart';
import 'package:shared_preferences/shared_preferences.dart';

var defaultNegativePrompt = TextEditingController(text: "");
bool hasDataLoaded = false;
var host = TextEditingController();
var _stepsValue = ValueNotifier<int>(10);
var _batchValue = ValueNotifier<int>(1);
var seed = TextEditingController(text: "-1");
var _scfValue = ValueNotifier<int>(10);
var restoreFaces = ValueNotifier<bool>(false);
var seedfixed = ValueNotifier<bool>(false);
var sampler = ValueNotifier("DPM++ 2M Karras");
var defaultPrompt = TextEditingController(text: "");
var width = ValueNotifier<int>(512);
var height = ValueNotifier<int>(512);
var promptController = TextEditingController();

Future<void> loadLastPrompt() async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('last-prompt')) {
    promptController.text = prefs.getString('last-prompt')!;
  }
}

class Advanced_settings extends StatefulWidget {
  Advanced_settings({super.key});

  @override
  State<Advanced_settings> createState() => _Advanced_settingsState();

  final hostController = TextEditingController();
}

class _Advanced_settingsState extends State<Advanced_settings> {
  final TextEditingController _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _seedfixed = false;
  bool _isFocusedTextfield = false;

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

  bool _restoreFace = false;
  void onChangeFunction1(bool newValue1) {
    setState(() {
      _restoreFace = newValue1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 1,
      builder: (_, controller) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: ListView(
          controller: controller,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Text("lorem"),
              // negativepromptContainer(),
              // //modelContainer(context),
              // restorefaceContainer(),
              // restorefaceContainer(),
            ]),
      ),
    );
  }

  Container negativepromptContainer() {
    return Container(
      margin: const EdgeInsets.all(0.0),
      padding: const EdgeInsets.all(8.0),
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
    );
  }

  Container stepsContainer() {
    return Container(
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
    );
  }

  Container cfgContainer() {
    return Container(
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
    );
  }

  Container samplerContainer() {
    return Container(
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
    );
  }

  Container imagenumberContainer() {
    return Container(
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
    );
  }

  Container modelContainer(BuildContext context) {
    return Container(
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
                    contentTextStyle: const TextStyle(color: Colors.white),
                    titleTextStyle: const TextStyle(color: Colors.white),
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
                                  setSDModel(value[index]["title"], context);
                                  return AlertDialog(
                                    backgroundColor: Colors.blueGrey.shade900,
                                    titleTextStyle:
                                        const TextStyle(color: Colors.white),
                                    title: const Text("Loading model"),
                                    content: const CircularProgressIndicator(),
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
    );
  }

  Container restorefaceContainer() {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      color: Colors.blueGrey,
      width: double.infinity,
      child: Column(
        children: [
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

          ValueListenableBuilder(
            valueListenable: restoreFaces,
            builder: (context, value, child) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: customSwitch(
                      'Restore faces', _restoreFace, onChangeFunction1));
            },
          ),
        ],
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
          onChanged: (bool newValue) {
            onChangeMethod(newValue);
            restoreFaces.value = newValue;
          },
        )
      ]),
    );
  }

  Container seedContainer() {
    return Container(
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
          controller: seed,
          focusNode: _focusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Seed',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.deepOrange),
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
                        value: _seedfixed,
                        onChanged: (value) {
                          setState(() {
                            _seedfixed = value ?? false;
                            if (_seedfixed == true && _seedfixed != -1) {
                              print(value);
                              int min = 111;
                              int max = 9999999;
                              int randomNumber =
                                  min + Random().nextInt(max - min);
                              seed.value = TextEditingValue(
                                  text: randomNumber.toString());
                              ;
                              print(seed);
                            } else {
                              int defaultval = -1;
                              seed.value =
                                  TextEditingValue(text: defaultval.toString());
                              ;
                              print(_seedfixed);
                              print(seed);
                              value = false;
                            }
                          });
                        },
                      ),
                    ],
                  ),
          ),
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
  prefs.setInt('batch_size', _batchValue.value);
  prefs.setString('seed', seed.text);
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
      _scfValue.value = prefs.getInt("batch_size") ?? 1;
      seed.text = prefs.getString("seed") ?? "-1";
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
