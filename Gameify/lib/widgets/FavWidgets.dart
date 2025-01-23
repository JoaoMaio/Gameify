import 'dart:ui';
import 'package:emptyproject/PaginaInfoJogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils.dart';

class FavWidgets extends StatefulWidget {

  final Future<List<Jogo>> jogos;
  const FavWidgets({Key? key, required this.jogos}) : super(key: key);

  @override
  State<FavWidgets> createState() => _FavWidgets();
}

class _FavWidgets extends State<FavWidgets> {

  late PageController _pageController;
  int lengthOfFile = 0;
  ValueNotifier<double> scrollOffSet = ValueNotifier(1);

  Future<void> refresh() async {
    setState(() {
      getFileLength(widget.jogos).then((value) { lengthOfFile = value; });
    });
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: .50);
    _pageController.addListener(() { scrollOffSet.value = _pageController.page!;});
    try{
      getFileLength(widget.jogos).then((value) { lengthOfFile = value; });
    }catch(e)
    {
      print(e);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final altura = window.physicalSize.height;
    final ratio = window.devicePixelRatio;
    return SizedBox(
        height: altura/ratio - 150,
        child: FutureBuilder(
            future: widget.jogos,
            builder: (context,snapshot) {
              if (!snapshot.hasData)
              {
                return Container();
              }
              else {
                return FutureBuilder(
                    future: getFileLength(widget.jogos),
                    builder: (context,snapshott)
                    {
                      if (!snapshott.hasData)
                      {
                        return Container();
                      }
                      else {
                        return GridView.builder(
                          itemCount: snapshott.data as int,
                          physics: const BouncingScrollPhysics(),
                          controller: _pageController,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                          itemBuilder: (context, index) {
                            return ValueListenableBuilder(
                                valueListenable: scrollOffSet,
                                builder: (context, value, child) {
                                  List<Jogo> lista = snapshot.data as List<Jogo>;
                                  Jogo game = lista[index];
                                  return Align(
                                      child:  GestureDetector(
                                          onTap: (){
                                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InfoGameScreen(Jogoo: game)));
                                            Navigator.push(context,MaterialPageRoute(builder: (context) => InfoGameScreen(Jogoo: game)));
                                            //.then((_) => setState(() {getFileLength(widget.jogos).then((value) { lengthOfFile = value; });}));
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (contextx) => InfoGameScreen(Jogoo: game)));
                                          },
                                          child: Center(
                                            child: Stack (
                                              alignment:  Alignment.bottomLeft,
                                              children: [
                                                Container(
                                                  width: 120,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10.0),
                                                      topRight: Radius.circular(10.0),
                                                      bottomLeft: Radius.circular(10.0),
                                                      bottomRight: Radius.circular(10.0),
                                                    ),
                                                    image: DecorationImage(
                                                        fit: BoxFit.fitWidth,
                                                        image: NetworkImage(
                                                            game.imagem
                                                        )),
                                                  ),
                                                ),
                                                Container(
                                                    padding: const EdgeInsets.only(
                                                      left: 5,
                                                      right: 5,
                                                    ),
                                                    width: 100,
                                                    height: 50,)
                                              ],
                                            ),
                                          )

                                      )
                                  );
                                });
                          },
                        );
                      }
                    }
                  );
              }
            }
        )
    );
  }
}

