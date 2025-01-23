import 'package:emptyproject/utils.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flappy_search_bar/flappy_search_bar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'PaginaInfoJogo.dart';


class PostSearch extends StatefulWidget {
  const PostSearch({Key? key}) : super(key: key);

  @override
  _PostSearchState createState() => _PostSearchState();
}

class _PostSearchState extends State<PostSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: fundo,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBar<Jogo>(
                cancellationWidget: const Icon(Icons.cancel, color: Colors.black),
                searchBarStyle: SearchBarStyle(
                  backgroundColor: darkblue,
                  borderRadius: BorderRadius.circular(10),
                ),
                loader: const Image(image: AssetImage('assets/sloading.gif')),
                icon: const Icon(Icons.search, color: Colors.black),
                onSearch: verificar,
                textStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                mainAxisSpacing: 10,
                debounceDuration: const Duration(milliseconds: 1000),
                crossAxisCount: 1,
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey[100]),
                onItemFound: (Jogo post, int index) {
                  return ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InfoGameScreen(Jogoo: post)));
                    },
                    tileColor: caixas,
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          NetworkImage(post.imagem), // imagem da web
                      backgroundColor: Colors
                          .transparent, // no matter how big it is, it won't overflow
                    ),
                    title: Text(post.nome, style: GoogleFonts.lato(color: texto), ),
                    subtitle: Text(post.id.toString(), style: GoogleFonts.lato(color: texto),),
                  );
                },
              ),
            ),
          ),
        ));
  }
}