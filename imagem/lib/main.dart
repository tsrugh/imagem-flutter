
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

//Lib necessaria para fazer requisição adicionada no pubspec.yaml
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Image',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Imagem'),
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
  
  // Função que retorna o vetor vindo da API decodificando o json para uma list
  // Tipo Future porque é algo que retorna uma chamada assincrona (precisa de um tempo para acontecer)
  Future<List> getImages() async {

    // Resposta da requisição ao servidor, (trocar a url caso o ip da minha net mude)
    http.Response result = await http.get('http://lucassrv.ddns.net/img');

    //Decodificando a resposta JSON em uma List
    return json.decode(result.body);
  }

  // Widget responsavel por fazer o que acontece antes da requisição acabar, snapshot é onde está guardado os estados da requisição
  // Verificando os estados da requisição caso esteja terminada, renderiza meu widget com as imagens no caso _createGifTble
  Widget fazerBuilder(context, snapshot) {

    switch (snapshot.connectionState) {
      case ConnectionState.waiting:
      case ConnectionState.none:
        return Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          // Circulo q fica rodando esperando a requisição acontecer
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 5,
          ),
        );
      default:
        if (snapshot.hasError)
        // Se deu algum erro, vai me retornar um container vazio(Preguiça de por algo)
          return Container();
        else
        // se não renderiza o meu widget
          return _createGifTble(context, snapshot);
    }
  }

  //Widget responsavel por rendereizar as imagens
  Widget _createGifTble(BuildContext context, AsyncSnapshot snapshot) {

    // GridView é como se fosse uma lista, itemCount é a quantidade de itens que vai ter na lista, e o itemBuilder é o que ela vai renderizar por item
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      // A quantidade de itens vai ser o tamanho do vetor retornado da api
      itemCount: snapshot.data.length,
      //Renderizando o item, o index é a posição do vetor
      itemBuilder: (context, index) {

        return GestureDetector(
          // Image.memory para renderizar uma imagem em base64 (na verdade para renderizar uma imagem que está em bytes)
          child: Image.memory(
            //Usando o base64Decode para transformar o dado de base64 para Unit8List (bytes) para que seja lido pelo image.memory
            //Passando o item que tiver na posição atual da lista, o index
            base64Decode(snapshot.data[index]),
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // O FutureBuilder é o que vai possibilitar o uso do future (uma requisição, ou qualquer chamada assincrona)
        body: FutureBuilder(
        // Future é a função que retorna o future, aquela que fez a requisição  
        future: getImages(), 
        // o builder é aquela com as instruções para renderizar se a requisição já acabou ou deu erro
        builder: fazerBuilder));
  }
}
//****************************************************************************** */
// LER O PUBSPEC.YAML
//******************************************************************************** */