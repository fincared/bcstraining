import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bcstraining/model/clientex.dart';
import 'package:bcstraining/pages/clientex/clientex_form.dart';
import 'package:bcstraining/services/clientex_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClientexMain extends StatefulWidget {
  ClientexMain({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClientexMainState createState() => _ClientexMainState();
}

class _ClientexMainState extends State<ClientexMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title+' Clientex '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            tooltip: 'Nuevo',
            onPressed: () {
              _navigateToForm();
            },
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: new ListView(
          children: <Widget>[
            _buildBody(context),
          ],
        ),
        onRefresh: () async {
          Navigator.pushReplacementNamed(context, '/clientex');
          return null;
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: ClientexService.getList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData)
          return const Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data.documents.length > 0) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 8),
                  child: Text(
                    'Mantenimiento de Clientex',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "${snapshot.data.documents.length.toString()} regs. ",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                _buildList(context, snapshot.data.documents),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              "There is no data.",
              style: Theme.of(context).textTheme.title,
            ),
          );
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildItem(context, data)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot data) {
    var d = Clientex.fromMap(data.data);
    d.id = data.documentID;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        delegate: SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: 'Edit',
            color: Colors.grey.shade200,
            icon: Icons.edit,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ClientexForm(d),
                fullscreenDialog: true,
              ),
            ),
            closeOnTap: false,
          ),
          new IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              closeOnTap: false,
              onTap: () {
                _buildConfirmationDialog(context, data.documentID);
              }),
        ],
        key: ValueKey(d.nombres),
        child: Container(
          child: ListTile(
            title: Text(d.nombres +
                '  ' +
                d.apellidos +
                '  ' +
                DateFormat('yyyy-MM-dd kk:mm').format(d.updated)),
            onTap: () => print(d.toMap()),
          ),
        ),
      ),
    );
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Reg. will be deleted'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  ClientexService.delete(documentID);
                  Navigator.of(context).pop(true);
                }),
          ],
        );
      },
    );
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ClientexForm(new Clientex()),
        fullscreenDialog: true,
      ),
    );
  }
}
