import 'package:flutter/material.dart';

class FullScreenTextField extends StatefulWidget {
  const FullScreenTextField({super.key});

  @override
  State<FullScreenTextField> createState() => _FullScreenTextFieldState();
}

class _FullScreenTextFieldState extends State<FullScreenTextField> {
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
      body: Center(
        child: Hero(
            tag: 'expand',
            child:
                Material(type: MaterialType.transparency, child: TextField())),
      ),
    );
  }
}
