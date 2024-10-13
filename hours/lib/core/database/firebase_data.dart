import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hours/core/share/custom_snackbar.dart';

import '../model/employees_record.dart';

Future<int> uploadRecord(EmployeesRecord record) async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String collectionName = email.substring(0, email.indexOf("@"));
  Map<String, dynamic> recordUpload = {
    "${record.key}": {
      'startAt': Timestamp.fromDate(record.startAt),
      'finishAt': Timestamp.fromDate(record.finishAt),
      'breakSAt': Timestamp.fromDate(record.breakSAt),
      'breakFAt': Timestamp.fromDate(record.breakFAt)
    }
  };
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != [ConnectivityResult.none]) {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(record.employeeName)
          .set(recordUpload, SetOptions(merge: true));
      return 1;
    } catch (e) {
      return 0;
    }
  } else {
    return 0;
  }
}

Future<bool> deletDocument(String document) async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String collectionName = email.substring(0, email.indexOf("@"));
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != [ConnectivityResult.none]) {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(document)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  } else {
    return false;
  }
}

getAllFirebaseData() async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String collectionName = email.substring(0, email.indexOf("@"));
  QuerySnapshot<Map<String, dynamic>> allData;
  Map<String, List> dataFirebase = {};
  allData = await FirebaseFirestore.instance.collection(collectionName).get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> element in allData.docs) {
    List<Map> dataDocument = [];
    element.data().forEach(
      (key, value) {
        dataDocument.add(value);
      },
    );
    dataFirebase[element.id] = dataDocument;
  }
  return dataFirebase;
}

firebsaeSignIn(String email, String password) async {
  try {
    var respons = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    return respons;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      errorSnackBar("Make sure the email is correct");
    } else if (e.code == 'wrong-password') {
      errorSnackBar("Make sure the password is correct");
    } else {
      errorSnackBar("Make sure the password and Email is correct");
    }
  } catch (e) {
    errorSnackBar(e.toString());
  }
}

firebaseSignUp(String email, String password) async {
  try {
    var respons = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return respons;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      errorSnackBar('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      errorSnackBar('The account already exists for that email.');
    }
  } catch (e) {
    errorSnackBar(e.toString());
  }
}

deletRowFirebase(String document, int id) async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String collectionName = email.substring(0, email.indexOf("@"));
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != [ConnectivityResult.none]) {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(document)
          .update({'$id': FieldValue.delete()});
      return true;
    } catch (e) {
      return false;
    }
  } else {
    return false;
  }
}
