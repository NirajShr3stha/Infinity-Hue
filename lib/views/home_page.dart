import 'package:ai_diffusion/views/gallery_page.dart';
import 'package:ai_diffusion/views/Imagine/imagine_before.dart';
import 'package:ai_diffusion/views/Discover/showcase.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Imagine();
                  },
                ),
              );
            },
            child: const Text('Generate Image'),
          ),

          const SizedBox(height: 20), //spacing
          ElevatedButton(
            onPressed: () {
              // push to gallery page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Gallery()),
              );
            },
            child: const Text('Gallery'),
          ),

          const SizedBox(height: 20), //spacing
          ElevatedButton(
            onPressed: () {
              //push to dynamic gallery page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Img_discover()),
              );
            },
            child: const Text('Community Showcase'),
          ),
        ],
      ),
    );
  }
}
