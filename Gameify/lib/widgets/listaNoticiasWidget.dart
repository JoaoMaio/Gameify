import 'package:flutter/material.dart';
import 'dart:ui';
import '../utils.dart';

class NoticiasListWidget extends StatefulWidget {

  final Future<List<Noticia>> Noticias;
  const NoticiasListWidget({Key? key, required this.Noticias}) : super(key: key);
  @override
  State<NoticiasListWidget> createState() => _NoticiasListWidget();
}

class _NoticiasListWidget extends State<NoticiasListWidget> {
  late PageController _pageController;

  ValueNotifier<double> scrollOffSet = ValueNotifier(1);

  int lengthOfFile = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 0.3);
    _pageController.addListener(() { scrollOffSet.value = _pageController.page!;});
    getFileLength(widget.Noticias).then((value) { lengthOfFile = value;});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final altura = window.physicalSize.height;
    final ratio = window.devicePixelRatio;
    return SizedBox(
        height: altura/ratio - 150,
        child: FutureBuilder(
            future: widget.Noticias,
            builder: (context,snapshot) {
              if (!snapshot.hasData)
              {
                return ListView.builder(
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
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.04) ,
                              ),
                              margin: const EdgeInsets.only(top: 10),
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
                return ListView.builder(
                  itemCount: lengthOfFile,
                  physics: const BouncingScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                        valueListenable: scrollOffSet,
                        builder: (context, value, child) {
                          List<Noticia> lista = snapshot.data as List<Noticia>;
                          Noticia n = lista[index];
                          return Align(
                              child:  GestureDetector(
                                onTap: (){
                                  llaunchUrl(Uri.parse(n.link));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: caixas,
                                  ),
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(22),
                                        ),
                                        child: Image.network(
                                            n.imagem,
                                            fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(r''+n.texto1 + "\n\n✍️" + n.texto2,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 15),
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