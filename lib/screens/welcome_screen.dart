import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int index = 0;

  var imageList = [
    AssetImage("assets/images/1.jpeg"),
    //AssetImage("assets/images/2.jpeg"),
    //AssetImage("assets/images/3.png")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageList[index],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 5,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                iconSize: 80,
                color: Colors.white,
                onPressed: () {
                  index += 1;
                  if (index == imageList.length) {
                    Navigator.pushReplacementNamed(context, "/home-screen");
                  } else {
                    setState(() {});
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
