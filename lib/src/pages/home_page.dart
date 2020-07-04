import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterdaycrudfirestore/src/services/empleos_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nombreController;

  List<String> _nombres = ['Juan', 'Ana', 'Daniel'];
  List<String> _trabajos = [
    'Programador',
    'Futbolista',
    'Trainer',
    'Doctor',
    'Administrador',
  ];
  String _opcionSelecciona = 'Programador';

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController();
  }

  EmpleosService empleos = EmpleosService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Day'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            width: double.infinity,
            height: 200,
            child: Card(
              elevation: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _inputTexto(),
                  _crearDropDown(),
                  _botonRegistrar(),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: empleos.leerDocumentosFirestore(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    var nombre = snapshot.data.documents[index]['nombre'];
                    var tipo = snapshot.data.documents[index]['tipo'];
                    var docId = snapshot.data.documents[index].documentID;
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage(empleos.seleccionarImage(tipo)),
                                radius: 50,
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    nombre,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    tipo,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                  )
                                ],
                              ),
                              Icon(Icons.arrow_back_ios)
                            ],
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Editar',
                          color: Colors.black45,
                          icon: Icons.edit,
                          onTap: () {
                            _showDialog(context, docId);
                          },
                        ),
                        IconSlideAction(
                          caption: 'Eliminar',
                          color: Colors.indigo,
                          icon: Icons.delete,
                          onTap: () {
                            empleos.eliminarDocumentoFireStore(
                              nombreColecion: 'empleos',
                              docId: docId,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputTexto() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: nombreController,
        autocorrect: true,
        decoration: InputDecoration(labelText: "Nombre"),
      ),
    );
  }

  Widget _crearDropDown() {
    return DropdownButton(
      value: _opcionSelecciona,
      items: _obtenerOpciones(),
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (opt) {
        setState(() {
          _opcionSelecciona = opt;
        });
      },
    );
  }

  List<DropdownMenuItem<String>> _obtenerOpciones() {
    return _trabajos.map((trabajo) {
      return DropdownMenuItem(
        child: Text(trabajo),
        value: trabajo,
      );
    }).toList();
  }

  Widget _botonRegistrar() {
    return FlatButton(
      child: Text('Registrar', style: TextStyle(color: Colors.white)),
      color: Color.fromRGBO(108, 99, 255, 1),
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      onPressed: () {
        if (nombreController.text.isNotEmpty) {
          empleos.guardarEnFirestore(nombreColeccion: 'empleos', valoresmap: {
            'nombre': nombreController.text,
            'tipo': _opcionSelecciona,
          });
        }
        nombreController.clear();
      },
    );
  }

  _showDialog(BuildContext context, String docID) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _inputTexto(),
                    //_crearDropDown(),
                    DropdownButton(
                      value: _opcionSelecciona,
                      items: _obtenerOpciones(),
                      elevation: 16,
                      style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (opt) {
                        setState(() {
                          _opcionSelecciona = opt;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Color(0xff6063ff)),
                ),
                onPressed: () {
                  nombreController.clear();
                  Navigator.pop(context);
                }),
            FlatButton(
              child: Text(
                'Guardar',
                style: TextStyle(color: Color(0xff6063ff)),
              ),
              onPressed: () {
                if (nombreController.text.isNotEmpty) {
                  empleos.actualizarDocumentoFireStore(
                    nombreColeccion: 'empleos',
                    docId: docID,
                    valoresmap: {
                      'nombre': nombreController.text,
                      'tipo': _opcionSelecciona
                    },
                  );
                }
                nombreController.clear();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
