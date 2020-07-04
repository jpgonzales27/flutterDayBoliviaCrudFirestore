import 'package:cloud_firestore/cloud_firestore.dart';

class EmpleosService {
  final _dbFirestore = Firestore.instance;

  //LEER
  Stream<QuerySnapshot> leerDocumentosFirestore() {
    return _dbFirestore.collection('empleos').snapshots();
  }

  //INSERTAR
  void guardarEnFirestore(
      {String nombreColeccion, Map<String, dynamic> valoresmap}) {
    _dbFirestore.collection(nombreColeccion).add(valoresmap);
  }

  //Eliminar
  void eliminarDocumentoFireStore({String nombreColecion, String docId}) {
    _dbFirestore.collection(nombreColecion).document(docId).delete();
  }

  //Actualizar
  void actualizarDocumentoFireStore(
      {String nombreColeccion, String docId, Map<String, dynamic> valoresmap}) {
    _dbFirestore
        .collection(nombreColeccion)
        .document(docId)
        .updateData(valoresmap);
  }

  String seleccionarImage(String tipo) {
    switch (tipo) {
      case 'Programador':
        return 'assets/images/programador.png';
        break;
      case 'Futbolista':
        return 'assets/images/futbol.png';
        break;
      case 'Trainer':
        return 'assets/images/trainer.png';
        break;
      case 'Doctor':
        return 'assets/images/doctor.png';
        break;
      case 'Administrador':
        return 'assets/images/administracion.png';
        break;
      default:
        return 'assets/images/Programador.png';
    }
  }
}
