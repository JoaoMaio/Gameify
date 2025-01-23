import 'package:emptyproject/PaginaFavoritos.dart';
import 'package:emptyproject/PaginaNoticias.dart';
import 'package:emptyproject/PaginaProcurar.dart';
import 'package:emptyproject/PaginaHelp.dart';
import 'package:emptyproject/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'PaginaRecomendados.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenstate createState() => _HomeScreenstate();
}


int index = 0;
int oldindex = 9;

final List<Widget> _pages = [
  paginaRecomendados(),
  newsScreen(),
  PostSearch(),
  FavScreen(),
  HelpScreen()];

class _HomeScreenstate extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: caixas,
        activeColor: texto,
        inactiveColor: darkbluegb,
        currentIndex: index,
        onTap: (ind) {
            setState(() { index = ind;});
          },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.question_mark), label: '')],
    ),
      tabBuilder: (context,index)
      { return CupertinoTabView(builder: (context) {return _pages[index];});}
    );
  }
}
