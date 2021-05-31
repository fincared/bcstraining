import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BCSPage extends StatefulWidget {
  BCSPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _BCSPageState createState() => _BCSPageState(this.title);
}

class _BCSPageState extends State<BCSPage> {
  final String title;
  _BCSPageState(this.title);

  int _counter = 0;

  void _incrementCounter() {
    Navigator.pushNamed(context, '/clientex');

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title+" Subir foto  $_counter" ),
        elevation: 0,
        centerTitle: true,
          actions: <Widget>[
            FlatButton(
              clipBehavior: Clip.none,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                Navigator.of(context).pushNamed('camera');

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "+",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Vaca').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasError)
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: Text('Loading...'),
              );
            default:
              return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    final guia = snapshot.data.documents[index];
                    return Center(
                      child: Text('okp.dd..'+index.toString()),
                    );
                  });
          }
        },
      ),
    );
  }


}
