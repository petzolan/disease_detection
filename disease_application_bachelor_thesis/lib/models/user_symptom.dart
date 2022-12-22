import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disease_application_bachelor_thesis/models/body_part_model.dart';
import 'package:disease_application_bachelor_thesis/models/symptom_model.dart';

enum SymptomIntensity {
  low(0.01),
  medium(0.5),
  high(1);

  const SymptomIntensity(this.value);
  final num value;
  
  getSymptomIntensity(int pInt) {
    switch (pInt) {
      case 0:
        return SymptomIntensity.low;
      case 1:
        return SymptomIntensity.medium;
      case 2:
        return SymptomIntensity.high;
      default:
    }
  }
}

enum NovelityFactor {
  old(1),
  veryNew(3);

  const NovelityFactor(this.value);
  final num value;
}

class UserSymptom extends Symptom {
  NovelityFactor novelityFactor;
  SymptomIntensity symptomIntensity;

  UserSymptom(this.symptomIntensity, this.novelityFactor, Symptom pSymptom)
      : super(
          id: pSymptom.id,
          name: pSymptom.name,
          defaultWeight: pSymptom.defaultWeight,
          symptoms: pSymptom.symptoms,
        ) {
    print("Created new User Symptom");
  }
  
}
