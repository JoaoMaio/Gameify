import 'package:emptyproject/utils.dart';
import 'package:emptyproject/widgets/listaNoticiasWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:developer' as developer;


class newsScreen extends StatefulWidget {
  const newsScreen({Key? key}) : super(key: key);

  @override
  _newsScreen createState() => _newsScreen();
}

class _newsScreen extends State<newsScreen> {
  var resultN;

  Future<void> refresh() async {
    setState(() {
      resultN = fetchNoticia();
    });
  }

  @override
  Widget build(BuildContext contextc) {
    developer.log("noticias");
    var a = 0;
    if(a == 0)
    {
      resultN = fetchNoticia();
      a++;
    }
    final altura = window.physicalSize.height;
    final comprimento = window.physicalSize.width;
    return MaterialApp(
        home: Scaffold(
          extendBody: true,
          body: Container(
            color: fundo,
            child: Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: altura * .23,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      height: altura * 1.6,
                      width: comprimento * 1.6,
                    ),
                  ),
                    ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80),
                    children: <Widget>[
                      const SizedBox(height: 70),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Last News',
                          style: GoogleFonts.lato(
                            color: texto,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    RefreshIndicator(
                      onRefresh: refresh,
                      child : NoticiasListWidget(Noticias: resultN,)
                    )
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