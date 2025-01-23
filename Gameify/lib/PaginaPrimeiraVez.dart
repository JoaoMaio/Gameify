import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:emptyproject/PaginaBottomNavigationBar.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

Widget pagina({
  required Color cor,
  required String titulo,
  required String imagem,
  required String conteudo,
  required double margem,
}) =>
    Container(
      color: cor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagem,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SizedBox(
            height: margem,
          ),
          Text(
            titulo,
            style: TextStyle(
              color: Colors.teal.shade700,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              conteudo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final pagecontroller = PageController();
  bool ultimaPagina = false;

  void trash() {
    pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 50),
        child: PageView(
          controller: pagecontroller,
          onPageChanged: (index) {
            setState(() => ultimaPagina = (index == 2));
          },
          children: [
            pagina(
              cor: const Color.fromRGBO(161, 153, 126, 1),
              imagem: 'assets/fundo1.jpg',
              titulo: 'Procurar',
              conteudo: 'Procurar qualquer jogo de computador.',
              margem: 60,
            ),
            pagina(
              cor: const Color.fromRGBO(190, 128, 255, 1),
              imagem: 'assets/procurar.gif',
              titulo: 'Obter',
              conteudo: 'Obter informação importante sobre esse jogo.',
              margem: 163,
            ),
            pagina(
              cor: const Color.fromRGBO(239, 242, 234, 1),
              imagem: 'assets/money.gif',
              titulo: 'Preços',
              conteudo:
                  'Verificar os preços em variadas lojas',
              margem: 60,
            ),
          ],
        ),
      ),
      bottomSheet: ultimaPagina
          ? TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  primary: Colors.white,
                  backgroundColor: Colors.teal.shade700,
                  minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: const Text(
                'Vamos Começar',
                style: TextStyle(fontSize: 24),
              ))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => pagecontroller.jumpToPage(2),
                      child: const Text('SKIP')),
                  Center(
                    child: SmoothPageIndicator(
                      controller: pagecontroller,
                      count: 3,
                      effect: SwapEffect(
                        spacing: 16,
                        dotColor: Colors.black45,
                        activeDotColor: Colors.amber.shade600,
                      ),
                      onDotClicked: (index) => pagecontroller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.easeInOut),
                    ),
                  ),
                  TextButton(
                      onPressed: () => pagecontroller.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.easeInOut),
                      child: const Text('NEXT')),
                ],
              ),
            ));
}
