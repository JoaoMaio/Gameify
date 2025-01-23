import 'package:emptyproject/utils.dart';
import 'package:emptyproject/widgets/FavWidgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'dart:developer' as developer;

class FavScreen extends StatefulWidget {
  const FavScreen({Key? key}) : super(key: key);

  @override
  _FavScreen createState() => _FavScreen();
}

class _FavScreen extends State<FavScreen> {
  var resultJ;

  Future<void> refresh() async {
    setState(() {
      resultJ = fetchFavsFirebase();
    });
  }


  @override
  Widget build(BuildContext contextc) {
    var a = 0;
    if(a == 0)
    {
      resultJ = fetchFavsFirebase();
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Text(
                              'Favorite Games',
                              style: GoogleFonts.lato(
                                color: texto,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          FloatingActionButton(
                            onPressed: ()
                            {
                              resultJ = fetchFavsFirebase();
                              //Navigator.push(contextc,MaterialPageRoute(builder: (context) => FavScreen()));
                              refresh();
                            },
                            child: Icon(Icons.refresh),
                            mini: true,
                            backgroundColor: dark,
                          ),
                        ],
                      ),
                      FavWidgets(jogos: resultJ)
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
