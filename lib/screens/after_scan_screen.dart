import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/handler/image_handler.dart';
import 'package:karbon_ayak_izi/screens/home_screen.dart';

class AfterScanScreen extends StatefulWidget {
  CameraDescription camera;
  String uri;
  AfterScanScreen(this.camera, this.uri, {Key? key}) : super(key: key);

  @override
  State<AfterScanScreen> createState() => _AfterScanScreenState();
}

class _AfterScanScreenState extends State<AfterScanScreen> {
  bool _isLoading = false;

  getData(String uri) async {
    await ImageHandler.sendImageAndGetData(uri);
    setState(() {
      _isLoading == true;
    });
  }

  @override
  void initState() {
    if (_isLoading) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            camera: widget.camera,
            isSecond: true,
          ),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getData(widget.uri);
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 80),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Text("Fotoğrafın tarandı!"),
          SizedBox(height: 20),
          Text("Bu alışverişteki karbon ayak izin hesaplanıyor."),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ),
    ));
  }
}
