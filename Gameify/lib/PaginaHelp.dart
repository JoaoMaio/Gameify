import 'dart:ui';
import 'package:emptyproject/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var size = 130.0;

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenstate createState() => _HelpScreenstate();
}

class _HelpScreenstate extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    final comprimento = window.physicalSize.width;
    final ratio = window.devicePixelRatio;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: fundo,
        body: Center(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 80),
            children: <Widget>[
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Information',
                  style: GoogleFonts.lato( color: texto, fontSize: 25, fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'This app is a combination of various different websites and databases to give you information about the games you love!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato( color: lightgrey, fontSize: 20, fontWeight: FontWeight.bold, ),
                ),
              ),
              const SizedBox(height: 70),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: (comprimento/ratio)/2-60),
                child: Text(
                  'Powered By:',
                  style: GoogleFonts.lato( color: texto, fontSize: 18, fontWeight: FontWeight.bold,),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 400,
                child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 80),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              llaunchUrl(Uri.parse("https://gamesystemrequirements.com"));}, // Image tapped
                          child: Image.asset(
                            'assets/gsr.jpeg',
                            height: size,
                            width: size,
                          ),
                          ),
                          GestureDetector(
                            onTap: () {llaunchUrl(Uri.parse("https://www.igdb.com"));}, // Image tapped
                          child: Image.asset(
                            'assets/igdb.png',
                            height: size,
                            width: size,
                          ),
                          ),
                        ],
                      ),
                      Column(
                        children: [

                          GestureDetector(
                            onTap: () {llaunchUrl(Uri.parse("https://isthereanydeal.com"));}, // Image tapped
                            child: Image.asset(
                              'assets/isthere.png',
                              height: size,
                              width: size,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {llaunchUrl(Uri.parse("https://www.rockpapershotgun.com/news"));}, // Image tapped
                            child: Image.asset(
                              'assets/rps.jpg',
                              height: size,
                              width: size,
                            ),
                          ),
                        ],
                      ),
                      ],
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
