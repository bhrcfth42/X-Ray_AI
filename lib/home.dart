import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class YapayZekaHome extends StatefulWidget {
  @override
  _YapayZekaHomeState createState() => _YapayZekaHomeState();
}

class _YapayZekaHomeState extends State<YapayZekaHome> {
  bool _isLoading;
  File _image;
  List _output;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("X-Ray Yapay Zeka"),
      ),
      body: _isLoading ? loadingBuildBody(context) : buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image(context),
          output(context),
        ],
      ),
    );
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  chooseImage() async {
    var image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      return null;
    }
    setState(() {
      _isLoading = true;
      _image = File(image.path);
    });
    runModelOnImage();
  }

  runModelOnImage() async {
    var output = await Tflite.runModelOnImage(
      path: _image.path,
      numResults: 2,
      imageMean: 127.5,
      imageStd: 127.5,
      threshold: 0.5,
    );
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        chooseImage();
      },
      child: Icon(
        Icons.image,
      ),
    );
  }

  Widget loadingBuildBody(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  Widget image(BuildContext context) {
    if (_image == null) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Container(),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Image.file(_image),
      );
    }
  }

  Widget output(BuildContext context) {
    if (_output == null) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Text(""),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Text("${_output[0]["label"]}"),
      );
    }
  }
}
