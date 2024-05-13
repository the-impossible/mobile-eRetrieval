import 'package:cloud_firestore/cloud_firestore.dart';

class PastQuestions {
  final String id;
  final String course;
  final String level;
  final String semester;
  final String session;
  final String fileName;

  PastQuestions({
    required this.id,
    required this.course,
    required this.level,
    required this.semester,
    required this.session,
    required this.fileName,
  });

  factory PastQuestions.fromJson(DocumentSnapshot snapshot) {
    return PastQuestions(
      id: snapshot.id,
      course: snapshot['course'],
      level: snapshot['level'],
      semester: snapshot['semester'],
      session: snapshot['session'],
      fileName: snapshot['fileName'],
    );
  }
}
