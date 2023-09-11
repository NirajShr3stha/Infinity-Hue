import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatelessWidget {
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const Navbar({
    Key? key,
    required this.currentPage,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 12,
          padding: const EdgeInsets.all(10),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Txt2img',
            ),
            GButton(
              icon: Icons.image_aspect_ratio,
              text: 'Img2img',
            ),
            GButton(
              icon: Icons.search,
              text: 'Impaint',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Upscale',
            ),
          ],
          selectedIndex: currentPage,
          onTabChange: (index) {
            onPageSelected(index);
          },
        ),
      ),
    );
  }
}