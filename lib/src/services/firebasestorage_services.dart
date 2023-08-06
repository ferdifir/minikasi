import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageServices {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadPDFFile(File file) async {
    String fileName = file.path.split('/').last;
    Reference ref = _firebaseStorage.ref().child('materi_pdf/$fileName');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}