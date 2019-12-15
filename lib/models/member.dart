// models/member.dart

import 'feedback.dart';

class Member {
  String id;
  String name;
  DateTime createdAt;
  final List<Feedback> feedbacks;

  Member(this.id, this.name, this.createdAt, this.feedbacks);
}
