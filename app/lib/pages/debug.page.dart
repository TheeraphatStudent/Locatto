// /*
//  * QR.Flutter
//  * Copyright (c) 2019 the QR.Flutter authors.
//  * See LICENSE for distribution and usage details.
//  */

// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// /// This is the screen that you'll see when the app starts
// class DebugPage extends StatefulWidget {
//   const DebugPage({super.key});

//   @override
//   State<DebugPage> createState() => _DebugPageState();
// }

// class _DebugPageState extends State<DebugPage> {
//   @override
//   Widget build(BuildContext context) {
//     const String message =
//         // ignore: lines_longer_than_80_chars
//         'Hey this is a QR code. Change this value in the main_screen.dart file.';

//     /*final qrFutureBuilder = FutureBuilder<ui.Image>(
//       future: _loadOverlayImage(),
//       builder: (ctx, snapshot) {
//         final size = 280.0;
//         if (!snapshot.hasData) {
//           return Container(width: size, height: size);
//         }
//         return CustomPaint(
//           size: Size.square(size),
//           painter: QrPainter(
//             data: message,
//             version: QrVersions.auto,
//             gapless: true,
//             eyeStyle: const QrEyeStyle(
//               eyeShape: QrEyeShape.square,
//               //color: Color(0xff128760),
//               borderRadius: 10,
//             ),
//             dataModuleStyle: const QrDataModuleStyle(
//               dataModuleShape: QrDataModuleShape.square,
//               //color: Color(0xff1a5441),
//               borderRadius: 5,
//             ),
//             // size: 320.0,
//             embeddedImage: snapshot.data,
//             embeddedImageStyle: QrEmbeddedImageStyle(
//               size: Size.square(50),
//               safeArea: true,
//               safeAreaMultiplier: 1.1,
//             ),
//           ),
//         );
//       },
//     );

//     return qrFutureBuilder;*/

//     return Material(
//       color: Colors.white,
//       child: SafeArea(
//         top: true,
//         bottom: true,
//         child: Container(
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     width: 280,
//                     child: QrImageView(
//                       data: message,
//                       version: QrVersions.auto,
//                       /*gradient: LinearGradient(
//                         begin: Alignment.bottomLeft,
//                         end: Alignment.topRight,
//                         colors: [
//                           Color(0xffff0000),
//                           Color(0xffffa500),
//                           Color(0xffffff00),
//                           Color(0xff008000),
//                           Color(0xff0000ff),
//                           Color(0xff4b0082),
//                           Color(0xffee82ee),
//                         ],
//                       ),*/
//                       eyeStyle: const QrEyeStyle(
//                         eyeShape: QrEyeShape.square,
//                         color: Color(0xff128760),
//                       ),
//                       dataModuleStyle: const QrDataModuleStyle(
//                         dataModuleShape: QrDataModuleShape.square,
//                         color: Color(0xff1a5441),
//                       ),
//                       embeddedImage: AssetImage(
//                         'assets/images/logo_primary.png',
//                       ),
//                       embeddedImageStyle: QrEmbeddedImageStyle(
//                         size: Size.square(40),
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 20,
//                   horizontal: 40,
//                 ).copyWith(bottom: 40),
//                 child: Text(message),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  late String message;

  @override
  void initState() {
    super.initState();
    message =
        'Flutter popup card demo app. Click the account icon in the top right.';
  }

  Future<void> _accountClicked() async {
    final result = await showPopupCard<String>(
      context: context,
      builder: (context) {
        return PopupCard(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: const PopupCardDetails(),
        );
      },
      offset: const Offset(-8, 60),
      alignment: Alignment.topRight,
      useSafeArea: true,
      dimBackground: true,
    );
    if (result == null) return;
    setState(() {
      message = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Demo app'),
        actions: [
          IconButton(
            onPressed: _accountClicked,
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            message = 'Reset.';
          });
        },
        child: const Icon(Icons.restore),
      ),
    );
  }
}

class PopupCardDetails extends StatelessWidget {
  const PopupCardDetails({super.key});

  void _logoutPressed(BuildContext context) {
    Navigator.of(context).pop('Logout pressed');
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: math.min(450, MediaQuery.sizeOf(context).width - 16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24.0),
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            radius: 36,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            child: Text('AB', style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Able Bradley',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 2.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'able.bradley@gmail.com',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8.0),
          const Divider(),
          TextButton(
            onPressed: () => _logoutPressed(context),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
