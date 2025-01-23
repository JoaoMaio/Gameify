import 'package:emptyproject/PaginaInfoJogo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils.dart';

class listaRecomendados extends StatefulWidget {
  final Future<List<Jogo>> games;
  final int modo;
  const listaRecomendados({Key? key, required this.games, required this.modo}) : super(key: key);
  @override
  State<listaRecomendados> createState() => _listaRecomendadosState();
}

class _listaRecomendadosState extends State<listaRecomendados> {
  late PageController _pageController;
  int lengthOfFile = 0;
  ValueNotifier<double> scrollOffSet = ValueNotifier(1);

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: .50);
    _pageController.addListener(() { scrollOffSet.value = _pageController.page!;});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getFileLength(widget.games).then((value) { lengthOfFile = value; });
    return SizedBox(
      height: 300,
      child: FutureBuilder(
        future: widget.games,
        builder: (context,snapshot) {
          if (!snapshot.hasData)
          {
            return PageView.builder(
              itemCount: 5,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                    valueListenable: scrollOffSet,
                    builder: (context, value, child) {
                      return Align(
                        child: Container(
                          height: 220,
                          width: 232,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.04) ,
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                height: 120,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Spacer(),
                              Row(),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }
          else {
            return PageView.builder(
              itemCount: lengthOfFile,
              physics: const BouncingScrollPhysics(),
              controller: _pageController,
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                    valueListenable: scrollOffSet,
                    builder: (context, value, child) {
                      List<Jogo> lista = snapshot.data as List<Jogo>;
                      Jogo game = lista[index];
                      return Align(
                        child:  GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => InfoGameScreen(Jogoo: game,)));
                          },
                          child: Container(
                          height: 220,
                          width: 232,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: caixas,
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                height: 120,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Image.network(game.imagem),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                game.nome,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  if(widget.modo == 2)...[
                                      const Icon(Icons.account_box_rounded , color: Colors.amber),
                                      Text(
                                        game.follow.toString(),
                                        style: GoogleFonts.lato(color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ]
                                  else...[
                                    const Icon(Icons.star, color: Colors.amber),
                                    Text(
                                      ((game.rating)/10).toStringAsFixed(2),
                                      style: GoogleFonts.lato(color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ]
                                ],
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                        )
                      );
                    });
              },
            );
          }
        }
      )
    );
  }
}