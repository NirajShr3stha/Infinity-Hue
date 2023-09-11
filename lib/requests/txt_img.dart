import 'dart:convert';
import 'package:ai_diffusion/views/Imagine/Advanced_settings.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const url = 'http://192.168.1.105:7860';
bool inProgress = false;
final progressValue = ValueNotifier<double>(0.0);

Future<String> createImage(BuildContext context, String prompt) async {
  //const url = 'http://192.168.1.105:7860';
  if (defaultNegativePrompt.text.trim().isEmpty ||
      !defaultNegativePrompt.text.contains(RegExp(r'[a-zA-Z0-9]'))) {
    // defaultNegativePrompt.text =
    //     "easynegative, bad_prompt_version2-neg, ng_deepnegative_v1_75t, verybadimagenegative_v1.3," +
    //         "(Poorly Made Bad 3D),censored, 3d, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, normal quality, ((monochrome)), ((grayscale)), skin spots, acnes, bad hands," +
    //         "canvas frame, cartoon, 3d, ((disfigured)),((bad art)), ((deformed)),((extra limbs)),((close up)),((b&w)), wierd colors, blurry, (((duplicate))), ((morbid)), ((mutilated)), [out of frame], extra fingers, mutated hands, ((poorly drawn hands)), ((poorly drawn face)), (((mutation))), (((deformed))), ((ugly)), blurry, ((bad anatomy)), (((bad proportions))), ((extra limbs)), cloned face, (((disfigured))), out of frame, ugly, extra limbs, (bad anatomy), gross proportions, (malformed limbs), ((missing arms)), ((missing legs)), (((extra arms))), (((extra legs))), mutated hands, (fused fingers), (too many fingers), (((long neck))), Photoshop, ugly, tiling, poorly drawn hands, poorly drawn feet, poorly drawn face, out of frame, mutation, mutated, extra limbs, extra legs, extra arms, disfigured, deformed, cross-eye, body out of frame, blurry, bad art, bad anatomy, 3d render, " +
    //         "ugly, tiling, poorly drawn hands, poorly drawn feet, poorly drawn face, out of frame, " +
    //         "mutation, mutated, extra limbs, extra legs, extra arms, disfigured, deformed, cross-eye, " +
    //         "body out of frame, blurry, bad art, bad anatomy, blurred, text, watermark, grainy";
  }

  var map = <String, String>{};
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("has-data")) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Setup Error"),
          content: Text("You have not set up the app yet!"),
        );
      },
    );
    return "ERROR";
  }

  map['prompt'] = prompt;
  map['seed'] = "${prefs.getString("seed")}";
  map['subseed'] = "-1";
  map['batch_size'] = "${prefs.getInt("batch_size")}";
  map['steps'] = "${prefs.getInt("steps")}";
  map['cfg_scale'] = "${prefs.getInt("cfg")}";
  map['width'] = "${prefs.getInt("width") ?? 1536}";
  map['height'] = "${prefs.getInt("height") ?? 2048}";
  map['sampler_index'] = prefs.getString("sampler")!;
  map['restore_faces'] = prefs.getBool("restore-faces").toString();
  map['negative_prompt'] = prefs.getString("defaultNegativePrompt")!;

  var body = json.encode(map);
  print(map);
  inProgress = true;
  progressValue.value = 0;
  //doProgress();
  http.Response response = await http.post(Uri.parse('$url/sdapi/v1/txt2img'),
      body: body,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      });
  var images = jsonDecode(utf8.decode(response.bodyBytes))['images'];
  inProgress = false;
  progressValue.value = 1;
  return images[0];
}
// final payload = {
//   'prompt': prompt,
//   'negative_prompt': negativePrompt,
//   'steps': 50,
//   //'denoising strength': 50,
//   'seed': -1,
//   'batch_size': 1,
//   'n_iter': 1,
//   'cfg_scale': 7,
//   'width': 512,
//   'height': 512,
//   'enable_hr': false,
//   'restore_faces': false,
//   'model_name': 'protovisionXLHighFidelity3D_beta0520Bakedvae',
// };

// final response = await http.post(
//   Uri.parse('$url/sdapi/v1/txt2img'),
//   body: jsonEncode(payload),
//   headers: {'Content-Type': 'application/json'},
// );
// //debugPrint(response.body);
// var r = json.decode(response.body);
// // File imageFile;
// return r['images'][0];

// // debugPrint('i: , type: ${i.runtimeType}');
// if (i.contains(',')) {
//   var image = base64Decode(i.split(',')[1]);
//   imageFile = File('output1.png');
//   await imageFile.writeAsBytes(image);
// } else {
//   // handle the case where i does not contain any commas
//   var image = base64Decode(i);
//   debugPrint("no commas");
//   imageFile = File('output.png');
//   await imageFile.writeAsBytes(image);

// }

//final r = jsonDecode(response.body);

// for (final i in r['images']) {
//   final imageBytes = base64Decode(i.split(',', 1)[0]);

//   final file = File('output.png');
//   await file.writeAsBytes(imageBytes);
// }
Future<List<dynamic>> getSDModels() async {
  var urls = Uri(
      scheme: "http",
      host: "192.168.1.105",
      port: 7860,
      path: "/sdapi/v1/sd-models");

  http.Response response = await http.get(urls);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print(data);
    return data;
  } else {
    throw Exception('Failed to load models');
  }
}

Future<void> setSDModel(model, context) async {
  print("Setting model to $model");
  print("--------------------------------------------------");

  var map = <String, String>{};
  map["sd_model_checkpoint"] = model;
  var body = json.encode(map);

  final response = await http.post(
    Uri.parse('$url/sdapi/v1/options'),
    body: body,
    headers: {'Content-Type': 'application/json', "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    print("Model set to $model");
    Navigator.pop(context);
  } else {
    // print response
    print(response.body);
    throw Exception('Failed to set model! Status code: ${response.statusCode}');
  }
}

Future<Map<String, double>> getProgress() async {
  http.Response response = await http.get(Uri.parse('$url/sdapi/v1/progress'));
  var jsonResp = jsonDecode(utf8.decode(response.bodyBytes));
  return {
    "progress": jsonResp['progress'],
    "eta_relative": jsonResp['eta_relative'],
  };
}

Future<void> doProgress() async {
  while (true) {
    if (!inProgress) {
      progressValue.value = 1;
      return;
    }
    getProgress().then(
      (value) => {
        progressValue.value = value['progress']!,
      },
    );
    await Future.delayed(const Duration(milliseconds: 500));
  }
}