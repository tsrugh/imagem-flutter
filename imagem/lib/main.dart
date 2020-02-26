import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:imagem/Model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> getImages() async {
    http.Response result = await http.get('http://179.125.89.8:3000/img');

    // print('**********************************************************');
    // print(json.decode(result.body));
    // print('**********************************************************');
    return json.decode(result.body);
  }

  Widget fazerBuilder(context, snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.none:
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5,
          ),
        );
      default:
        if (snapshot.hasError)
          return Container();
        else
          return _createGifTble(context, snapshot);
    }
  }

  Widget _createGifTble(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      //itemCount: snapshot.data.length,
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        print('--------------------------------------------------');
        print(snapshot.data[index]);
        print('--------------------------------------------------');
        //print(snapshot.data[0]['imgBlob']['data']);
        // Clicar na imagem
        return GestureDetector(
          //child: Container(),
          child: Image.memory(
            base64Decode(snapshot.data[index]),
            //snapshot.data['data'][index]['images']['fixed_height']['url'],
            //base64Decode(snapshot.data[0]['imgBlob']['data'].toString()),
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getImages().then((map) {
      //print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(future: getImages(), builder: fazerBuilder));
  }
}
