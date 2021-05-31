import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:bcstraining/model/vaca.dart';
import 'package:bcstraining/services/vaca_service.dart';

// Una pantalla que permite a los usuarios tomar una fotografía utilizando una cámara determinada.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Para visualizar la salida actual de la cámara, es necesario
    // crear un CameraController.
    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      widget.camera,
      // Define la resolución a utilizar
      ResolutionPreset.high,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Asegúrate de deshacerte del controlador cuando se deshaga del Widget.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Debes esperar hasta que el controlador se inicialice antes de mostrar la vista previa
      // de la cámara. Utiliza un FutureBuilder para mostrar un spinner de carga
      // hasta que el controlador haya terminado de inicializar.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Si el Future está completo, muestra la vista previa
            return CameraPreview(_controller);
          } else {
            // De lo contrario, muestra un indicador de carga
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Agrega un callback onPressed
        onPressed: () async {
          // Toma la foto en un bloque de try / catch. Si algo sale mal,
          // atrapa el error.
          try {
            // Ensure the camera is initialized
            await _initializeControllerFuture;

            // Construye la ruta donde la imagen debe ser guardada usando
            // el paquete path.
            final path = join(
              //
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            print('path=' + path.toString());

            // Attempt to take a picture and log where it's been saved
            await _controller.takePicture(path);
            // En este ejemplo, guarda la imagen en el directorio temporal. Encuentra
            // el directorio temporal usando el plugin `path_provider`.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // Si se produce un error, regístralo en la consola.
            print(e);
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatefulWidget {
  //FincaForm(this.d);
  //Finca d;
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);


  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState(this.imagePath);
}
// Un Widget que muestra la imagen tomada por el usuario
class _DisplayPictureScreenState extends State<DisplayPictureScreen> {

  _DisplayPictureScreenState(this.imagePath);
  final String imagePath;
  final _formStateKey = GlobalKey<FormState>();
  Vaca _d = new Vaca();

  @override
  void initState() {
    super.initState();
  }
  //setState(() {
  //});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Display the Picture'),
          actions: <Widget>[
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final form = _formStateKey.currentState;
              if (form.validate()) {
                form.save();
                final vaca = {
                  'finca': _d.finca,
                  'score': _d.score,
                  'raza': _d.raza,
                  'img': imagePath,
                };
                print(vaca);
                // 'distritoNombre': _distritoNombre ?? '',

                VacaService.add(vaca);

                Navigator.of(context).pop();
              }
            }),
          ],
      ),
      // La imagen se almacena como un archivo en el dispositivo. Usa el
      // constructor `Image.file` con la ruta dada para mostrar la imagen
      body: Form(
        key: _formStateKey,
        child: ListView(
          children: <Widget>[
            Image.file(File(this.imagePath)),

            Container(
              margin: EdgeInsets.only(top: 10, left: 30, right: 30),
              child: TextFormField(
                maxLength: 2,
                decoration: InputDecoration(
                  labelText: 'Puntuación CC:',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
                onSaved: (val) => setState(() => _d.score = val),
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 10, left: 30, right: 30),
              child: TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'raza:',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
                onSaved: (val) => setState(() => _d.raza = val),
              ),
            ),


            Container(
              margin: EdgeInsets.only(top: 10, left: 30, right: 30),
              child: TextFormField(
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'finca:',
                ),

                onSaved: (val) => setState(() => _d.finca = val),
              ),
            ),




          ],
        ),
      ),
    );
  }
}
