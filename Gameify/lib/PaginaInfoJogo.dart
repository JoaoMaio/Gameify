import 'package:emptyproject/PaginaFavoritos.dart';
import 'package:emptyproject/utils.dart';
import 'package:emptyproject/widgets/PrecosWidget.dart';
import 'package:emptyproject/widgets/TextoInfoWidget.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoGameScreen extends StatefulWidget {
  final Jogo Jogoo;
  const InfoGameScreen({Key? key, required this.Jogoo}) : super(key: key);

  @override
  _InfoGameScreen createState() => _InfoGameScreen();

}

class _InfoGameScreen extends State<InfoGameScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: fundo,
          title: Text(widget.Jogoo.nome),
        ),
        body: ListView(
          children: <Widget>[
            Cabecalho(context),
            textoUnder(context, widget.Jogoo.nome, "About", widget.Jogoo.summary)
          ],
        )

    );

  }

  //container with image in center
  Widget Cabecalho(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.Jogoo.imagem),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(250.0),
          color: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  bool? mano;

  Future<void> verBool() async {
    setState(() {
      verificarFavorito(widget.Jogoo.nome).then((result) => mano = result);
    });
  }

Widget textoUnder(BuildContext context, String nome, String title, String content){
    if (content != null)
    {
    var result;
    var resultP;
    var a = 0;
    if (a == 0)
    {
      result = fetchRequirement(nome);
      resultP = fetchPrices(nome);
      a++;
    }
    return FutureBuilder(
      future: verificarFavorito(widget.Jogoo.nome),
      builder:(context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        else {
            return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                                Column(
                                children: [
                                FavoriteButton(
                                    isFavorite: snapshot.data as bool,
                                    valueChanged:(_isFavorite)
                                    {
                                      if(_isFavorite)
                                      {
                                        addJogo(widget.Jogoo);
                                      }
                                      else
                                      {
                                        RemoveFavFirebase(widget.Jogoo);
                                      }
                                    },
                                ),
                                Text(title + "\n", style:TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                                Text(content, textAlign: TextAlign.center),
                                ],
                                  ),
                                  const SizedBox(height: 30),
                                  TextoInfoWidget(requirements: result),
                                  const SizedBox(height: 10),
                                  PrecosWidget(precos : resultP),],),),
                          ],
                        ),
                      );
                   }
              },
        );
      }
    return Container();
  }
}