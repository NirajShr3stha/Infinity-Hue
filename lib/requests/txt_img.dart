import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendRequest(String prompt, String negativePrompt) async {
  //const url = 'http://192.168.1.105:7860';
  const url = 'http://192.168.1.66:7860';

  final payload = {
    'prompt': prompt,
    'negative_prompt': negativePrompt,
    'steps': 50,
    //'denoising strength': 50,
    'seed': -1,
    'batch_size': 1,
    'n_iter': 1,
    'cfg_scale': 7,
    'width': 512,
    'height': 512,
    'enable_hr': false,
    'restore_faces': false,
    'model_name': 'protovisionXLHighFidelity3D_beta0520Bakedvae',
  };
  
  final response = await http.post(
    Uri.parse('$url/sdapi/v1/txt2img'),
    body: jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
  );
  //debugPrint(response.body);
  var r = json.decode(response.body);
  // File imageFile;
  return r['images'][0];
    // debugPrint('i: , type: ${i.runtimeType}');
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

  }
  
  
  //final r = jsonDecode(response.body);

  // for (final i in r['images']) {
  //   final imageBytes = base64Decode(i.split(',', 1)[0]);

  //   final file = File('output.png');
  //   await file.writeAsBytes(imageBytes);
  // }

