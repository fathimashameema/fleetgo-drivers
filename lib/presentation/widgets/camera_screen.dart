// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:fleetgo_drivers/resources/colors/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   late Future<void> _initializeControllerFuture;
//   int _selectedCameraIndex = 0;
//   FlashMode _flashMode = FlashMode.off;
//   double _currentZoom = 1.0;
//   double _maxZoom = 1.0;
//   double _minZoom = 1.0;

//   @override
//   void initState() {
//     super.initState();
//     _initCamera(_selectedCameraIndex);
//   }

//   Future<void> _initCamera(int cameraIndex) async {
//     final cameras = await availableCameras();
//     if (cameras.isEmpty) return;

//     _controller = CameraController(
//       cameras[cameraIndex],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );

//     _initializeControllerFuture = _controller!.initialize().then((_) async {
//       _maxZoom = await _controller!.getMaxZoomLevel();
//       _minZoom = await _controller!.getMinZoomLevel();
//       if (mounted) setState(() {});
//     });

//     if (mounted) setState(() {});
//   }

//   Future<void> _switchCamera() async {
//     final cameras = await availableCameras();
//     if (cameras.length < 2) return;

//     _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
//     await _initCamera(_selectedCameraIndex);
//   }

//   Future<void> _toggleFlash() async {
//     if (_controller == null) return;

//     if (_flashMode == FlashMode.off) {
//       _flashMode = FlashMode.auto;
//     } else if (_flashMode == FlashMode.auto) {
//       _flashMode = FlashMode.always;
//     } else {
//       _flashMode = FlashMode.off;
//     }

//     await _controller!.setFlashMode(_flashMode);
//     if (mounted) setState(() {});
//   }

//   Future<void> _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//       final image = await _controller!.takePicture();

//       final directory = await getTemporaryDirectory();
//       final file = File('${directory.path}/${DateTime.now()}.jpg');
//       await File(image.path).copy(file.path);

//       if (mounted) {
//         Navigator.of(context).pop(file);
//       }
//     } catch (e) {
//       debugPrint("Error taking picture: $e");
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_controller == null) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: FutureBuilder(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 CameraPreview(
//                   _controller!,
//                   child: LayoutBuilder(
//                     builder: (context, constraints) {
//                       return GestureDetector(
//                         onScaleUpdate: (details) async {
//                           double zoom = (_currentZoom * details.scale)
//                               .clamp(_minZoom, _maxZoom);
//                           await _controller!.setZoomLevel(zoom);
//                           setState(() => _currentZoom = zoom);
//                         },
//                       );
//                     },
//                   ),
//                 ),

//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black,
//                     padding: const EdgeInsets.only(
//                         top: 40, left: 20, right: 20, bottom: 10),
//                     child: IconButton(
//                       icon: Icon(
//                         _flashMode == FlashMode.off
//                             ? Icons.flash_off
//                             : _flashMode == FlashMode.auto
//                                 ? Icons.flash_auto
//                                 : Icons.flash_on,
//                         color: Colors.white,
//                         size: 28,
//                       ),
//                       onPressed: _toggleFlash,
//                     ),
//                   ),
//                 ),

// // Bottom bar
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 20, horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Cancel button
//                         FloatingActionButton(
//                           heroTag: "cancelBtn",
//                           mini: true,
//                           backgroundColor: Colors.transparent,
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: const Icon(Icons.close, color: Colors.white),
//                         ),

//                         // Shutter button
//                         GestureDetector(
//                           onTap: _takePicture,
//                           child: Container(
//                             width: 80,
//                             height: 80,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 5),
//                             ),
//                           ),
//                         ),

//                         // Switch camera
//                         FloatingActionButton(
//                           heroTag: "switchBtn",
//                           mini: true,
//                           backgroundColor: Colors.transparent,
//                           onPressed: _switchCamera,
//                           child: const Icon(Icons.cameraswitch,
//                               color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(
//                 child: CircularProgressIndicator(
//               color: TColors.headingTexts,
//             ));
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:fleetgo_drivers/resources/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  double _currentZoom = 1.0;
  double _maxZoom = 1.0;
  double _minZoom = 1.0;

  File? _capturedImage; // <- Hold the captured image for preview

  @override
  void initState() {
    super.initState();
    _initCamera(_selectedCameraIndex);
  }

  Future<void> _initCamera(int cameraIndex) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize().then((_) async {
      _maxZoom = await _controller!.getMaxZoomLevel();
      _minZoom = await _controller!.getMinZoomLevel();
      if (mounted) setState(() {});
    });

    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras.length;
    await _initCamera(_selectedCameraIndex);
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    if (_flashMode == FlashMode.off) {
      _flashMode = FlashMode.auto;
    } else if (_flashMode == FlashMode.auto) {
      _flashMode = FlashMode.always;
    } else {
      _flashMode = FlashMode.off;
    }

    await _controller!.setFlashMode(_flashMode);
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/${DateTime.now()}.jpg');
      await File(image.path).copy(file.path);

      setState(() {
        _capturedImage = file; // show preview instead of returning immediately
      });
    } catch (e) {
      debugPrint("Error taking picture: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If image is captured, show preview UI
    if (_capturedImage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Image.file(_capturedImage!),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel button
                    FloatingActionButton(
                      heroTag: "cancelPreview",
                      backgroundColor: Colors.red.withAlpha(150),
                      onPressed: () {
                        setState(() {
                          _capturedImage = null; // discard & go back to camera
                        });
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    // Confirm button
                    FloatingActionButton(
                      heroTag: "confirmPreview",
                      backgroundColor: Colors.green.withAlpha(150),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(_capturedImage); // return file
                      },
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Normal Camera UI
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(
                  _controller!,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onScaleUpdate: (details) async {
                          double zoom = (_currentZoom * details.scale)
                              .clamp(_minZoom, _maxZoom);
                          await _controller!.setZoomLevel(zoom);
                          setState(() => _currentZoom = zoom);
                        },
                      );
                    },
                  ),
                ),

                // Flash button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.only(
                        top: 40, left: 20, right: 20, bottom: 10),
                    child: IconButton(
                      icon: Icon(
                        _flashMode == FlashMode.off
                            ? Icons.flash_off
                            : _flashMode == FlashMode.auto
                                ? Icons.flash_auto
                                : Icons.flash_on,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _toggleFlash,
                    ),
                  ),
                ),

                // Bottom bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel button
                        FloatingActionButton(
                          heroTag: "cancelBtn",
                          mini: true,
                          backgroundColor: Colors.transparent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.close, color: Colors.white),
                        ),

                        // Shutter button
                        GestureDetector(
                          onTap: _takePicture,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 5),
                            ),
                          ),
                        ),

                        // Switch camera
                        FloatingActionButton(
                          heroTag: "switchBtn",
                          mini: true,
                          backgroundColor: Colors.transparent,
                          onPressed: _switchCamera,
                          child: const Icon(Icons.cameraswitch,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: TColors.headingTexts,
            ));
          }
        },
      ),
    );
  }
}
