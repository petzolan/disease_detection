import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/advice_model.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/doctor_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/services/convert_service.dart';

class DatabaseService {
  /* CREATE AN INSTANCE OF THE DATABASE */
  DatabaseService._();
  static DatabaseService _instance = DatabaseService._();
  static DatabaseService get instance => _instance;

  /* GET REFERENCES */
  final CollectionReference _bodyPartReference =
      FirebaseFirestore.instance.collection('body_parts');

  final CollectionReference _symptomCollectionReference =
      FirebaseFirestore.instance.collection('symptoms');

  final CollectionReference _diseasesCollectionReference =
      FirebaseFirestore.instance.collection('diseases');

  final CollectionReference _adviceCollectionReference =
      FirebaseFirestore.instance.collection('advices');

  final CollectionReference _doctorCollectionReference =
      FirebaseFirestore.instance.collection('doctors');
  /* GET BODY PART DATA */
  getAllBodyParts() {
    return _bodyPartReference.snapshots();
  }

  Future<List<BodyPart>> retrieveBodyParts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _bodyPartReference.get() as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => BodyPart.fromDocumentSnapshot(docSnapshot))
        .toList();
   }

  Future<BodyPart> getBodyPart(String pName) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _bodyPartReference
        .where("name", isEqualTo: pName)
        .snapshots()
        .first as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => BodyPart.fromDocumentSnapshot(docSnapshot))
        .toList()
        .first;
  }

  void addNewBodyPart(String pID, BodyPart pBodyPart) async {
    try {
      _bodyPartReference.doc(pID).set(pBodyPart.toMap());
    } catch (e) {
      print(e);
    }
  }

  bool checkIfBodyPartExists(String pID) {
    var docRef = _bodyPartReference.doc(pID);
    bool b = false;
    docRef.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            {
              b = true,
            }
          else
            {
              b = false,
            }
        });
    return b;
  }

  Future<List<Disease>> getDiseasesBasedOnSelectedSymptoms(
      List<Symptom> pSelectedSymptoms) async {
    List<String> symptomIds = [];
    for (var element in pSelectedSymptoms) {
      symptomIds.add(element.name.replaceAll(" ", "_").toLowerCase());
    }
    symptomIds = symptomIds.toSet().toList();
    print(symptomIds);

    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _diseasesCollectionReference.get()
            as QuerySnapshot<Map<String, dynamic>>;
    List<Disease> diseasesWithSymptoms = snapshot.docs
        .map((docSnapshot) => Disease.fromDocumentSnapshot(docSnapshot))
        .toList();

    List<Disease> toReturn = [];
    for (var element in diseasesWithSymptoms) {
      for (var symptom in symptomIds) {
        if (element.symptoms.containsKey(symptom)) {
          toReturn.add(element);
        }
      }
    }
    final categoryNumbers = toReturn.map((e) => e.name).toSet();

    toReturn.retainWhere((x) => categoryNumbers.remove(x.name));
    return toReturn;
  }

  /* GET SYMPTOM DATA */
  getAllSymptoms() {
    return _symptomCollectionReference.snapshots();
  }

  bool checkIfSymptomExists(String pID) {
    var docRef = _symptomCollectionReference.doc(pID);
    bool b = false;
    docRef.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            {
              b = true,
            }
          else
            {
              b = false,
            }
        });
    return b;
  }

  Future<List<Symptom>> retrieveSymptoms() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _symptomCollectionReference.get()
            as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Symptom.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Symptom>> getSymptoms(List<String> pSymptomIDS) async {
    List<Symptom> fill = [];
    for (var element in pSymptomIDS) {
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _symptomCollectionReference
              .where(FieldPath.documentId, isEqualTo: element)
              .get() as QuerySnapshot<Map<String, dynamic>>;
      fill.addAll(snapshot.docs
          .map((docSnapshot) => Symptom.fromDocumentSnapshot(docSnapshot))
          .toList());
    }
    // QuerySnapshot<Map<String, dynamic>> snapshot =
    //     await _symptomCollectionReference
    //         .where(FieldPath.documentId, whereIn: pSymptomIDS)
    //         .get() as QuerySnapshot<Map<String, dynamic>>;
    return fill;
  }

  void updateSymptom(Symptom pData) async {
    try {
      _symptomCollectionReference.doc(pData.id).update(pData.toMap());
    } catch (e) {
      print(e);
    }
  }

  void addNewSymptom(String pID, Symptom pSymptom) async {
    try {
      _symptomCollectionReference.doc(pID).set(pSymptom.toMap());
    } catch (e) {
      print(e);
    }
  }

  void deleteSymptom(Symptom pData) async {
    try {
      _symptomCollectionReference.doc(pData.id).delete();
    } catch (e) {
      print(e);
    }
  }

  /* GET DISEASE DATA */
  getAllDiseases() {
    return _diseasesCollectionReference.snapshots();
  }

  Future<List<Disease>> retrieveDisease() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _diseasesCollectionReference.get()
            as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Disease.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  bool checkIfDiseaseExists(String pID) {
    var docRef = _diseasesCollectionReference.doc(pID);
    bool b = false;
    docRef.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            {
              b = true,
            }
          else
            {
              b = false,
            }
        });
    return b;
  }

  void updateDisease(Disease pData) async {
    try {
      _diseasesCollectionReference.doc(pData.id).update(pData.toMap());
    } catch (e) {
      print(e);
    }
  }

  void addNewDisease(String pID, Disease pDisease) async {
    try {
      _diseasesCollectionReference.doc(pID).set(pDisease.toMap());
    } catch (e) {
      print(e);
    }
  }

  void deleteDisease(Disease pData) async {
    try {
      _diseasesCollectionReference.doc(pData.id).delete();
    } catch (e) {
      print(e);
    }
  }

  /* GET ADVICE DATA */
  getAllAdvices() {
    return _adviceCollectionReference.snapshots();
  }

  Future<List<Advice>> retrieveAdvices() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _adviceCollectionReference.get()
            as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Advice.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  void addNewAdvice(String pID, Advice pAdvice) async {
    try {
      _adviceCollectionReference.doc(pID).set(pAdvice.toMap());
    } catch (e) {
      print(e);
    }
  }

  void updateAdvice(Advice pData) async {
    try {
      _adviceCollectionReference.doc(pData.id).update(pData.toMap());
    } catch (e) {
      print(e);
    }
  }

  void deleteAdvice(Advice pData) async {
    try {
      _adviceCollectionReference.doc(pData.id).delete();
    } catch (e) {
      print(e);
    }
  }
  /* DOCTOR OPERATIONS */

  getAllDoctors() {
    return _doctorCollectionReference.snapshots();
  }

  Future<List<Doctor>> retriveDoctors() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _doctorCollectionReference.get()
            as QuerySnapshot<Map<String, dynamic>>;
    return snapshot.docs
        .map((docSnapshot) => Doctor.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  void addNewDoctor(String pDoctorID, Object? data) async {
    await _doctorCollectionReference.doc(pDoctorID).set(data);
  }
}
