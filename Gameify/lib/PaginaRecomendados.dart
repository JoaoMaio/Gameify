import 'package:emptyproject/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/listaRecomendadosWidget.dart';

class paginaRecomendados extends StatefulWidget {
  const paginaRecomendados({Key? key}) : super(key: key);

  @override
  _paginaRecomendados createState() => _paginaRecomendados();
}

Future<List<Jogo>> atualizar1() async
{
    try{
      return fetchJogo(2,"a");
    }
    catch(e){
      return [];
    }
}

Future<List<Jogo>> atualizar2() async
{
  try{
    return fetchJogo(5,"a");
  }
  catch(e){
    return [];
    }
}

class _paginaRecomendados extends State<paginaRecomendados> {
  var result1;
  var result2;

  @override
  void initState() { super.initState(); }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        body: Container(
          color: fundo,
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 80),
                children: <Widget>[
                  const SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Top Games on IGDB',
                      style: GoogleFonts.lato(
                        color: texto,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  listaRecomendados(
                    games: atualizar1(),
                    modo: 1,
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      'Most Followed Games on IGDB',
                      style: GoogleFonts.lato(
                        color: texto,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  listaRecomendados(
                    games: atualizar2(),
                    modo: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}

