import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
  //https://medium.com/flutterando/aprendendo-a-consumir-uma-api-no-flutter-em-1-minuto-b03c2f93f9af

  //String URL = 'http://localhost:3000/img/todos';
  Dio dio;
  String _base64;
  var imageBb;
  Image teste;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testandoImg();
    BaseOptions options = BaseOptions(
        baseUrl: "http://localhost:3000/img", connectTimeout: 50000);

    dio = new Dio();

    getImage();
  }

  void getImage() async {
    Response response = await dio.get("http://192.168.0.101:3000/buscaImg");

    print(response.data);

    for (int i = 0; i < response.data.length; i++) {
      print(response.data[i]['ImgBlob']);
    }

    //blob = response.data[0]['ImgBlob']['data'];
    //imageBb = Uint8List.fromList(blob);

    //imageBb = base64Decode(blob);

    //Uint8List teste = base64Decode(source)
  }

  Future<List<Widget>> testandoLista() async {
    List<Image> img = [];
    Response response = await dio.get("http://192.168.0.101:3000/buscaImg");

    //print(response.data);

    for (int i = 0; i < response.data.length; i++) {
      //print(response.data[i]['ImgBlob']);
      img.add(Image.memory(response.data[i]['ImgBlob']));
    }

    return img;
  }

  void testandoImg() async {
    Response response = await dio.get("http://192.168.0.101:3000/buscaImg");

    //print(response.data);

    //print(response.data[i]['ImgBlob']);
    setState(() {
      teste = Image.memory(response.data[0]['ImgBlob']);
    });
    //return Image.memory(response.data[0]['ImgBlob']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              child: Text(
                'Olá',
                style: TextStyle(color: Colors.amber, fontSize: 50),
              ),
            ),
          ),
          // Container(
          //   child: Image.network("http://192.168.0.101:3000/buscaImg")
          // ),

          // FutureBuilder(
          //   future: testandoImg(),
          //   builder: (context, snapshot){
          //     return
          //   },
          //
          //)

         // teste
        ],
      ),
    );
  }
}
