import 'dart:math';

import 'package:disease_application_bachelor_thesis/models/disease_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';
import 'package:disease_application_bachelor_thesis/models/user_symptom.dart';
import 'package:disease_application_bachelor_thesis/services/database_service.dart';
import 'package:test/scaffolding.dart';

class DiagnoseService {
  /* CREATE AN INSTANCE OF THE DATABASE */
  DiagnoseService._();
  static final DiagnoseService _instance = DiagnoseService._();
  static DiagnoseService get instance => _instance;

  calculateWordMatchPercentageSIMPLE(
    List<UserSymptom> pPresentSymptoms,
  ) async {
    Stopwatch stopwatch = new Stopwatch()..start();

    for (var element in pPresentSymptoms) {
      element.defaultWeight = _calculateImportancePresentSymptom(
        element.defaultWeight,
        element.symptomIntensity,
        element.novelityFactor,
      );
    }

    // ALL DISEASES ASSOCIATED WITH THE SELECTED SYMPTOMS
    List<Disease> allSDiseasesWithSelectedSymptoms = await DatabaseService
        .instance
        .getDiseasesBasedOnSelectedSymptoms(pPresentSymptoms);
    num lambda = 0;
    Map<String, num> matches = {};
    num heighestDiseaseWeight = 0;
    num lambdaZaehlerPart = 1 / allSDiseasesWithSelectedSymptoms.length;
    for (Disease disease in allSDiseasesWithSelectedSymptoms) {
      // GET ALL SYMPTOMS OF THE DISEASE
      List<Symptom> allSymptoms = [];

      allSymptoms.addAll(
        await DatabaseService.instance.getSymptoms(
          disease.symptoms.keys.toList(),
        ),
      );
      // DELETE DUPLICATES OF ALL SYMPTOMS
      // GET ALL ABSENT SYMPTOMS BASED ON THE DISEASE
      List<Symptom> absentSymptoms = [];
      absentSymptoms = _getAllAbsentSymptoms(allSymptoms, pPresentSymptoms);

      // Calc disease-symptom relation
      Map<String, num> relations = {};
      for (Symptom symptom in allSymptoms) {
        relations[symptom.name] = _calcRelation(disease, symptom);
      }

      // CALCULATE THE PRECISION OF THE DISEASE
      num preci = _calcPrecision(
        allSymptoms,
        pPresentSymptoms,
        absentSymptoms,
        disease,
        relations,
      );

      num recall = _calcRecall(
        allSymptoms,
        pPresentSymptoms,
        absentSymptoms,
        disease,
        relations,
      );

      matches[disease.name] = _calcMatchingToDisease(preci, recall);
      print(
          "MATCHING: " + disease.name + " " + matches[disease.name].toString());
      if (disease.occurrence_probability > heighestDiseaseWeight) {
        heighestDiseaseWeight = disease.occurrence_probability;
      }
    }
    lambda = _calcLambda(
      matches,
      heighestDiseaseWeight,
      lambdaZaehlerPart,
    );

    for (var disease in allSDiseasesWithSelectedSymptoms) {
      _calcOverallRanking(matches[disease.name]!, lambda, disease);
    }
    print(
        'calculateWordMatchPercentageSIMPLE() executed in ${stopwatch.elapsed}');
  }

  _calculateConditionalProbability(Symptom pSymptom, Disease pDisease) {
    var probability =
        (pSymptom.defaultWeight / pDisease.occurrence_probability);
    return probability;
  }

  _getAllAbsentSymptoms(
    List<Symptom> pAllSymptoms,
    List<Symptom> pSelectedSymptoms,
  ) {
    List<Symptom> absent = [];
    absent.addAll(pAllSymptoms);
    for (var symptom in pSelectedSymptoms) {
      absent.removeWhere((x) => x.name == symptom.name);
    }

    return absent;
  }

  // GET UNITION OF TWO LISTS WITHOUT DUPLICATES
  List<Symptom> _getUnion(List<Symptom> pA, List<Symptom> pB) {
    var newList = [...pA, ...pB].toSet().toList();
    return newList;
  }

  _calcMatchingToDisease(var prec, var recall) {
    return 2 * ((prec * recall) / (prec + recall));
  }

  _getIntersecation(List<Symptom> pAll, List<Symptom> pSelected) {
    List<Symptom> intersection = [];
    List<String> allSymptomsNames = [];
    List<String> allSelectedNames = [];

    for (var symDiseases in pAll) {
      allSymptomsNames.add(symDiseases.name);
    }

    for (var symDiseases in pSelected) {
      allSelectedNames.add(symDiseases.name);
    }

    List<String> intersectionStrings = allSymptomsNames
        .toSet()
        .intersection(allSelectedNames.toSet())
        .toList();
    for (var element in pAll) {
      if (intersectionStrings.contains(element.name)) {
        intersection.add(element);
      }
    }
    return intersection;
  }

  _calcPrecision(
    List<Symptom> diseaseSymptoms,
    List<Symptom> selectedSymptoms,
    List<Symptom> absentSymptoms,
    Disease disease,
    Map<String, num> relations,
  ) {
    List<Symptom> zaehler =
        _getIntersecation(diseaseSymptoms, selectedSymptoms);

    List<Symptom> nenner = _getIntersecation(
        diseaseSymptoms, _getUnion(selectedSymptoms, absentSymptoms));

    num sumZaehler = 0;
    num sumNenner = 0;

    for (Symptom symptom in zaehler) {
      sumZaehler += symptom.defaultWeight * relations[symptom.name]!;
    }

    for (Symptom symptom in nenner) {
      sumNenner += symptom.defaultWeight * relations[symptom.name]!;
    }

    num precision = sumZaehler / sumNenner;
    print("Preci " + precision.toString());
    return precision;
  }

  _calcRecall(
    List<Symptom> diseaseSymptoms,
    List<Symptom> selectedSymptoms,
    List<Symptom> absentSymptoms,
    Disease disease,
    Map<String, num> relations,
  ) {
    List<Symptom> zaehler =
        _getIntersecation(diseaseSymptoms, selectedSymptoms);

    List<Symptom> nenner = selectedSymptoms;

    num sumZaehler = 0;
    num sumNenner = 0;

    for (Symptom symptom in zaehler) {
      sumZaehler += symptom.defaultWeight;
    }

    for (Symptom symptom in nenner) {
      sumNenner += symptom.defaultWeight;
    }

    num precision = sumZaehler / sumNenner;
    print("Recall " + precision.toString());
    return precision;
  }

  _calculateImportancePresentSymptom(
    num pDefaultWeight,
    SymptomIntensity pSymptomIntensity,
    NovelityFactor pNovelityFactor,
  ) {
    num importance = 1;

    importance = pDefaultWeight *
        (1 + pSymptomIntensity.value) *
        (pNovelityFactor.value);
    return importance;
  }

  _calculateImportanceOtherSymptoms(int pDefaultWeight) {
    return pDefaultWeight;
  }

  num _calcRelation(Disease pDisease, Symptom pSymptom) {
    num rel = 1;
    rel = _calculateConditionalProbability(pSymptom, pDisease) *
        pDisease.symptoms[pSymptom.id];
    return rel;
  }

  num _calcLambda(
    Map<String, num> pMatches,
    num pWeight,
    num p1,
  ) {
    num lambda = 0;
    num zaehler = 0;
    for (var element in pMatches.values) {
      zaehler += element;
    }

    zaehler = zaehler * p1;

    lambda = zaehler / pWeight;
    print("LAMBDA " + lambda.toString());
    return lambda;
  }

  _calcOverallRanking(num pMatching, num pLambda, Disease pDisease) {
    num ranking = 0;
    ranking = pMatching + pLambda * pDisease.occurrence_probability;
    print("RANKING: " + ranking.toString());
    return ranking;
  }
}
