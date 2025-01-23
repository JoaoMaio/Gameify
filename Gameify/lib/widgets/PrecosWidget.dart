import 'package:emptyproject/PaginaInfoJogo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils.dart';

class PrecosWidget extends StatefulWidget {
  final Future<List<Price>> precos;

  const PrecosWidget({Key? key, required this.precos}) : super(key: key);

  @override
  State<PrecosWidget> createState() => _PrecosWidget();
}

class _PrecosWidget extends State<PrecosWidget> {

  late PageController _pageController;
  int lengthOfFile = 0;
  ValueNotifier<double> scrollOffSet = ValueNotifier(1);

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: .50);
    _pageController.addListener(() { scrollOffSet.value = _pageController.page!;});
    getFileLength(widget.precos).then((value) { lengthOfFile = value; });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        child: FutureBuilder(
            future: widget.precos,
            builder: (context,snapshot) {
              if (!snapshot.hasData)
              {
                return ListView.builder(
                  itemCount: lengthOfFile,
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                        valueListenable: scrollOffSet,
                        builder: (context, value, child) {
                          return Align(
                            child:  GestureDetector(
                              child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.04),
                                  ),
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                              ),
                            ),
                          );
                        });
                  },
                );
              }
              else {
                return ListView.builder(
                  itemCount: lengthOfFile,
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                        valueListenable: scrollOffSet,
                        builder: (context, value, child) {
                          List<Price> lista = snapshot.data as List<Price>;
                          Price price = lista[index];
                          return Align(
                              child:  GestureDetector(
                                onTap: (){
                                  llaunchUrl(Uri.parse(price.link));
                                },
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(color: fundo),
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                                  child:
                                  Row(
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(22),
                                          ),
                                          child: Image.network(price.imagem),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Normal:" + price.priceAntigo.toStringAsFixed(2) + "€",
                                          style: GoogleFonts.lato(color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Current:" + price.priceAtual.toStringAsFixed(2) + "€",
                                          style: GoogleFonts.lato(color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.money_off, color: Colors.amber),
                                        Text(
                                          "" + price.desconto.toStringAsFixed(0) + "%",
                                          style: GoogleFonts.lato(color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    )
                                  ),
                                ),
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