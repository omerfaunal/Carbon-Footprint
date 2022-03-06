// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/colors.dart';
import 'package:karbon_ayak_izi/handler/emission_data_handler.dart';
import 'package:karbon_ayak_izi/handler/image_handler.dart';
import 'package:karbon_ayak_izi/handler/storage_services.dart';
import 'package:karbon_ayak_izi/screens/after_scan_screen.dart';
import 'package:karbon_ayak_izi/widgets/category_widget.dart';
import 'package:karbon_ayak_izi/widgets/chart_widget.dart';

class HomeScreen extends StatefulWidget {
  bool isLoadingData = false;
  final CameraDescription camera;
  bool isSecond;

  HomeScreen({Key? key, required this.camera, this.isSecond = false})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = StorageServices();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //bottomNavigationBar: ,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            color: AppColor.departmantWidgetBackground,
          ),
          Container(
            padding: EdgeInsets.only(
                top: screenHeight * 0.06,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05),
            height: screenHeight * 0.65,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)),
              image: DecorationImage(
                image: AssetImage("assets/images/cc-bg-1.jpeg"),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Omer Faruk",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      CupertinoIcons.person_crop_circle,
                      color: Colors.white,
                    )
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Karbon Ayak İzim",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      (EmissionHandler.totalEmission / 1000).toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "ton CO₂/yıl",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Chart(EmissionHandler.monthlyEmission),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.1,
            child: widget.isSecond
                ? CategoryWidget(EmissionHandler.categoricEmission)
                : CategoryWidget([]),
          ),
          Positioned(
            bottom: 0,
            left: screenWidth * 0.3,
            child: Align(
              child: Row(
                children: [
                  Align(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey,
                              spreadRadius: 1)
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ctx) =>
                                    TakePictureScreen(camera: widget.camera))),
                        child: CircleAvatar(
                          radius: 30.0,
                          child: Icon(CupertinoIcons.camera),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  Align(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.grey,
                              spreadRadius: 1)
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ["png", "jpeg", "jpg"],
                          );
                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Dosya seçilmedi"),
                              ),
                            );
                            return;
                          }
                          final String path = result.files.single.path!;
                          final String fileName = result.files.single.name;
                          String value = "";
                          await storage.uploadFile(path, fileName);
                          await storage.getDownloadUrl(fileName).then((valuem) {
                            value = valuem;
                          });
                          await ImageHandler.sendImageAndGetData(value);
                          widget.isSecond = true;
                          setState(() {});
                        },
                        child: CircleAvatar(
                          radius: 30.0,
                          child: Icon(CupertinoIcons.photo),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  bool _isLoading = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final storage = StorageServices();

  @override
  void initState() {
    print('cere');
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fotoğraf çek')),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Fotoğrafın tarandı!",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Bu alışverişteki karbon ayak izin hesaplanıyor.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Fişin tamamen görülebilir ve düz olduğundan emin ol",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 10),
                      CameraPreview(_controller),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            await storage.uploadFile(image.path, image.name);
            storage.getDownloadUrl(image.name).then((value) async {
              await ImageHandler.sendImageAndGetData(value);
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  return HomeScreen(
                    camera: widget.camera,
                    isSecond: true,
                  );
                }),
              );
            });
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return AfterScanScreen(widget.camera,
                    "https://cdn.odatv4.com/images2/2020_10/2020_10_08/screenshot_7.jpg");
              }),
            );
          } catch (e) {
            rethrow;
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
