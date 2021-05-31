import 'package:flutter/material.dart';
import 'package:bcstraining/model/clientex.dart';
import 'package:bcstraining/services/clientex_service.dart';

class ClientexForm extends StatefulWidget {
  ClientexForm(this.d);
  Clientex d;

  @override
  _ClientexFormState createState() => _ClientexFormState();
}

class _ClientexFormState extends State<ClientexForm> {
  final _formSateKey = GlobalKey<FormState>();
  Clientex _d = new Clientex();
  //Future<File> _imageFile;
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];

  @override
  Widget build(BuildContext context) {
    print('widget.d');
    print(widget.d.toMap());
    _d = widget.d;
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientex Form'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              final form = _formSateKey.currentState;
              if (form.validate()) {
                form.save();
                if (widget.d != null && widget.d.id != null) {
                  ClientexService.update(widget.d.id, {
                    'nombres': _d.nombres,
                    'apellidos': _d.apellidos,
                    'color': _d.color,
                  });
                } else {
                  ClientexService.add({
                    'nombres': _d.nombres,
                    'apellidos': _d.apellidos,
                    'color': _d.color,
                    'direccion': '',
                  });
                }
                Navigator.pop(context);
              }
            },
            child: Text(
              widget.d != null && widget.d.id != null ? 'EDITAR' : 'AGREGAR',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formSateKey,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              new TextFormField(
                decoration: InputDecoration(
                  labelText: 'nombres',
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.text,
                initialValue: widget.d != null ? widget.d.nombres : "",
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter nombre.';
                  }
                },
                // onSaved: (value) => _name = value,
                onSaved: (val) => setState(() => _d.nombres = val),
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  hintText: 'apellidos ',
                  labelText: 'apellidos',
                ),
                keyboardType: TextInputType.text,
                initialValue: widget.d != null ? widget.d.apellidos : "",
                onSaved: (value) => _d.apellidos = value,
              ),
              new FormField(
                initialValue: widget.d != null ? widget.d.color : "",
                builder: (FormFieldState state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      icon: const Icon(Icons.color_lens),
                      labelText: 'Color',
                    ),
                    isEmpty: _d.color == null || _d.color.isEmpty,
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton(
                        value: _d.color == null || _d.color.isEmpty
                            ? widget.d.color
                            : _d.color,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            //newContact.favoriteColor = newValue;
                            _d.color = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _colors.map((String value) {
                          return new DropdownMenuItem(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
/*
  String validateName(String value) {
    if (value.isEmpty) {
      return "Please Enter Player nombre.";
    } else {
      return null;
    }
  }
*/
//  Widget _previewImage() {
//    return FutureBuilder<File>(
//        future: _imageFile,
//        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//          if (snapshot.connectionState == ConnectionState.done &&
//              snapshot.data != null) {
//            return Image.file(snapshot.data);
//          } else if (snapshot.error != null) {
//            return const Text(
//              'Error picking image.',
//              textAlign: TextAlign.center,
//            );
//          } else {
//            return const Text(
//              'You have not yet picked an image.',
//              textAlign: TextAlign.center,
//            );
//          }
//        });
//  }

//  getImage(){
//    _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//  }

}
