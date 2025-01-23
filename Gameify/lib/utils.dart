import 'dart:ui';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

String ip = "188.81.147.162:8080";
String nomeAnterior = "";
Future<List<Jogo>> listaAnterior = [] as Future<List<Jogo>>;

////////////////////////////////////////////////////////////////

Future<List<Jogo>> fetchJogo(int modo , String nomeJogo) async {
  final response = await http.get(Uri.parse('http://$ip/?tipo=$modo&nomeJogo=$nomeJogo'));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonresponse = json.decode(response.body);

    if (jsonresponse.toString() == "[]") {
      return [];
    } else {
      List<Jogo> listaFinal = [];

      for (var i = 0; i < jsonresponse.length; i++) {
        listaFinal.add(Jogo.fromJson(jsonresponse[i]));
      }

      return listaFinal;
    }
  } else {
    throw Error();
  }
}

Future<List<Jogo>> verificar(String nomeJogo) async {
  if (nomeAnterior != nomeJogo) {
    nomeAnterior = nomeJogo;
    return listaAnterior = fetchJogo(1,nomeJogo);
  }

  return listaAnterior;
}

////////////////////////////////////////////////////////////////

Future<List<Requirement>> fetchRequirement(String nomeJogo) async {
  final response = await http
      .get(Uri.parse('http://$ip/?tipo=3&nomeJogo=$nomeJogo'));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonresponse = json.decode(response.body);

    if (jsonresponse.toString() == "[]") {
      return [];
    } else {
      List<Requirement> listaFinal = [];

      for (var i = 0; i < jsonresponse.length; i++) {
        listaFinal.add(Requirement.fromJson(jsonresponse[i]));
      }

      return listaFinal;
    }
  } else {
    throw Error();
  }
}

//////////////////////////////////

Future<String?> getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else
  if(Platform.isAndroid)
  {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}

var users = FirebaseFirestore.instance.collection('users');

addJogo(Jogo jogo) async{
  String? id = await getId();

  try {
    var doc = await users.doc(id).get();//se existir
    if(doc.exists == true)
      {
        return users.doc(id).update({
          "jogos": FieldValue.arrayUnion(
              [
                {
                  'id': jogo.id,
                  'nome': jogo.nome,
                  'imagem': jogo.imagem,
                  'rating': jogo.rating,
                  'ratingCount': jogo.ratingCount,
                  'summary': jogo.summary,
                  'follow': jogo.follow,
                }
              ]
          )
        }).then((value) => print("Game data Added update"))
            .catchError((error) => print("Game couldn't be added."));
      }
    else
      {
        return users.doc(id).set({
          "jogos" : FieldValue.arrayUnion(
              [
                {
                  'id': jogo.id,
                  'nome': jogo.nome,
                  'imagem': jogo.imagem,
                  'rating': jogo.rating,
                  'ratingCount': jogo.ratingCount,
                  'summary': jogo.summary,
                  'follow': jogo.follow,
                }
              ]
          )
        }).then((value) => print("Game data Added set"))
            .catchError((error) => print("Game couldn't be added."));
      }

  } catch (e) {
    throw e;
  }
}

Future<List<Jogo>> fetchFavsFirebase() async{
  String? id = await getId();
  var casa;
  try{
  FirebaseFirestore rootRef = FirebaseFirestore.instance;
  CollectionReference applicationsRef = rootRef.collection("users");
  DocumentReference applicationIdRef = applicationsRef.doc(id);
    casa = await applicationIdRef.get().then((datasnapshot)
    {
      var items = datasnapshot.get("jogos").map((i) {
        var z = Map<String, dynamic>.from(i);
        return Jogo.fromMap(z);
      }).toList();
      var theRealItems = List<Jogo>.from(items);
      return theRealItems;
    });
  }
  catch(e) { return [];}

  return casa;
}

Future<bool?> verificarFavorito(String nomeJogo) async{
  String? id = await getId();
  var casa;

  try
  {
  FirebaseFirestore rootRef = FirebaseFirestore.instance;
  CollectionReference applicationsRef = rootRef.collection("users");
  DocumentReference applicationIdRef = applicationsRef.doc(id);
      casa = await applicationIdRef.get().then((datasnapshot)
      {
        var items = datasnapshot.get("jogos").map((i) {
          var z = Map<String, dynamic>.from(i);
          return Jogo.fromMap(z);
        }).toList();
        var theRealItems = List<Jogo>.from(items);
        return theRealItems;
      });

      var listafinal = List<Jogo>.from(casa);

      for(int i = 0; i < listafinal.length; i++)
      {
        if(nomeJogo == listafinal[i].nome) {
          return true;
        }
      }
}
catch(e)
  {
    return false;
  }

  return false;
}

RemoveFavFirebase(Jogo jogo) async {
  String? id = await getId();

  try {
    var doc = await users.doc(id).get();//se existir
    if(doc.exists == true)
    {
      return users.doc(id).update({
        "jogos": FieldValue.arrayRemove(
            [
              {
                'id': jogo.id,
                'nome': jogo.nome,
                'imagem': jogo.imagem,
                'rating': jogo.rating,
                'ratingCount': jogo.ratingCount,
                'summary': jogo.summary,
                'follow': jogo.follow,
              }
            ]
        )
      });
    }
  } catch (e) {
    throw e;
  }
}

////////////////////////////////////////////////////////////////

Future<List<Noticia>> fetchNoticia() async {
  final response = await http.get(Uri.parse('http://$ip/?tipo=4&nomeJogo=a'));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonresponse = json.decode(response.body);

    if (jsonresponse.toString() == "[]") {
      return [];
    } else {
      List<Noticia> listaFinal = [];
      for (var i = 0; i < jsonresponse.length; i++) {
        listaFinal.add(Noticia.fromJson(jsonresponse[i]));
      }

      return listaFinal;
    }
  } else {
    throw Error();
  }
}

////////////////////////////////////////////////////////////////

Future<List<Price>> fetchPrices(String nomeJogo) async {
  final response = await http.get(Uri.parse('http://$ip/?tipo=6&nomeJogo=$nomeJogo'));

  if (response.statusCode == 200 || response.statusCode == 201) {
    final jsonresponse = json.decode(response.body);

    if (jsonresponse.toString() == "[]") {
      return [];
    } else {
      List<Price> listaFinal = [];
      for (var i = 0; i < jsonresponse.length; i++) {
        listaFinal.add(Price.fromJson(jsonresponse[i]));
      }

      return listaFinal;
    }
  } else {
    throw Error();
  }
}

////////////////////////////////////////////////////////////////


Future<int> getFileLength(Lista) async{
  return await Lista.then((value) {
    return value.length;
  });
}


llaunchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) throw 'Could not launch $url';
}


///////////////////////////////////////////////////////////////


int _toInt(id) => id is int ? id : int.parse(id);

class Noticia {
  late String texto1;
  late String texto2;
  late String imagem;
  late String link;

  Noticia(this.texto1, this.texto2, this.imagem, this.link);

  factory Noticia.fromJson(Map<String, dynamic> json) =>
      Noticia(json['texto1'], json['texto2'], json['imagem'], json['link']);

}

class Jogo {
  late int id;
  late String nome;
  late String imagem;
  late double rating;
  late int ratingCount;
  late String summary;
  late int follow;

  Jogo(this.id, this.nome, this.imagem, this.rating, this.ratingCount, this.summary, this.follow);

  factory Jogo.fromJson(Map<String, dynamic> json) =>
      Jogo(_toInt(json['id']), json['nome'], json['imagem'], json['rating'], _toInt(json['rating_count']), json['summary'], _toInt(json['follow']));

  Jogo.fromMap(Map<String, dynamic> map): id = _toInt(map['id']), nome = map['nome'],imagem= map['imagem'], rating= map['rating'], ratingCount = _toInt(map['ratingCount']), summary= map['summary'], follow= _toInt(map['follow']);

}

class Price {
  late String nome;
  late String link;
  late double priceAntigo;
  late double priceAtual;
  late double desconto;
  late String imagem;

  Price(this.nome,this.link, this.priceAntigo, this.priceAtual, this.desconto, this.imagem);

  factory Price.fromJson(Map<String, dynamic> json) =>
      Price(json['nome'], json['link'], json['precoAntigo'], json['precoAtual'], json['desconto'], json['imagem']);
}

class Requirement {
  late String cpu;
  late String ram;
  late String gpu;
  late String dx;
  late String os;
  late String storage;

  Requirement(this.cpu, this.ram, this.gpu, this.dx, this.os, this.storage);

  factory Requirement.fromJson(Map<String, dynamic> json) => Requirement(
      (json['cpu']),
      json['ram'],
      json['gpu'],
      json['dx'],
      json['os'],
      json['storage']);
}

Color fundo = const Color.fromRGBO(48, 56, 65, 1);
Color dark = const Color.fromRGBO(11, 12, 16, 1);
Color caixas = const Color.fromRGBO(38, 46, 55,1); //caixas da pagina inicial
Color lightgrey = const Color.fromRGBO(197, 198, 199, 1);
Color? darkblue = Colors.cyan[900]; //bottomNavigationBar não selecionados
Color darkbluegb = const Color.fromRGBO(0, 96, 99, 1);
Color? texto = Colors.cyan[400]; //Texto e bottomNavigationBar
