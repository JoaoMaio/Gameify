import 'package:flutter/material.dart';
import '../utils.dart';

class TextoInfoWidget extends StatefulWidget {
  final Future<List<Requirement>> requirements;


  const TextoInfoWidget({Key? key, required this.requirements}) : super(key: key);
  @override
  State<TextoInfoWidget> createState() => _TextoInfoWidgetState();
}

class _TextoInfoWidgetState extends State<TextoInfoWidget> {
  final TextStyle estilonegrito = TextStyle(color:Colors.black, fontSize:15,fontWeight:FontWeight.bold);
  final TextStyle estilopequeno = TextStyle(color:Colors.black, fontSize:14, fontWeight: FontWeight.normal);
  final TextStyle estilogrande = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: FutureBuilder(
            future: widget.requirements,
            builder: (context,snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              } else
                {
                    try{
                      List<Requirement> lista = snapshot.data as List<Requirement>;
                      Requirement reqMin = lista[0];
                      Requirement reqMax = lista[1];
                      return
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                          children: [
                            Text("Minimum Requirements:\n", style: estilogrande),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: [
                            RichText(
                            text: TextSpan(text: "CPU: ", style: estilonegrito,
                            children : [TextSpan(text: reqMin.cpu,style: estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "GPU: ", style:estilonegrito,
                            children : [TextSpan(text: reqMin.gpu,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "RAM: ", style:estilonegrito,
                            children : [TextSpan(text: reqMin.ram,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "OS: ", style:estilonegrito,
                            children : [TextSpan(text: reqMin.os,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "DirectX: ", style:estilonegrito,
                            children : [TextSpan(text: reqMin.dx,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan( text: "Storage: ", style:estilonegrito,
                            children : [TextSpan(text: reqMin.storage,style:estilopequeno)],),),
                              Text("\n"),
                            ]
                            ),
                            Text("Recommended Requirements:\n", style:estilogrande),
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.start ,
                            children: [
                            RichText(
                            text: TextSpan(text: "CPU: ", style:estilonegrito,
                            children : [TextSpan(text: reqMax.cpu,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "GPU: ", style:estilonegrito,
                            children : [TextSpan(text: reqMax.gpu,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "RAM: ",style:estilonegrito,
                            children : [TextSpan(text: reqMax.ram,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "OS: ",style:estilonegrito,
                            children : [TextSpan(text: reqMax.os,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "DirectX: ",style:estilonegrito,
                            children : [TextSpan(text: reqMax.dx,style:estilopequeno)],),),
                            RichText(
                            text: TextSpan(text: "Storage: ", style:estilonegrito,
                            children : [TextSpan(text: reqMax.storage,style:estilopequeno)],),),
                            ]
                            ),
                            ]
                        );
                      }
                      on Error catch (_)
                      {
                        return const Text(
                          "No info about this game",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            backgroundColor: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                  }
                }
        )
    );
  }
}