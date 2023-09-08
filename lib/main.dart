import 'package:flutter/material.dart';
import 'package:ai_diffusion/includes/navbar.dart';
import 'package:ai_diffusion/views/home_page.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';

void main() async {
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const Rootpage(),
    );
  }
}

class Rootpage extends StatefulWidget {
  const Rootpage({Key? key});

  @override
  State<Rootpage> createState() => _RootpageState();
}

class _RootpageState extends State<Rootpage> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinity Hue'),
        backgroundColor: Colors.black,
      ),
      body: const Homepage(),
      bottomNavigationBar: Navbar(
        currentPage: currentPage,
        onPageSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
      ),
    );
  }
}

// OLD CODE
// import 'package:ai_diffusion/views/home_page.dart';
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

// void main() async{
//   await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blueGrey),
//       home: const Rootpage(),
//     );
//   }
// }

// class Rootpage extends StatefulWidget {
//   const Rootpage({super.key});

//   @override
//   State<Rootpage> createState() => _RootpageState();
// }

// class _RootpageState extends State<Rootpage> {
//   int currentPage = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Imagine AI'),
//       ),
//       body: const Homepage(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           debugPrint('Floating Action Button');
//         },
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: Container(
//         color:  Colors.black,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal:15.0,
//           vertical: 20),
//           child: GNav(
//             backgroundColor: Colors.black,
//             color: Colors.white,
//             tabBackgroundColor: Colors.grey.shade800,
//             gap: 12,
//             padding: const EdgeInsets.all(10),
//             tabs: const [
//               GButton(icon: Icons.home,
//               text: 'Txt2img',),
//               GButton(icon: Icons.image_aspect_ratio,
//               text: 'Img2img',)
//               ,
//               GButton(icon: Icons.search,
//               text: 'Impaint',),
//               GButton(icon: Icons.settings,
//               text: 'Upscale',),],
//             // onDestinationSelected: (int index) {
//             //   setState(() {
//             //     currentPage = index;
//             //   });
//             // },
//             selectedIndex: currentPage,
//           ),
//         ),
//       ),
//     );
//   }
// }
