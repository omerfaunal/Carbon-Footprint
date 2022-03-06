import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:karbon_ayak_izi/database/product_database.dart';
import 'package:karbon_ayak_izi/handler/emission_data_handler.dart';
import 'package:karbon_ayak_izi/handler/image_handler.dart';
import 'package:karbon_ayak_izi/screens/home_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:karbon_ayak_izi/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  await Firebase.initializeApp();
  await ProductDatabase.initDb();
  await GetStorage.init();
  await EmissionHandler.getData();
  runApp(MyApp(
    camera: firstCamera,
  ));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp({Key? key, required this.camera}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => WelcomeScreen(),
        "/home-screen": (context) => HomeScreen(camera: camera),
      },
    );
  }
}
